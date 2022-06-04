import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_web3/flutter_web3.dart';
import 'package:http/http.dart';

import 'contract_settings.dart';

class MetaMaskProvider extends ChangeNotifier {
  late Contract contractReadOnly;
  
  late Contract contractReadWrite;

  late String currentAddress = '';

  int currentChain = -1;

  bool get isTargetChain => currentChain == 4;

  bool get isEnabled => ethereum != null;

  bool get isConnected => isEnabled && currentAddress.isNotEmpty;

  Future<void> connect() async {
    if (isEnabled) {
      final accs = await ethereum!.requestAccount();
      
      if (accs.isNotEmpty) currentAddress = accs.first;

      contractReadOnly = Contract(contractAddress, contractAbi, Web3Provider(ethereum!));

      contractReadWrite =  Contract(contractAddress, Interface(contractAbi), Web3Provider(ethereum!).getSigner());

      currentChain = await ethereum!.getChainId();

      notifyListeners();
    }
  }

  void setListener(BuildContext context) async {   
    final filterTransferSingle = metamask.contractReadOnly.getFilter('TransferSingle', [null, '0x0000000000000000000000000000000000000000', metamask.currentAddress]);
    final filterIncome = metamask.contractReadOnly.getFilter('Income', [metamask.currentAddress, null, null]);

    metamask.contractReadOnly.on(filterTransferSingle, (operator, from, to, id, value, event) {
      metamask.contractReadOnly.call<String>('uri', [id]).then((value) {
        String name = '';

        String tokenIdString = (int.parse(id.toString()).toRadixString(16)).toString();
        Client client = Client();
        Uri uri = Uri.parse(value.replaceFirst("{id}", tokenIdString.padLeft(64, '0').toUpperCase()));

        client.get(uri).then((response) {
          if (response.statusCode == 200) {
            name = jsonDecode(response.body)["name"];
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("$name 注册成功!"))
            );
          }
          else {
            throw Exception('Failed to load post');
          }
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("房地产注册成功! 房地产ID: $id"))
          );
        });
      });
    });

    metamask.contractReadOnly.on(filterIncome, (holder, id, value, event) {
      metamask.contractReadOnly.call<String>('uri', [id]).then((value) {
        String name = '';

        String tokenIdString = (int.parse(id.toString()).toRadixString(16)).toString();
        Client client = Client();
        Uri uri = Uri.parse(value.replaceFirst("{id}", tokenIdString.padLeft(64, '0').toUpperCase()));

        client.get(uri).then((response) {
          if (response.statusCode == 200) {
            name = jsonDecode(response.body)["name"];
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("$name 获得收益! 收益: $value"))
            );
          }
          else {
            throw Exception('Failed to load post');
          }
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("获得收益! 房地产ID: $id 收益: $value"))
          );
        });
      });
    });
  }

  clear() {
    currentAddress = "";
    currentChain = -1;
    notifyListeners();
  }

  init() {
    if (isEnabled) {
      ethereum!.onAccountsChanged((accounts) {
        clear();
      });
      ethereum!.onChainChanged((chainId) {
        clear();
      });
    }
  }
}

MetaMaskProvider metamask = MetaMaskProvider()..init();
