import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/models/donhang.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';


const urlAPI = url;

class OrderAccept extends StatefulWidget{
  final int idDonHang;
  OrderAccept({required this.idDonHang});

  @override
  OrderAcceptState createState() => OrderAcceptState();
}

class OrderAcceptState extends State<OrderAccept>{
  OrderAcceptState();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late Box box1;
  var updateState = false;
  var chosenDate;
  final _txtNgayHen = TextEditingController();
  String? valueBuoiHen;

  List<String> buoiHen = ["Sáng", "Chiều"];

  static const TextStyle headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const TextStyle contentStyle = TextStyle(fontSize: 20,);
  static const TextStyle chuaThuStyle = TextStyle(fontSize: 20, color: Colors.pink);
  static const TextStyle tableHeaderStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  static const TextStyle tableRowStyle = TextStyle(fontSize: 14);

  Future refresh() async{
    setState(() {
      updateState = !updateState;
    });
  }

  String checkValid() {
    if(_txtNgayHen.text.isEmpty || valueBuoiHen == null) {
      return 'Ngày hẹn và buổi hẹn không thể trống';
    }
    return "OK";
  }

  handleAcceptConfirm() async{
    box1 = await Hive.openBox('logindata');
    final int IDNhanVien = box1.get("IDNhanVien");
    final url = Uri.http(urlAPI, 'api/MobileApp/acceptOrder/');
    String dateString = DateFormat('yyyy-MM-dd').format(chosenDate);
    var jsonBody = {
      'IDDonHang': widget.idDonHang,
      'IDNhanVien': IDNhanVien,
      'NgayHen': dateString,
      'BuoiHen': valueBuoiHen
    };
    String jsonStr = json.encode(jsonBody);
    final resp = await http.post(url, body: jsonStr, headers: {
      // "Access-Control-Allow-Origin": "*",
      // "Access-Control-Allow-Credentials": "true",
      "Content-type": "application/json",
      // "Accept": "application/json"
    });
    final response = resp.body;
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Padding(padding: EdgeInsets.only(left: 50), child: Text('Nhận đơn hàng')),
        ),
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              buildDatePickerNgayHen(),
              buildDropDownBuoiHen(),
              Expanded(child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildButton(context),
                ],
              )),
            ],
          ),
        )
    );
  }

  Padding buildDropDownBuoiHen() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Container(
          margin: const EdgeInsets.all(16),
          width: 320,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(20)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
                value: valueBuoiHen,
                hint: const Text("Chọn buổi hẹn", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                iconSize: 36,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                isExpanded: true,
                items: buoiHen.map(buildMenuItem).toList(),
                onChanged: (value) {
                  setState(() {
                    valueBuoiHen = value;
                  });
                }),
          ),
        ));
  }

  DropdownMenuItem<String> buildMenuItem(String item) {
    return DropdownMenuItem(
      value: item,
      child: Text(item, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
    );
  }

  Row buildDatePickerNgayHen() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          width: 350,
          child: TextField(
              controller: _txtNgayHen,
              readOnly: true,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    showDatePicker(
                        context: context,
                        initialDate: chosenDate ?? DateTime.now(),
                        firstDate: DateTime(DateTime.now().year),
                        lastDate: DateTime(DateTime.now().year+2)
                    ).then((date) {
                      if (date != null) {
                        setState(() {
                          chosenDate = date;
                          String dateString = DateFormat('dd/MM/yyyy').format(date);
                          // String dateString = '${date.day}/${date.month}/${date.year}';
                          _txtNgayHen.text = dateString;
                        });
                      }
                    });
                  },
                  icon: const Icon(Icons.calendar_month),
                ),
                hintText: 'Ngày hẹn: dd/mm/yyyy',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.red)),
              ),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              onChanged: (value) {
                setState(() {
                  updateState = !updateState;
                });
              }),
        ),
      ],
    );
  }

  Row buildButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.purpleAccent),
            onPressed: () async{
              String validString = checkValid();
              if(validString != "OK") {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(validString, style: const TextStyle(fontSize: 20),))
                );
              }
              else{
                final response = await handleAcceptConfirm();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response, style: const TextStyle(fontSize: 20),))
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text("Xác nhận", style: TextStyle( fontSize: 16, letterSpacing: 2.2, color: Colors.black)),
          ),
        ),
      ],
    );
  }

}