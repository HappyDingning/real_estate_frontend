import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_web3/flutter_web3.dart';
import "package:intl/intl.dart";

import "fade_in_score.dart";
import 'transaction_detail.dart';
import 'tokens/metamask.dart';


class RealEstateDetail extends StatefulWidget {
  const RealEstateDetail({Key? key, required this.tokenDetail}) : super(key: key);

  final Map tokenDetail;

  @override
  _RealEstateDetailState createState() => _RealEstateDetailState();
}

class _RealEstateDetailState extends State<RealEstateDetail> {
  final ScrollController scrollController = ScrollController();
  final rentFormKey = GlobalKey<FormState>();
  final quoteFormKey = GlobalKey<FormState>();

  static const double expandedHeight = 250.0;
  
  BigInt duration_ = BigInt.zero;

  BigInt? rent;
  BigInt? holderNumber;
  BigInt? quote;
  BigInt? balanceOf;
  BigInt? start;
  BigInt? duration;
  String? tenant;
  BigInt? quoteMin;
  BigInt? quoteMax;
  BigInt? quoteMoney;
  bool? isRented;

  _RealEstateDetailState();

  void getDataAndRefresh() {
    Future.wait([
      metamask.contractReadOnly.call<BigInt>('getHolderNumber', [widget.tokenDetail['token_id']]),
      metamask.contractReadOnly.call<BigInt>('getRent', [widget.tokenDetail['token_id']]),
      metamask.contractReadOnly.call<BigInt>('getQuote', [metamask.currentAddress, widget.tokenDetail['token_id']]),
      metamask.contractReadOnly.call<BigInt>('balanceOf', [metamask.currentAddress, widget.tokenDetail['token_id']]),
      metamask.contractReadOnly.call<BigInt>('getStart', [widget.tokenDetail['token_id']]),
      metamask.contractReadOnly.call<BigInt>('getDuration', [widget.tokenDetail['token_id']]),
      metamask.contractReadOnly.call<String>('getTenant', [widget.tokenDetail['token_id']]),
    ]).then((values) {
      setState(() {
        holderNumber = BigInt.parse(values[0].toString());
        rent = BigInt.parse(values[1].toString());
        quote = BigInt.parse(values[2].toString());
        balanceOf = BigInt.parse(values[3].toString());
        start = BigInt.parse(values[4].toString());
        duration = BigInt.parse(values[5].toString());
        isRented = start! + duration! > BigInt.from(DateTime.now().millisecondsSinceEpoch / 1000);
        tenant = values[6].toString();
      });
    }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('无法获取房地产信息')),
        );
    });

    metamask.contractReadOnly.call<List<dynamic>>('getQuoteMinAndQuoteMax', [metamask.currentAddress, widget.tokenDetail['token_id']]).then((value) async {
      setState(() {
        quoteMin = BigInt.parse(value[0].toString());
        quoteMax = BigInt.parse(value[1].toString());
      });
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('无法获取租金投票范围')),
      );
    });
  }

  void clear() {
    duration_ = BigInt.zero;

    rent = null;
    holderNumber = null;
    quote = null;
    balanceOf = null;
    start = null;
    duration = null;
    tenant = "";
    quoteMin = null;
    quoteMax = null;
    quoteMoney = null;
    isRented = null;
  }

  @override
  void initState() {
    super.initState();

    clear();

    getDataAndRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          clear();
          getDataAndRefresh();
        },
        child: CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            SliverAppBar(
              leading: IconButton(
                tooltip: "返回",
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              pinned: true,
              expandedHeight: expandedHeight,
              actions: [
                IconButton(
                  icon: const Icon(Icons.front_hand_rounded),
                  tooltip: '设置租金',
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => StatefulBuilder(
                      builder: (BuildContext context, void Function(void Function()) setState) => AlertDialog(
                        title: const Text('设置租金'),
                        content: SizedBox(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Form(
                                key: quoteFormKey,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    label: Text('报价 Wei/天'),
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '请输入报价';
                                    }

                                    if (quoteMax != null && quoteMin != null && quoteMax != quoteMin) {
                                      if (BigInt.parse(value) > quoteMax! || BigInt.parse(value) < quoteMin!) {
                                        return '报价必须处于最小值与最大值之间';
                                      }
                                    }

                                    return null;
                                  },
                                  onChanged: (String value) {
                                    setState(() {
                                      if (value.isEmpty) {
                                        quoteMoney = BigInt.zero;
                                      }
                                      else {
                                        quoteMoney = BigInt.parse(value);
                                      }
                                    });
                                  },
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(top: 10)),
                              rent == null ?
                                const Text("正在获取加权租金") :
                                Text("当前加权租金: ${NumberFormat('0,000').format(rent!.toInt())} Wei/天"),
                              const Padding(padding: EdgeInsets.only(top: 10)),
                              quote == null ?
                                const Text("正在获取您当前的报价", style: TextStyle(fontSize: 16)) :
                                Text("您当前的报价: ${NumberFormat('0,000').format(quote!.toInt())} Wei/天", style: const TextStyle(fontSize: 16)),
                              const Padding(padding: EdgeInsets.only(top: 10)),
                              quoteMin == null && quoteMax == null ?
                                const Text("正在获取报价范围") :
                                quoteMin != quoteMax ? 
                                  Text("您的报价范围: \n小于: \n${NumberFormat('0,000').format(quoteMin!.toInt())} Wei/天 \n大于: \n${NumberFormat('0,000').format(quoteMax!.toInt())} Wei/天") :
                                  const Text("您的报价不受限制"),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              duration_ = BigInt.zero;
                              Navigator.pop(context);
                            },
                            child: const Text('取消'),
                          ),
                          TextButton(
                            onPressed: () {
                              if (quoteFormKey.currentState!.validate()) {
                                metamask.contractReadWrite.send('updateQuote', [widget.tokenDetail["token_id"], quoteMoney]).then((value) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('交易已提交，正在等待确认')),
                                  );
                                }).catchError((e) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('交易取消')),
                                  );
                                });
                              }
                            },
                            child: const Text('确定'),
                          ),
                        ],
                      ),
                    )
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.luggage_rounded),
                  tooltip: '租赁',
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, void Function(void Function()) setState) => AlertDialog(
                          title: const Text('租赁'),
                          content: rent == null ? 
                            const SizedBox(
                              child: Text('无法获取加权租金，请稍后重试'),
                            ) :
                            SizedBox(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Form(
                                    key: rentFormKey,
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        label: Text('租赁时长(天)'),
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                      ],
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return '请输入租赁时长';
                                        }
                                        return null;
                                      },
                                      onChanged: (String value) {
                                        setState(() {
                                          if (value.isEmpty) {
                                            duration_ = BigInt.zero;
                                          }
                                          else {
                                            duration_ = BigInt.parse(value);
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  const Padding(padding: EdgeInsets.only(top: 10)),
                                  Text("加权租金: ${NumberFormat('0,000').format(rent!.toInt())} Wei/天"),
                                  const Padding(padding: EdgeInsets.only(top: 10)),
                                  Text("合计金额: ${NumberFormat('0,000').format((duration_ * rent!).toInt())} Wei")
                                ],
                              ),
                            ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                duration_ = BigInt.zero;
                                Navigator.pop(context);
                              },
                              child: const Text('取消'),
                            ),
                            TextButton(
                              onPressed: () {
                                if (rent == null) {
                                  Navigator.pop(context);
                                  return;
                                }

                                if (rentFormKey.currentState!.validate()) {
                                  metamask.contractReadWrite.send('rent', [widget.tokenDetail["token_id"], duration_ * BigInt.from(86400)], TransactionOverride(value: (duration_ * rent!))).then((TransactionResponse response) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('交易已提交，正在等待确认')),
                                    );
                                  }).catchError((e) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('交易取消')),
                                    );
                                  });
                                }
                                duration_ = BigInt.zero;
                              },
                              child: const Text('确定'),
                            ),
                          ],
                        ),
                      );
                    }
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Image(
                  image: NetworkImage(widget.tokenDetail["image_original_url"] ?? ""),
                  height: expandedHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return const Center(
                      child: Text("图像载入中...", style: TextStyle(color: Colors.white)),
                    );
                  },
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return const Center(
                      child: Text("图像载入失败", style: TextStyle(color: Colors.white)),
                    );
                  },
                ),
              ),
              title: FadeOnScroll(
                scrollController: scrollController,
                fullOpacityOffset: expandedHeight-kToolbarHeight,
                zeroOpacityOffset: expandedHeight-kToolbarHeight - 60,
                child: const Text("资产明细"),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index == 0) {
                    return Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.tokenDetail['name'] ?? "未命名房地产", style: const TextStyle(fontSize: 28)),
                          const Padding(padding: EdgeInsets.only(top: 8)),
                          Text("房地产ID: ${widget.tokenDetail["token_id"]}", style: const TextStyle(fontSize: 16)),
                          holderNumber == null ? 
                            const Text("正在获取持有人数", style: TextStyle(fontSize: 16)) :
                            Text("持有者: $holderNumber 人", style: const TextStyle(fontSize: 16)),
                          const Text("发行量: 1,000,000,000,000,000,000", style: TextStyle(fontSize: 16)),
                          balanceOf == null ?
                            const Text("正在获取持有数量", style: TextStyle(fontSize: 16)) :
                            Text("持有量: ${NumberFormat('0,000').format(balanceOf!.toInt())} (${(balanceOf!.toDouble() / 1e16).toStringAsFixed(3)}%)", style: const TextStyle(fontSize: 16)),
                          rent == null ?
                            const Text("正在获取加权租金", style: TextStyle(fontSize: 16)) :
                            Text("加权租金: ${NumberFormat('0,000').format(rent!.toInt())} Wei/天", style: const TextStyle(fontSize: 16)),
                          isRented == null ? 
                            const Text("正在获取租赁状态", style: TextStyle(fontSize: 16)) : 
                            isRented! ?
                              const Text("租赁状态: 已出租", style: TextStyle(fontSize: 16, color: Colors.red)) :
                              const Text("租赁状态: 待出租", style: TextStyle(fontSize: 16, color: Colors.green)),
                          if (isRented != null && isRented!)
                            Text("租户: $tenant", style: const TextStyle(fontSize: 16)),
                          if (isRented != null && isRented!)
                            Text("租赁到期时间: ${DateTime.fromMillisecondsSinceEpoch(1000 * (start! + duration!).toInt())}", style: const TextStyle(fontSize: 16)),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Center(
                              child: Text('简介', style: TextStyle(fontSize: 18)),
                            )
                          ),
                          Divider(height: 1.0, color: Colors.grey[300]),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                            child: Text(widget.tokenDetail['description'] ?? "未填写描述信息", style: const TextStyle(fontSize: 16)),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Center(
                              child: Text('交易记录', style: TextStyle(fontSize: 18)),
                            )
                          ),
                          Divider(height: 0, color: Colors.grey[300]),
                        ],
                      ),
                    );
                  }
                  else {
                    return ListTile(
                      title: const Text("0xe78b16bb536d31d767c1ca32384fa83b9c3ceaf1"),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
                      },
                    );
                  }
                }, childCount: 10,
              )
            )
          ],
        ),
      ),
    );
  }
}
