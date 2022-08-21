import 'package:MobileApp_LVTN/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:MobileApp_LVTN/widgets/inputDecoration.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

final urlAPI = url;

class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginScreen createState() => LoginScreen();
}

class LoginScreen extends State<LoginPage> {

  var txtUsername = TextEditingController();
  var txtPassword = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  bool isChecked = false;
  late Box box1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createOpenBox();
  }
  void createOpenBox() async{
    box1 = await Hive.openBox('logindata');
    box1.put("IDAccount", "-1");
    getData();
  }

  void getData() async{
    if(box1.get('username')!=null){
      txtUsername.text = box1.get('username');
      isChecked = true;
      setState(() {

      });
    }
    if(box1.get('password')!=null){
      txtPassword.text = box1.get('password');
      isChecked = true;
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // color: Colors.green,
        child: Stack(
          children: [
            purpleContainer(size),
            iconContainer(),
            loginForm(context)
          ],
        ),
      ),
    );
  }

  SingleChildScrollView loginForm(BuildContext context) {
    // final userAccountProvider = Provider.of<UserAccount_provider>(context);

    checkLogin(String username, String password) async{
      final url = Uri.http(urlAPI, 'api/MobileApp/$username/$password');
      final resp = await http.get(url, headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": "true",
        "Content-type": "application/json",
        "Accept": "application/json"
      });
      final response = resp.body;

      if(response == "true") {
        return true;
      }
      else {
        return false;
      }
    }

    setIDAccount(String username, String password) async{
      final urlGetIDAccount = Uri.http(urlAPI, 'api/MobileApp/getIDAccount/$username/$password');
      final respGetIDAccount = await http.get(urlGetIDAccount, headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": "true",
        "Content-type": "application/json",
        "Accept": "application/json"
      });
      final idAccount = respGetIDAccount.body;
      box1.put('IDAccount', int.parse(idAccount));
    }

    setIDNhanVien() async{
      final idAccount = box1.get("IDAccount");
      final urlGetIDAccount = Uri.http(urlAPI, 'api/MobileApp/getEmpID/$idAccount');

      final respGetIDAccount = await http.get(urlGetIDAccount, headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": "true",
        "Content-type": "application/json",
        "Accept": "application/json"
      });
      final idNhanVien = respGetIDAccount.body;
      box1.put('IDNhanVien', int.parse(idNhanVien));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 200,
          ),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            //height: ,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 150,
                    offset: Offset(0, 5),
                  )
                ]),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text('Đăng nhập', style: Theme.of(context).textTheme.headline4),
                const SizedBox(height: 30),
                Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      TextFormField(
                        autocorrect: false,
                        controller: txtUsername,
                        decoration: InputDecorations.inputDecoration(
                            hintText: 'minhluu2608',
                            labelText: 'Username',
                            icon: const Icon(Icons.alternate_email_rounded)),
                        validator: (value) {
                          return (value != null)
                              ? null
                              : "Username không thể trống";
                        },
                        // validator: (value) {
                        //   String pattern =
                        //       r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                        //   RegExp regExp = new RegExp(pattern);
                        //   return regExp.hasMatch(value ?? '')
                        //       ? null
                        //       : 'Không phải định dạng email';
                        // },
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        autocorrect: false,
                        controller: txtPassword,
                        obscureText: true,
                        validator: (value) {
                          return (value != null && value.length >= 6)
                              ? null
                              : "Password có ít nhất 6 ký tự";
                        },
                        decoration: InputDecorations.inputDecoration(
                            hintText: '*******',
                            labelText: 'Password',
                            icon: const Icon(Icons.lock_outline)),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (value){
                              isChecked = !isChecked;
                              setState(() {

                              });
                            },
                          ),
                          Text("Nhớ mật khẩu",style: TextStyle(color: Colors.black, fontSize: 20),)
                        ],
                      ),
                      const SizedBox(height: 30),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        disabledColor: Colors.grey,
                        color: Colors.deepPurple,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 15),
                          child: const Text('Đăng nhập',
                              style: TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                        onPressed: () async{
                          // var userAccount = userAccountProvider.userAccount;
                          if(!formKey.currentState!.validate()){
                            final snackBar = SnackBar(content: Text("Username hoặc password không hợp lệ"));
                            _scaffoldKey.currentState!.showSnackBar(snackBar);
                          }
                          else{
                            if( await checkLogin(txtUsername.text, txtPassword.text) ){
                              rememberPassword(txtUsername.text, txtPassword.text);
                              setIDAccount(txtUsername.text, txtPassword.text);
                              setIDNhanVien();
                              final snackBar = SnackBar(content: Text("Đăng nhập thành công"));
                              _scaffoldKey.currentState!.showSnackBar(snackBar);
                              if(box1.get("IDNhanVien") == -1){
                                Navigator.pushReplacementNamed(context, 'customer/home');
                              }
                              else{
                                Navigator.pushReplacementNamed(context, 'employee/home');
                              }
                            }
                            else{
                              final snackBar = SnackBar(content: Text("Đăng nhập thất bại"));
                              _scaffoldKey.currentState!.showSnackBar(snackBar);
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Bạn chưa có tài khoản? "),
                          GestureDetector(
                            child: Text(
                                " Đăng ký ngay",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.lightBlue,
                                    decoration: TextDecoration.underline
                                )
                            ),
                            onTap: (){
                              Navigator.pushReplacementNamed(context, 'register');
                            },
                          )
                        ],
                      )],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  void rememberPassword(String username, String password){
    if(isChecked){
      box1.put('username', username);
      box1.put('password', password);
    }
    else{
      box1.delete('username');
      box1.delete('password');
    }
  }

  SafeArea iconContainer() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        width: double.infinity,
        child: const Icon(
          Icons.person_pin,
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }

  Container purpleContainer(Size size) {
      return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromRGBO(63, 63, 156, 1),
              Color.fromRGBO(90, 70, 178, 1),
            ])),
        width: double.infinity,
        height: size.height * 0.4,
        child: Stack(
          children: [
            Positioned(top: 90, left: 30, child: bubbleDecoration()),
            Positioned(top: -40, left: -30, child: bubbleDecoration()),
            Positioned(bottom: -50, left: 10, child: bubbleDecoration()),
            Positioned(top: -50, right: -20, child: bubbleDecoration()),
            Positioned(bottom: 120, right: 20, child: bubbleDecoration()),
          ],
        ),
      );
  }

  Container bubbleDecoration() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );
  }
}
