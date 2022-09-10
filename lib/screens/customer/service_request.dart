import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/models/account.dart';
import 'package:MobileApp_LVTN/models/dichvu.dart';
import 'package:MobileApp_LVTN/screens/edit_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const urlAPI = url;
class ServiceRequest extends StatefulWidget {
  final DichVu dichVu;
  ServiceRequest({ required this.dichVu});

  @override
  ServiceRequestState createState() => ServiceRequestState();
}

class ServiceRequestState extends State<ServiceRequest> {

  static const TextStyle headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const TextStyle tableHeaderStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  static const TextStyle tableRowStyle = TextStyle(fontSize: 14);

  bool editStatus = false;
  bool showPassword = false;
  final _txtHoTen = TextEditingController();
  final _txtSDT = TextEditingController();
  final _txtDiaChi = TextEditingController();
  final _txtSoLuong = TextEditingController(text: '1');
  var _tongTien = 0;
  var updateState = false;

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
    _txtHoTen.text = response[0].hoTen;
    _txtDiaChi.text = response[0].diaChi;
    _txtSDT.text = response[0].sdt;
    _tongTien = int.parse(_txtSoLuong.text) * widget.dichVu.donGiaDv;
    return response;
  }

  String checkValid() {
    if(_txtHoTen.text.isEmpty || _txtDiaChi.text.isEmpty) {
      return 'Họ tên hoặc địa chỉ không thể trống';
    }
    if(_txtSDT.text.length != 10){
      return 'Số điện thoại phải có 10 chữ số';
    }
    return "OK";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin cá nhân"),
      ),
      body: FutureBuilder(
        future: getAccount(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Text("Something Wrong");
          }
          if (snapshot.hasData) {
            return buildInfo(context, snapshot.data[0], editStatus);
          }
          return const Text("Error while Calling API");
        },
      ),
    );
  }

  Container buildInfo(BuildContext context, Account accountInfo, bool editStatus) {
    return Container(
      padding: const EdgeInsets.only(top: 25),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          children: [
            const Center(
              child: Text("Yêu cầu dịch vụ", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))
            ),
            const SizedBox(height: 35),
            const Padding(
              padding: const EdgeInsets.only(bottom: 35),
              child: Center(child: Text("Thông tin khách hàng:", style: headerStyle))
            ),
            buildTextField("Họ và tên", accountInfo.hoTen, _txtHoTen, false, editStatus),
            buildTextFieldSDT("Số điện thoại", accountInfo.sdt, _txtSDT, false, editStatus),
            buildTextField("Địa chỉ", accountInfo.diaChi, _txtDiaChi, false, editStatus),
            const SizedBox(height: 25),
            const Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Center(child: Text("Thông tin dịch vụ:", style: headerStyle))
            ),
            buildTableHeader(context),
            buildTableRow(context),
            buildButtonConfirm(context,accountInfo,editStatus)
          ],
        ),
      ),
    );
  }

  Padding buildTableRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 5.0, bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.32,
            child: Center(child: Text(widget.dichVu.tenDichVu, style: tableRowStyle)),
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.20,
            child: TextField(
              controller: _txtSoLuong,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              ],
              onChanged: (value) {
                _tongTien = int.parse(value) * widget.dichVu.donGiaDv;
              },
            )
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.22,
            child: Center(child: Text(widget.dichVu.donGiaDv.toString(), style: tableRowStyle)),
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.22,
            child: Center(child: Text(_tongTien.toString(), style: tableRowStyle)),
          ),
        ],
      ),
    );
  }

  Padding buildTableHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 5.0, top: 15.0, bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.32,
            child: const Center(child: Text("Tên dịch vụ", style: tableHeaderStyle)),
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.20,
            child: const Center(child: Text("Số lượng", style: tableHeaderStyle)),
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.22,
            child: const Center(child: Text("Đơn giá", style: tableHeaderStyle)),
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.22,
            child: const Center(child: Text("Tổng tiền", style: tableHeaderStyle)),
          ),
        ],
      ),
    );
  }

  Row buildButtonConfirm(BuildContext context, Account accountInfo, bool editStatus) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Colors.lightGreen),
          onPressed: () {
            setState(() {
              this.editStatus = !this.editStatus;
            });
          },
          child: const Text("Xác nhận", style: TextStyle( fontSize: 15, letterSpacing: 2.2, color: Colors.black)),
        )
      ],
    );
  }

  Widget buildTextField(
      String labelText, String textValue, TextEditingController controller, bool isPasswordTextField, bool enableStatus) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0, left: 15, right: 15),
      child: TextField(
        enabled: enableStatus,
        controller: controller,
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                icon: Icon(Icons.remove_red_eye, color: Colors.grey)
            )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always
        ),
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget buildTextFieldSDT(
      String labelText, String textValue, TextEditingController controller, bool isPasswordTextField, bool enableStatus) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0, left: 15, right: 15),
      child: TextField(
        enabled: enableStatus,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
        ],
        controller: controller,
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                icon: Icon(Icons.remove_red_eye, color: Colors.grey)
            )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always
        ),
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}