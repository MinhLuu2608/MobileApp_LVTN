import 'dart:convert';
import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/screens/employee/invoices_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

final urlAPI = url;
class InvoicesScreen extends StatefulWidget{
  // InvoicesScreen({Key? key}) : super (key: key);

  @override
  InvoicesScreenState createState() => InvoicesScreenState();
}

class InvoicesScreenState extends State<InvoicesScreen>{

  late int radioValue;
  var updateState = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  var txtMaKhachHang = TextEditingController();

  late Box box1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.radioValue = 0;
    createOpenBox();
  }
  void createOpenBox() async{
    box1 = await Hive.openBox('logindata');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        tooltip: "Thêm liên kết tài khoản",
        child: Icon(Icons.filter_alt_rounded),
        onPressed: () async{
          // await openFilterDialog(context);
          await showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                    title: Center(child: Text("Lọc hoá đơn theo")),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile(
                          title: Text("Tình trạng"),
                          subtitle: Text("Đã thu / Chưa thu"),
                          value: 0,
                          groupValue: radioValue,
                          onChanged: (value) {
                            setState(() {
                              radioValue = int.parse(value.toString());
                              // print(radioValue);
                            });
                          },
                        ), // Tình trạng thu
                        RadioListTile(
                          title: Text("Khách hàng"),
                          value: 1,
                          groupValue: radioValue,
                          onChanged: (value) {
                            setState(() {
                              radioValue = int.parse(value.toString());
                              // print(radioValue);
                            });
                          },
                        ), //Khách hàng
                        RadioListTile(
                          title: Text("Tuyến thu"),
                          value: 2,
                          groupValue: radioValue,
                          onChanged: (value) {
                            setState(() {
                              radioValue = int.parse(value.toString());
                              // print(radioValue);
                            });
                          },
                        ), // Tuyến thu
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            this.setState(() {
                              updateState = !updateState;
                            });
                          },
                          child: Text("Lọc")),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Huỷ bỏ"))
                    ],
                  );
                });
              }
          );
        },
      ),
      body: Column(
        children: [
          Text(radioValue.toString()),
          InvoicesList(filterType: radioValue),
        ],
      ),
    );
  }

  // openFilterDialog(BuildContext context) {
  //   showDialog(
  //           context: context,
  //           builder: (context) {
  //             return StatefulBuilder(builder: (context, setState) {
  //               return AlertDialog(
  //                 title: Center(child: Text("Lọc hoá đơn theo")),
  //                 content: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     RadioListTile(
  //                       title: Text("Tình trạng"),
  //                       subtitle: Text("Đã thu / Chưa thu"),
  //                       value: 0,
  //                       groupValue: radioValue,
  //                       onChanged: (value) {
  //                         setState(() {
  //                           radioValue = int.parse(value.toString());
  //                           print(radioValue);
  //                         });
  //                       },
  //                     ), // Tình trạng thu
  //                     RadioListTile(
  //                       title: Text("Khách hàng"),
  //                       value: 1,
  //                       groupValue: _radioValue,
  //                       onChanged: (value) {
  //                         setState(() {
  //                           _radioValue = int.parse(value.toString());
  //                           print(_radioValue);
  //                         });
  //                       },
  //                     ), //Khách hàng
  //                     RadioListTile(
  //                       title: Text("Tuyến thu"),
  //                       value: 2,
  //                       groupValue: _radioValue,
  //                       onChanged: (value) {
  //                         setState(() {
  //                           _radioValue = int.parse(value.toString());
  //                           print(_radioValue);
  //                         });
  //                       },
  //                     ), // Tuyến thu
  //                   ],
  //                 ),
  //                 actions: [
  //                   TextButton(
  //                       onPressed: () {
  //                         this.setState(() {
  //                           updateState = !updateState;
  //                         });
  //                         Navigator.of(context).pop();
  //                       },
  //                       child: Text("Lọc")),
  //                   TextButton(
  //                       onPressed: () {
  //                         Navigator.of(context).pop();
  //                       },
  //                       child: Text("Huỷ bỏ"))
  //                 ],
  //               );
  //             });
  //           }
  //       );
  // }


}