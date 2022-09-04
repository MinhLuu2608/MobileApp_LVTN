import 'dart:convert';
import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/screens/employee_thutien/invoice_filter_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

final urlAPI = url;
class InvoiceScreen extends StatefulWidget{
  // InvoicesScreen({Key? key}) : super (key: key);

  @override
  InvoiceScreenState createState() => InvoiceScreenState();
}

class InvoiceScreenState extends State<InvoiceScreen>{

  late int radioValue;
  var updateState = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

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
        tooltip: "Lọc",
        child: Icon(Icons.filter_alt_rounded),
        onPressed: () async{
          int _value = radioValue;
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
                          title: Text("Kỳ thu", style: TextStyle(fontSize: 20)),
                          value: 0,
                          groupValue: _value,
                          onChanged: (value) {
                            setState(() {
                              _value = int.parse(value.toString());
                              // print(radioValue);
                            });
                          },
                        ), // Kỳ thu
                        RadioListTile(
                          title: Text("Tuyến thu", style: TextStyle(fontSize: 20)),
                          value: 1,
                          groupValue: _value,
                          onChanged: (value) {
                            setState(() {
                              _value = int.parse(value.toString());
                              // print(radioValue);
                            });
                          },
                        ), // Tuyến thu
                        RadioListTile(
                          title: Text("Khách hàng", style: TextStyle(fontSize: 20)),
                          value: 2,
                          groupValue: _value,
                          onChanged: (value) {
                            setState(() {
                              _value = int.parse(value.toString());
                              // print(radioValue);
                            });
                          },
                        ), // Khách hàng
                        RadioListTile(
                          title: Text("Chưa thu", style: TextStyle(fontSize: 20)),
                          value: 3,
                          groupValue: _value,
                          onChanged: (value) {
                            setState(() {
                              _value = int.parse(value.toString());
                              // print(radioValue);
                            });
                          },
                        ), // Tình trạng
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            radioValue = _value;
                            this.setState(() {
                              updateState = !updateState;
                            });
                          },
                          child: Text("Lọc", style: TextStyle(fontSize: 20))),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Huỷ bỏ", style: TextStyle(fontSize: 20)))
                    ],
                  );
                });
              }
          );
        },
      ),
      body: InvoiceFilterList(filterType: radioValue),
    );
  }

}