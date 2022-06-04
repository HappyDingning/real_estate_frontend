import 'package:flutter/material.dart';

class TransactionDetail extends StatefulWidget {
  const TransactionDetail({Key? key}) : super(key: key);

  @override
  _TransactionDetailState createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('交易详情'),
      ),
      body: ListView(
        children: const <Widget>[
          ListTile(
            title: Text("交易哈希:"),
            subtitle: Text("0x7e8dc4d40d1a05b60fa17818b202a84e1c3c5dd0e93f7433cc8349e244611337"),
          ),
          ListTile(
            title: Text("状态:"),
            subtitle: Text("成功", style: TextStyle(color: Colors.green),),
          ),
          ListTile(
            title: Text("区块:"),
            subtitle: Text("14678371"),
          ),
          ListTile(
            title: Text("时间:"),
            subtitle: Text("2 分钟以前 (Apr-29-2022 09:23:46 AM +UTC)|  30 秒 内确认"),
          ),
          ListTile(
            title: Text("发起者:"),
            subtitle: Text("0x00192fb10df37c9fb26829eb2cc623cd1bf599e8"),
          ),
          ListTile(
            title: Text("接收者:"),
            subtitle: Text("0xe78b16bb536d31d767c1ca32384fa83b9c3ceaf1"),
          ),
          ListTile(
            title: Text("转账金额:"),
            subtitle: Text("0.033338108 Ether"),
          ),
          ListTile(
            title: Text("交易费:"),
            subtitle: Text("0.000662335523052 Ether"),
          ),
          ListTile(
            title: Text("Gas价格:"),
            subtitle: Text("0.000000031539786812 Ether (31.539786812 Gwei)"),
          ),
          ListTile(
            title: Text("Gas量限制和实际使用量:"),
            subtitle: Text("21,000 | 21,000 (100%)"),
          ),
          ListTile(
            title: Text("Gas费:"),
            subtitle: Text("Base: 30.539786812 Gwei |Max: 80 Gwei |Max Priority: 1 Gwei"),
          ),
        ],
      ),
    );
  }
}
