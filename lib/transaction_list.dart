import 'package:flutter/material.dart';
import 'transaction_detail.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({Key? key}) : super(key: key);

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('交易记录'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('0x7e8dc4d40d1a05b60fa17818b202a84e1c3c5dd0e93f7433cc8349e244611337', style: TextStyle(overflow: TextOverflow.ellipsis)),
              subtitle: const Text('收入 0.45 ETH', style: TextStyle(overflow: TextOverflow.ellipsis)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
              },
            ),
            ListTile(
              title: const Text('0x4faac6c53b6e60fb86e4b01c03c44c143c5837d329654b969f26882d4163fd97', style: TextStyle(overflow: TextOverflow.ellipsis)),
              subtitle: const Text('收入 0.23 ETH', style: TextStyle(overflow: TextOverflow.ellipsis)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
              },
            ),
            ListTile(
              title: const Text('0x1794cef05c1cb050ca25b7aae7721094fc4b1cad74f5a6849e3eaff99fc4dab3', style: TextStyle(overflow: TextOverflow.ellipsis)),
              subtitle: const Text('支出 0.38 ETH', style: TextStyle(overflow: TextOverflow.ellipsis)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
              },
            ),
            ListTile(
              title: const Text('0xcfffcad42c7e0a0fcaeef53a4920a44bb5a38436fa2731954b883cee0c61ea69', style: TextStyle(overflow: TextOverflow.ellipsis)),
              subtitle: const Text('收入 0.67 ETH', style: TextStyle(overflow: TextOverflow.ellipsis)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
              },
            ),
            ListTile(
              title: const Text('0xfdcb3f353fc93c232f414337e85b6e8d1adc267df73d67c8c3a5a368068c574d', style: TextStyle(overflow: TextOverflow.ellipsis)),
              subtitle: const Text('支出 0.62 ETH', style: TextStyle(overflow: TextOverflow.ellipsis)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
              },
            ),
            ListTile(
              title: const Text('0xc4dafe1c655971b0aaa7aa0b822c34e5b96c6de3826dcd88f441ac2e378a8631', style: TextStyle(overflow: TextOverflow.ellipsis)),
              subtitle: const Text('支出 0.17 ETH', style: TextStyle(overflow: TextOverflow.ellipsis)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
              },
            ),
            ListTile(
              title: const Text('0xe95297f6401924bcd4591c5926bf48d89bbdab4b43be3c232f414337e85b6e8f', style: TextStyle(overflow: TextOverflow.ellipsis)),
              subtitle: const Text('收入 0.14 ETH', style: TextStyle(overflow: TextOverflow.ellipsis)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
              },
            ),
            ListTile(
              title: const Text('0x7e8dc4d40d1a05b60fa17818b202a84e1c3c5dd0e93f7433cc8349e244611337', style: TextStyle(overflow: TextOverflow.ellipsis)),
              subtitle: const Text('收入 0.45 ETH', style: TextStyle(overflow: TextOverflow.ellipsis)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
              },
            ),
            ListTile(
              title: const Text('0x4faac6c53b6e60fb86e4b01c03c44c143c5837d329654b969f26882d4163fd97', style: TextStyle(overflow: TextOverflow.ellipsis)),
              subtitle: const Text('收入 0.23 ETH', style: TextStyle(overflow: TextOverflow.ellipsis)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
              },
            ),
            ListTile(
              title: const Text('0x1794cef05c1cb050ca25b7aae7721094fc4b1cad74f5a6849e3eaff99fc4dab3', style: TextStyle(overflow: TextOverflow.ellipsis)),
              subtitle: const Text('支出 0.38 ETH', style: TextStyle(overflow: TextOverflow.ellipsis)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
              },
            ),
            ListTile(
              title: const Text('0xcfffcad42c7e0a0fcaeef53a4920a44bb5a38436fa2731954b883cee0c61ea69', style: TextStyle(overflow: TextOverflow.ellipsis)),
              subtitle: const Text('收入 0.67 ETH', style: TextStyle(overflow: TextOverflow.ellipsis)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
              },
            ),
            ListTile(
              title: const Text('0xfdcb3f353fc93c232f414337e85b6e8d1adc267df73d67c8c3a5a368068c574d', style: TextStyle(overflow: TextOverflow.ellipsis)),
              subtitle: const Text('支出 0.62 ETH', style: TextStyle(overflow: TextOverflow.ellipsis)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
              },
            ),
            ListTile(
              title: const Text('0xc4dafe1c655971b0aaa7aa0b822c34e5b96c6de3826dcd88f441ac2e378a8631', style: TextStyle(overflow: TextOverflow.ellipsis)),
              subtitle: const Text('支出 0.17 ETH', style: TextStyle(overflow: TextOverflow.ellipsis)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
              },
            ),
            ListTile(
              title: const Text('0xe95297f6401924bcd4591c5926bf48d89bbdab4b43be3c232f414337e85b6e8f', style: TextStyle(overflow: TextOverflow.ellipsis)),
              subtitle: const Text('收入 0.14 ETH', style: TextStyle(overflow: TextOverflow.ellipsis)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetail()));
              },
            ),
          ]
        ),
      ),
    );
  }
}
