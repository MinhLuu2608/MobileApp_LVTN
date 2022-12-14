import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/screens/No_roles.dart';
import 'package:MobileApp_LVTN/screens/navigate_screen.dart';
import 'package:flutter/material.dart';
import 'package:MobileApp_LVTN/widgets/inputDecoration.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

final urlAPI = url;

class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  var txtUsername = TextEditingController();
  var txtPassword = TextEditingController();

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
    box1.put("IDAccount", -1);
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

  getHashMD5(String input){
    var bytes = utf8.encode(input);
    var md5Hash = md5.convert(bytes).toString();
    return md5Hash;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final size = MediaQuery.of(context).size;
    return Scaffold(
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

    checkLogin(String username, String password) async{
      String hashString = getHashMD5(password);
      final url = Uri.http(urlAPI, 'api/MobileApp/$username/$hashString');
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
      String hashString = getHashMD5(password);
      final urlGetIDAccount = Uri.http(urlAPI, 'api/MobileApp/getIDAccount/$username/$hashString');
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

    getEmpRole() async{
      final idNV = box1.get("IDNhanVien");
      final urlGetIDAccount = Uri.http(urlAPI, 'api/MobileApp/getEmpRole/$idNV');

      final resp = await http.get(urlGetIDAccount, headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": "true",
        "Content-type": "application/json",
        "Accept": "application/json"
      });
      final response = json.decode(resp.body);
      return response;
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
                Text('????ng nh???p', style: Theme.of(context).textTheme.headline4),
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
                              : "Username kh??ng th??? tr???ng";
                        },
                        // validator: (value) {
                        //   String pattern =
                        //       r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                        //   RegExp regExp = new RegExp(pattern);
                        //   return regExp.hasMatch(value ?? '')
                        //       ? null
                        //       : 'Kh??ng ph???i ?????nh d???ng email';
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
                              : "Password c?? ??t nh???t 6 k?? t???";
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
                          const Text("Nh??? m???t kh???u",style: TextStyle(color: Colors.black, fontSize: 20),)
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
                          child: const Text('????ng nh???p', style: TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                        onPressed: () async{
                          // var userAccount = userAccountProvider.userAccount;
                          if(!formKey.currentState!.validate()){
                            const snackBar = SnackBar(content:
                              Text("Username ho???c password kh??ng h???p l???", style: TextStyle(fontSize: 20))
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                          else{
                            if( await checkLogin(txtUsername.text, txtPassword.text) ){
                              rememberPassword(txtUsername.text, txtPassword.text);
                              await setIDAccount(txtUsername.text, txtPassword.text);
                              await setIDNhanVien();
                              const snackBar = SnackBar(content: Text("????ng nh???p th??nh c??ng", style: TextStyle(fontSize: 20)));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              if(box1.get("IDNhanVien") == -1){
                                Navigator.pushReplacementNamed(context, 'customer/home');
                              }
                              else{
                                String empRole = await getEmpRole();
                                if(empRole == "Thu ti???n"){
                                  Navigator.pushReplacementNamed(context, 'employee_thutien/home');
                                }
                                else if(empRole == "D???ch v???"){
                                  Navigator.pushReplacementNamed(context, 'employee_dichvu/home');
                                }
                                else if(empRole == "Thu ti???n & D???ch v???"){
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (context) => NavigateScreen()));
                                }
                                else {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (context) => NoRoles()));
                                }
                              }
                            }
                            else{
                              const snackBar = SnackBar(content: Text("????ng nh???p th???t b???i", style: TextStyle(fontSize: 20)));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("B???n ch??a c?? t??i kho???n? "),
                          GestureDetector(
                            child: const Text(
                                " ????ng k?? ngay",
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
