import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/models/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final urlAPI = url;
class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  bool editStatus = false;
  bool showPassword = false;
  final _txtHoTen = TextEditingController();
  final _txtSDT = TextEditingController();
  final _txtDiaChi = TextEditingController();

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

  handleConfirm() async{
    final url = Uri.http(urlAPI, 'api/MobileApp/editinfo/');
    box1 = await Hive.openBox('logindata');
    final int IDAccount = box1.get("IDAccount");
    var jsonBody = {
      'IDAccount': IDAccount,
      'HoTen': _txtHoTen.text,
      'DiaChi': _txtDiaChi.text,
      'SDT': _txtSDT.text
    };
    String jsonStr = json.encode(jsonBody);
    final resp = await http.put(url, body: jsonStr, headers: {
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
      padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Theme.of(context).scaffoldBackgroundColor),
                        boxShadow: [
                          BoxShadow(spreadRadius: 2, blurRadius: 10, color: Colors.black.withOpacity(0.1), offset: Offset(0, 10))
                        ],
                        shape: BoxShape.circle
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 4, color: Theme.of(context).scaffoldBackgroundColor),
                          color: Colors.green,
                        ),
                        child: const Icon(Icons.edit, color: Colors.white),
                      )
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),
            buildTextField("Họ và tên", accountInfo.hoTen, _txtHoTen, false, editStatus),
            buildTextFieldSDT("Số điện thoại", accountInfo.sdt, _txtSDT, false, editStatus),
            buildTextField("Địa chỉ", accountInfo.diaChi, _txtDiaChi, false, editStatus),
            const SizedBox(height: 25),
            buildRowEdit(context,accountInfo,editStatus)
          ],
        ),
      ),
    );
  }

  Row buildRowEdit(BuildContext context, Account accountInfo, bool editStatus) {
    if(editStatus) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.lightGreen),
            onPressed: () async{
              String validString = checkValid();
              if(validString != "OK") {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(validString, style: const TextStyle(fontSize: 20),))
                );
              }
              else{
                await handleConfirm();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Chỉnh sửa thành công", style: const TextStyle(fontSize: 20),))
                );
                setState(() {
                  this.editStatus = !this.editStatus;
                });
              }
            },
            child: const Text("Lưu thay đổi",style: TextStyle(fontSize: 15, letterSpacing: 2.2, color: Colors.black)),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                backgroundColor: const Color(0xB9AEAEFF)),
            onPressed: () {
              setState(() {
                this.editStatus = !this.editStatus;
              });
            },
            child: const Text("Huỷ bỏ", style: TextStyle(fontSize: 15, letterSpacing: 2.2, color: Colors.black)),
          ),
        ],
      );
    }
    else{
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
            child: const Text("Chỉnh sửa",style: TextStyle(fontSize: 15, letterSpacing: 2.2, color: Colors.black)),
          )
        ],
      );
    }
  }

  Widget buildTextField(
      String labelText, String textValue, TextEditingController controller, bool isPasswordTextField, bool enableStatus) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
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
      padding: const EdgeInsets.only(bottom: 35.0),
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