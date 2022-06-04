import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'transaction_detail.dart';

import 'real_estate_detail.dart';
import 'tokens/metamask.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State {
  final searchFormKey = GlobalKey<FormState>();
  String searchContent = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            padding: const EdgeInsets.only(right: 16, left: 16),
            tooltip: '查询',
            onPressed: () {
              if (!searchFormKey.currentState!.validate()) {
                return;
              }

              if (searchContent.startsWith("0x")) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("还没有实现查询交易的功能!"))
                );
              }
              else {
                Uri url = Uri.parse("https://testnets-api.opensea.io/api/v1/assets?asset_contract_address=${metamask.contractReadOnly.address}&token_ids=$searchContent");
                get(url).then((response) {
                  if (response.statusCode == 200) {
                    var token = jsonDecode(response.body)["assets"][0];
                    token["name"] = "#${token["token_id"]}";
                    token["description"] = "暂无信息";
                    token["image_original_url"] = "";

                    metamask.contractReadOnly.call<String>('uri', [token["token_id"]]).then((value) async {
                      String tokenIdString = int.parse(token["token_id"]).toRadixString(16).toUpperCase();
                      Uri uri = Uri.parse(value.replaceFirst("{id}", tokenIdString.padLeft(64, '0')));

                      get(uri).then((response) {
                        if (response.statusCode == 200) {
                          token["name"] = jsonDecode(response.body)["name"];
                          token["description"] = jsonDecode(response.body)["description"];
                          token["image_original_url"] = jsonDecode(response.body)["image"];

                          Navigator.push(context, MaterialPageRoute(builder: (context) => RealEstateDetail(tokenDetail: token)));
                        }
                      });
                    }).catchError((e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('无法获取房地产信息')),
                      );
                    });
                  }
                  else {
                    throw Exception('Failed to load real estates');
                  }
                }).catchError((e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('无法获取该房地产信息')),
                  );
                });
              }
            },
          ),
        ],
        title: Form(
          key: searchFormKey,
          child: TextFormField(
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white12),
              ),
              hintStyle: TextStyle(color: Colors.white60),
              hintText: '请输入交易哈希或房地产ID',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return '请输入交易哈希或房地产ID';
              }
              return null;
            },
            onChanged: (value) {
              if (value.isNotEmpty) {
                searchContent = value;
              }
            },
          ),
        )
      ),
      body: ListView(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: SizedBox(
              height: 20,
              child: Center(
                child: Text('历史记录'),
              ),
            )
          ),
          ListTile(
            title: const Text('0x7e8dc4d40d1a05b60fa17818b202a84e1c3c5dd0e93f7433cc8349e244611337', style: TextStyle(overflow: TextOverflow.ellipsis)),
            subtitle: const Text('交易', style: TextStyle(overflow: TextOverflow.ellipsis)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
            },
          ),
          ListTile(
            title: const Text('0x4faac6c53b6e60fb86e4b01c03c44c143c5837d329654b969f26882d4163fd97', style: TextStyle(overflow: TextOverflow.ellipsis)),
            subtitle: const Text('交易', style: TextStyle(overflow: TextOverflow.ellipsis)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
            },
          ),
          ListTile(
            title: const Text('0x1794cef05c1cb050ca25b7aae7721094fc4b1cad74f5a6849e3eaff99fc4dab3', style: TextStyle(overflow: TextOverflow.ellipsis)),
            subtitle: const Text('资产', style: TextStyle(overflow: TextOverflow.ellipsis)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
            },
          ),
          ListTile(
            title: const Text('0xcfffcad42c7e0a0fcaeef53a4920a44bb5a38436fa2731954b883cee0c61ea69', style: TextStyle(overflow: TextOverflow.ellipsis)),
            subtitle: const Text('资产', style: TextStyle(overflow: TextOverflow.ellipsis)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
            },
          ),
          ListTile(
            title: const Text('0xfdcb3f353fc93c232f414337e85b6e8d1adc267df73d67c8c3a5a368068c574d', style: TextStyle(overflow: TextOverflow.ellipsis)),
            subtitle: const Text('交易', style: TextStyle(overflow: TextOverflow.ellipsis)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
            },
          ),
          ListTile(
            title: const Text('0xc4dafe1c655971b0aaa7aa0b822c34e5b96c6de3826dcd88f441ac2e378a8631', style: TextStyle(overflow: TextOverflow.ellipsis)),
            subtitle: const Text('资产', style: TextStyle(overflow: TextOverflow.ellipsis)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
            },
          ),
          ListTile(
            title: const Text('0xe95297f6401924bcd4591c5926bf48d89bbdab4b43be3c232f414337e85b6e8f', style: TextStyle(overflow: TextOverflow.ellipsis)),
            subtitle: const Text('交易', style: TextStyle(overflow: TextOverflow.ellipsis)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
            },
          ),
          ListTile(
            title: const Text('0x7e8dc4d40d1a05b60fa17818b202a84e1c3c5dd0e93f7433cc8349e244611337', style: TextStyle(overflow: TextOverflow.ellipsis)),
            subtitle: const Text('交易', style: TextStyle(overflow: TextOverflow.ellipsis)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
            },
          ),
          ListTile(
            title: const Text('0x4faac6c53b6e60fb86e4b01c03c44c143c5837d329654b969f26882d4163fd97', style: TextStyle(overflow: TextOverflow.ellipsis)),
            subtitle: const Text('交易', style: TextStyle(overflow: TextOverflow.ellipsis)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
            },
          ),
          ListTile(
            title: const Text('0x1794cef05c1cb050ca25b7aae7721094fc4b1cad74f5a6849e3eaff99fc4dab3', style: TextStyle(overflow: TextOverflow.ellipsis)),
            subtitle: const Text('资产', style: TextStyle(overflow: TextOverflow.ellipsis)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
            },
          ),
          ListTile(
            title: const Text('0xcfffcad42c7e0a0fcaeef53a4920a44bb5a38436fa2731954b883cee0c61ea69', style: TextStyle(overflow: TextOverflow.ellipsis)),
            subtitle: const Text('资产', style: TextStyle(overflow: TextOverflow.ellipsis)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
            },
          ),
          ListTile(
            title: const Text('0xfdcb3f353fc93c232f414337e85b6e8d1adc267df73d67c8c3a5a368068c574d', style: TextStyle(overflow: TextOverflow.ellipsis)),
            subtitle: const Text('交易', style: TextStyle(overflow: TextOverflow.ellipsis)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
            },
          ),
          ListTile(
            title: const Text('0xc4dafe1c655971b0aaa7aa0b822c34e5b96c6de3826dcd88f441ac2e378a8631', style: TextStyle(overflow: TextOverflow.ellipsis)),
            subtitle: const Text('资产', style: TextStyle(overflow: TextOverflow.ellipsis)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
            },
          ),
          ListTile(
            title: const Text('0xe95297f6401924bcd4591c5926bf48d89bbdab4b43be3c232f414337e85b6e8f', style: TextStyle(overflow: TextOverflow.ellipsis)),
            subtitle: const Text('交易', style: TextStyle(overflow: TextOverflow.ellipsis)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
            },
          )
        ]
      )
    );
  }
}
