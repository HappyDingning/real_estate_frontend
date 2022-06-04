import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'fade_in_score.dart';
import 'tokens/metamask.dart';
import 'tokens/tokens.dart';
import 'transaction_list.dart';
import 'search.dart';
import 'real_estate_detail.dart';
import 'register_real_estate.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final ScrollController scrollController = ScrollController();
  static const double expandedHeight = 250.0;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => metamask),
        ChangeNotifierProvider(create: (context) => token),
      ],
      builder: (context, child) {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
            },
            child: Consumer2<MetaMaskProvider, TokenProvider>(
              builder: ((context, metamaskProvider, tokenProvider, child) {
                if (metamaskProvider.isEnabled &&
                    metamaskProvider.isConnected &&
                    metamaskProvider.isTargetChain) {
                  return CustomScrollView(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: <Widget>[
                      SliverAppBar(
                        pinned: true,
                        expandedHeight: expandedHeight,
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.search_rounded),
                            tooltip: '查询交易或资产',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Search()
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.checklist_rounded),
                            tooltip: '交易记录',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TransactionList()
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_rounded),
                            tooltip: '注册资产',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterRealEstate()
                                ),
                              );
                            },
                          ),
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            alignment: Alignment.topLeft,
                            height: expandedHeight,
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(16.0, kToolbarHeight, 16.0, 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          textBaseline: TextBaseline.alphabetic,
                                          crossAxisAlignment: CrossAxisAlignment.baseline,
                                          children: const [
                                            Text("0", style: TextStyle(height: 1.0, fontWeight: FontWeight.bold, fontSize: 60, color: Colors.white)),
                                            Text("ETH", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 25, color: Colors.white))
                                          ],
                                        ),
                                        const Text("今日收益", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white))
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          textBaseline: TextBaseline.alphabetic,
                                          crossAxisAlignment: CrossAxisAlignment.baseline,
                                          children: const [
                                            Text("0", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 60, color: Colors.white)),
                                            Text("处", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 25, color: Colors.white)),
                                          ],
                                        ),
                                        const Text("已投资的不动产", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white))
                                      ],
                                    ),
                                  ],
                                ),
                                // 本周收益和本月收益列
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          textBaseline: TextBaseline.alphabetic,
                                          crossAxisAlignment: CrossAxisAlignment.baseline,
                                          children: const [
                                            Text("0", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white)),
                                            Text("ETH", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: Colors.white))
                                          ],
                                        ),
                                        const Text("本周收益", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white))
                                      ],
                                    ),
                                    const Padding(padding: EdgeInsets.only(top: 16.0)),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          textBaseline: TextBaseline.alphabetic,
                                          crossAxisAlignment: CrossAxisAlignment.baseline,
                                          children: const [
                                            Text("0", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white)),
                                            Text("ETH", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: Colors.white))
                                          ],
                                        ),
                                        const Text("本月收益",  style: TextStyle( fontWeight: FontWeight.normal, color: Colors.white))
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ),
                        ),
                        title: FadeOnScroll(
                          scrollController: scrollController,
                          fullOpacityOffset: expandedHeight - kToolbarHeight,
                          zeroOpacityOffset:
                              expandedHeight - kToolbarHeight - 60,
                          child: const Text("资产"),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                          if (tokenProvider.tokens == null || tokenProvider.tokens!.isEmpty) {
                            if (tokenProvider.tokens == null) {
                              return const Center(
                                child: Text("资产载入中..."),
                              );
                            }
                            return const Center(
                              child: Text("暂无资产..."),
                            );
                          } else {
                            return ListTile(
                              title: Text(tokenProvider.tokens![index]["name"] ?? "# ${tokenProvider.tokens![index]["token_id"]}"),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RealEstateDetail(tokenDetail: tokenProvider.tokens![index])
                                  ),
                                );
                              },
                            );
                          }
                        },
                        childCount: tokenProvider.tokens == null ? 
                                    1 : 
                                    tokenProvider.tokens!.length),
                      )
                    ],
                  );
                } else if (metamaskProvider.isEnabled && metamaskProvider.isConnected) {
                  metamask.init();
                  token.init();
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("欢迎", style: TextStyle(fontSize: 30, color: Colors.lightBlue)),
                        const Padding(padding: EdgeInsets.only(top: 16.0)),
                        Text("当前链不支持，请切换到Id为4的链", style: TextStyle(fontSize: 24, color: Colors.red.shade300)),
                        const Padding(padding: EdgeInsets.only(top: 16.0)),
                        ElevatedButton(
                          onPressed: () async {
                            await context.read<MetaMaskProvider>().connect();
                            context.read<MetaMaskProvider>().setListener(context);
                            context.read<TokenProvider>().loadTokens(context);
                          },
                          child: const Text("重新连接")
                        )
                      ],
                    )
                  );
                } else if (metamaskProvider.isEnabled) {
                  metamask.init();
                  token.init();
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("欢迎",style: TextStyle(fontSize: 30, color: Colors.lightBlue)),
                        const Padding(padding: EdgeInsets.only(top: 16.0)),
                        ElevatedButton(
                          onPressed: () async {
                            await context.read<MetaMaskProvider>().connect();
                            context.read<MetaMaskProvider>().setListener(context);
                            context.read<TokenProvider>().loadTokens(context);
                          },
                          child: const Text("连接以太坊钱包")
                        )
                      ],
                    )
                  );
                } else {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("欢迎", style: TextStyle(fontSize: 30, color: Colors.lightBlue)),
                        const Padding(padding: EdgeInsets.only(top: 16.0)),
                        Text("请使用支持web3的浏览器", style: TextStyle(fontSize: 24, color: Colors.red.shade300)),
                      ],
                    )
                  );
                }
              })
            )
          ),
        );
      }
    );
  }
}
