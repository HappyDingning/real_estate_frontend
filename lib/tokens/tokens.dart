import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'metamask.dart';

class TokenProvider extends ChangeNotifier{
  List? tokens;
  int? offset = 0;
  int limit = 10;

  void loadTokens(BuildContext context) async {
    Uri uri = Uri.parse("https://testnets-api.opensea.io/api/v1/assets?asset_contract_address=${metamask.contractReadOnly.address}&owner=${metamask.currentAddress}&order_direction=desc&offset=$offset&limit=$limit");
    // request uri
    get(uri).then((response) async {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        int size = data["assets"].length;

        if (tokens == null) {
          tokens = data["assets"];
        } else {
          tokens!.addAll(data["assets"]);
        }
        offset = tokens!.length;

        notifyListeners();

        await loadRealEstates(context, tokens!.length - size);
        
        notifyListeners();
      }
      else {
        throw Exception('Failed to load real estates');
      }
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('无法获取已持有的房地产代币')),
      );
    });
  }

  Future<void> loadRealEstates(BuildContext context, int start) async {
    if (tokens!.isEmpty) {
      return;
    }

    await metamask.contractReadOnly.call<String>('uri', [tokens![0]["token_id"]]).then((value) async {
      await requestRealEstateDetails(value, start);
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('无法获取房地产信息')),
      );
    });
  }

  Future<void> requestRealEstateDetails(String value, int start) async {
    for (int i = start; i < tokens!.length; i++) {
      String tokenIdString = int.parse(tokens![i]["token_id"]).toRadixString(16).toUpperCase();
      Uri uri = Uri.parse(value.replaceFirst("{id}", tokenIdString.padLeft(64, '0')));

      await get(uri).then((response) {
        if (response.statusCode == 200) {
          tokens![i]["name"] = jsonDecode(response.body)["name"];
          tokens![i]["description"] = jsonDecode(response.body)["description"];
          tokens![i]["image_original_url"] = jsonDecode(response.body)["image"];
        }
      });
    }
  }

  void clear() {
    tokens = null;
    offset = 0;
  }

  void init() {
    clear();
  }
}

TokenProvider token = TokenProvider()..init();
