import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';


const urlAPI = url;
class ChangePass extends StatefulWidget {
  const ChangePass({Key? key}) : super(key: key);

  @override
  ChangePassState createState() => ChangePassState();
}

class ChangePassState extends State<ChangePass> {

  List<bool> showPassword = [true, true, true];
  final _txtCurPassword = TextEditingController();
  final _txtNewPassword = TextEditingController();
  final _txtRePassword = TextEditingController();

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

  getHashMD5(String input){
    var bytes = utf8.encode(input);
    var md5Hash = md5.convert(bytes).toString();
    return md5Hash;
  }

  String checkValid() {
    if(_txtCurPassword.text.isEmpty || _txtNewPassword.text.isEmpty || _txtRePassword.text.isEmpty) {
      return 'Thông tin không thể trống';
    }
    if(_txtNewPassword.text.length < 6){
      return 'Mật khẩu có ít nhất 6 kí tự';
    }
    if(_txtNewPassword.text != _txtRePassword.text){
      return 'Mật khẩu mới và nhập lại mật khẩu không giống nhau';
    }
    return "OK";
  }

  Future<String> handleCheckPass() async{
    final url = Uri.http(urlAPI, 'api/MobileApp/checkRepass');
    box1 = await Hive.openBox('logindata');
    final int IDAccount = box1.get("IDAccount");
    String hashString = getHashMD5(_txtCurPassword.text);
    var jsonBody = {
      'IDAccount': IDAccount,
      'Password': hashString
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

  handleChangePassConfirm() async{
    final url = Uri.http(urlAPI, 'api/MobileApp/changePassword');
    box1 = await Hive.openBox('logindata');
    final int IDAccount = box1.get("IDAccount");
    String hashString = getHashMD5(_txtNewPassword.text);
    var jsonBody = {
      'IDAccount': IDAccount,
      'Password': hashString
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
        title: const Text("Thay đổi mật khẩu"),
      ),
      body: buildInfo(context)
    );
  }

  Container buildInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          children: [
            const SizedBox(height: 35),
            buildTextField("Mật khẩu hiện tại", _txtCurPassword, 0),
            buildTextField("Mật khẩu mới", _txtNewPassword, 1),
            buildTextField("Nhập lại mật khẩu mới", _txtRePassword, 2),
            const SizedBox(height: 25),
            buildRowButton(context)
          ],
        ),
      ),
    );
  }

  Row buildRowButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Colors.lightGreen),
          onPressed: () async {
            String validString = checkValid();
            if (validString != "OK") {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                validString,
                style: const TextStyle(fontSize: 20),
              )));
            } else {
              String checkResponse = await handleCheckPass();
              if(checkResponse != "\"OK\"") {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(checkResponse, style: const TextStyle(fontSize: 20)))
                );
              }
              else{
                final response = await handleChangePassConfirm();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response, style: const TextStyle(fontSize: 20)))
                );
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false);
              }
            }
          },
          child: const Text("Đổi mật khẩu", style: TextStyle(fontSize: 15, letterSpacing: 2.2, color: Colors.black)),
        ),
      ],
    );
  }

  Widget buildTextField(
      String labelText, TextEditingController controller, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: controller,
        obscureText: showPassword[index],
        decoration: InputDecoration(
            suffixIcon:IconButton(
              onPressed: () {
                setState(() {
                  showPassword[index] = !showPassword[index];
                });
              },
              icon: Icon(showPassword[index] ? Icons.visibility : Icons.visibility_off, color: Colors.grey)
            ),
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always
        ),
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

}