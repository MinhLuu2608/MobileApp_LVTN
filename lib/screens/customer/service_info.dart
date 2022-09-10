import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/models/account.dart';
import 'package:MobileApp_LVTN/models/dichvu.dart';
import 'package:MobileApp_LVTN/screens/customer/service_request.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final urlAPI = url;
class ServiceInfo extends StatefulWidget {
  final DichVu dichVuInfo;
  ServiceInfo({required this.dichVuInfo});

  @override
  ServiceInfoState createState() => ServiceInfoState();
}

class ServiceInfoState extends State<ServiceInfo> {

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
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Tên dịch vụ:", style: optionMainStyle),
                const  SizedBox(width: 10),
                Flexible(child: Text(widget.dichVuInfo.tenDichVu, style: styleContent))
              ],
            ),
          ), // Tên dịch vụ
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: Row(
              children: [
                const Text("Loại dịch vụ:", style: optionMainStyle),
                const  SizedBox(width: 10),
                Text(widget.dichVuInfo.loaiDichVu, style: styleContent)
              ],
            ),
          ), // Loại dịch vụ
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: Row(
              children: [
                const Text("Đơn giá: ", style: optionMainStyle),
                const  SizedBox(width: 10),
                Text("${widget.dichVuInfo.donGiaDv}/${widget.dichVuInfo.donViTinh}", style: styleContent)
              ],
            ),
          ), // Loại dịch vụ
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child:  Text("Mô tả dịch vụ:", style: optionMainStyle)
          ), // Mô tả dịch vụ header
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              child:  Text(widget.dichVuInfo.moTaDichVu, style: styleContent)
          ), // Mô tả dịch vụ nội dung
          Expanded(child: buildButtonRequest())
        ],
      )
    );
  }

  Column buildButtonRequest() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ServiceRequest(dichVu: widget.dichVuInfo)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(Icons.shopping_cart),
                SizedBox(width: 10),
                Text("Yêu cầu dịch vụ", style: TextStyle(fontSize: 22, letterSpacing: 2.2, color: Colors.blue)),
              ],
            ),
          ),
        ),
      ],
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