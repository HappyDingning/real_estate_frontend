import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';

import 'tokens/metamask.dart';


class RegisterRealEstate extends StatefulWidget {
  const RegisterRealEstate({Key? key}) : super(key: key);

  @override
  _RegisterRealEstateState createState() => _RegisterRealEstateState();
}

class _RegisterRealEstateState extends State<RegisterRealEstate> {
  final registerFormKey = GlobalKey<FormState>();

  Uint8List? image;
  late String name = "";
  late String description = "";
  late BigInt rent = BigInt.zero;

  Future<void> _pickImage() async {
    var image_ = await ImagePickerWeb.getImageAsBytes();
    if (image_ != null) {
      setState(() {
        image = image_;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('注册资产'),
        leading: IconButton(
          tooltip: "返回",
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: registerFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            image == null ? 
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('选择图片'),
                  ),
                ),
              ) :
              Image(
                image: MemoryImage(image!),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("标题(必填项)"),
                    ),
                    maxLength: 32,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return '请输入标题';
                      }

                      if (value.length < 4) {
                        return '标题过短';
                      }

                      return null;
                    },
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("租金(Wei/天 必填项)")
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return '请输入租金';
                      }

                      if (BigInt.parse(value) > BigInt.parse('1000000000000000000')) {
                        return '超出范围';
                      }

                      return null;
                    },
                    onChanged: (value) {
                      rent = BigInt.parse(value);
                    },
                  ),
                  TextFormField(
                    maxLines: 13,
                    minLines: 1,
                    decoration: const InputDecoration(
                      label: Text("描述(选填项)")
                    ),
                    onChanged: (value) {
                      description = value;
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(top: 16)),
                  ElevatedButton(
                    onPressed: () async {
                      if (image == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('请选择图片')),
                        );
                      }

                      if (registerFormKey.currentState!.validate()) {
                        var multipartFile = MultipartFile.fromBytes("image", image!, filename: "image.png", contentType: MediaType("image", "png"));

                        var url = 'http://127.0.0.1:8000/api/publishRealEstate/';
                        var uri = Uri.parse(url);
                        var request = MultipartRequest('POST', uri)
                        ..fields['name'] = name
                        ..fields['description'] = description
                        ..fields['creator'] = metamask.currentAddress
                        ..files.add(multipartFile);

                        metamask.contractReadWrite.send('publishRealEstate', [rent]).then((value) {  // if the transaction is successful
                          request.send();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('交易已提交，等待区块链确认')),
                          );
                        }).catchError((error) {  // if the transaction cancelled
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('交易失败')),
                          );
                        });
                      }
                    },
                    child: const Text('注册'),
                  )
                ],
              )
            )
          ],
        )
      ),
    );
  }
}
