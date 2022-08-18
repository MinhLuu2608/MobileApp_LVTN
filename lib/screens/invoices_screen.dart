import 'dart:convert';

import 'package:MobileApp_LVTN/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

final urlAPI = url;
class InvoicesScreen extends StatefulWidget{
  InvoicesScreen({Key? key}) : super (key: key);

  @override
  _InvoicesScreenState createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen>{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  var txtMaKhachHang = TextEditingController();

  late Box box1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createOpenBox();
  }
  void createOpenBox() async{
    box1 = await Hive.openBox('logindata');
  }

  handleLinkAccountWithKH(String IDAcc, String MaKH) async {
    final url = Uri.http(urlAPI, 'api/MobileApp/link');
    final IDAccount = box1.get("IDAccount");

    var jsonBody = {
      'IDAccount': IDAccount.toString(),
      'MaKH': MaKH
    };
    String jsonStr = json.encode(jsonBody);
    print(jsonStr);
    print("URL là: $url ");
    final resp = await http.post(url, body: jsonStr, headers: {
      // "Access-Control-Allow-Origin": "*",
      // "Access-Control-Allow-Credentials": "true",
      "Content-type": "application/json",
      // "Accept": "application/json"
    });
    final responseFromAPI = resp.body;
    print("Response: $responseFromAPI");
    return responseFromAPI;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: "Thêm liên kết tài khoản",
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Thêm liên kết tài khoản"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            TextFormField(
                              autocorrect: false,
                              controller: txtMaKhachHang,
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.deepPurple),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                                ),
                                labelText: "Mã khách hàng",
                              ),
                              validator: (value) {
                                return (value != null)
                                    ? null
                                    : "Mã khách hàng không thể trống";
                              },
                            ),
                          ]
                        ),
                      )
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          final response = await handleLinkAccountWithKH(box1.get("IDAccount"),txtMaKhachHang.text);
                          print("Response của hàm Handle: $response");
                          final snackBar = SnackBar(content: Text(response));
                          _scaffoldKey.currentState!.showSnackBar(snackBar);
                          Navigator.of(context).pop();
                        },
                        child: Text("Liên kết mã khách hàng")
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Close")
                    )
                  ],
                );
              });
        },
      ),
    );
  }


}