import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/models/account.dart';
import 'package:MobileApp_LVTN/models/dichvu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final urlAPI = url;
class ServiceInfo extends StatefulWidget {
  final DichVu dichVuInfo;
  ServiceInfo({required this.dichVuInfo});

  @override
  ServiceInfoState createState() => ServiceInfoState(dichVuInfo: dichVuInfo);
}

class ServiceInfoState extends State<ServiceInfo> {
  final DichVu dichVuInfo;
  ServiceInfoState({required this.dichVuInfo});

  static const TextStyle optionMainStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const TextStyle styleContent = TextStyle(fontSize: 20);

  bool editStatus = false;
  bool showPassword = false;

  late Box box1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createOpenBox();
  }

  void createOpenBox() async {
    box1 = await Hive.openBox('logindata');
  }

  Future<List<Account>> getAccount() async {
    box1 = await Hive.openBox('logindata');
    final int IDAccount = box1.get("IDAccount");
    final url = Uri.http(urlAPI, 'api/MobileApp/getInfoAccount/$IDAccount');

    final resp = await http.get(url, headers: {
      // "Access-Control-Allow-Origin": "*",
      // "Access-Control-Allow-Credentials": "true",
      "Content-type": "application/json",
      // "Accept": "application/json"
    });
    final response = accountFromJson(resp.body);
    return response;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết dịch vụ"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildImage(),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                const Text("Tên dịch vụ", style: optionMainStyle),
                const  SizedBox(width: 10),
                Text(dichVuInfo.tenDichVu, style: styleContent)
              ],
            ),
          ) // Tên dịch vụ
        ],
      )
    );
  }

  Padding buildImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Image.network(
        'https://www.adenservices.com/content/media/2021/02/workplace_cleaning_housekeeping-1920x1137.jpg',
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      ),
    );
  }

}