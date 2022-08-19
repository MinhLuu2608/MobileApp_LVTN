import 'package:MobileApp_LVTN/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:MobileApp_LVTN/widgets/inputDecoration.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

final urlAPI = url;

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
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

    var txtUsername = TextEditingController();
    var txtPassword = TextEditingController();
    var txtRepass = TextEditingController();
    var txtSDT = TextEditingController();

    accountRegister(String username, String password, String SDT) async{

      final url = Uri.http(urlAPI, 'api/MobileApp/$username/$password/$SDT');
      print(url);
      final resp = await http.get(url, headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": "true",
        "Content-type": "application/json",
        "Accept": "application/json"
      });
      final response = resp.body;
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
                Text('Đăng ký', style: Theme.of(context).textTheme.headline4),
                const SizedBox(height: 15),
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
                      ),
                      TextFormField(
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                        ],
                        autocorrect: false,
                        controller: txtSDT,
                        decoration: InputDecorations.inputDecoration(
                            hintText: '0123456789',
                            labelText: 'Số điện thoại',
                            icon: const Icon(Icons.phone)),
                        validator: (value) {
                          return (value != null && value.length == 10)
                              ? null
                              : "SDT phải có 10 ký tự";
                        },
                      ),
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
                      TextFormField(
                        autocorrect: false,
                        controller: txtRepass,
                        obscureText: true,
                        validator: (value) {
                          return (value == txtPassword.text)
                              ? null
                              : "Không giống Password đã nhập ở trên";
                        },
                        decoration: InputDecorations.inputDecoration(
                            hintText: '*******',
                            labelText: 'Nhập lại mật khẩu',
                            icon: const Icon(Icons.lock_outline)),
                      ),
                      const SizedBox(height: 20),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        disabledColor: Colors.grey,
                        color: Colors.deepPurple,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 15),
                          child: const Text('Đăng ký',
                              style: TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                        onPressed: () async{
                          // var userAccount = userAccountProvider.userAccount;
                          if(!formKey.currentState!.validate()){
                            final snackBar = SnackBar(content: Text("Thông tin đăng ký không hợp lệ"));
                            _scaffoldKey.currentState!.showSnackBar(snackBar);
                          }
                          else{
                            final respone = await accountRegister(txtUsername.text, txtPassword.text, txtSDT.text);
                            final snackBar = SnackBar(content: Text(respone));
                            _scaffoldKey.currentState!.showSnackBar(snackBar);

                          }

                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Đã có tài khoản? "),
                          GestureDetector(
                            child: Text(
                                " Đăng nhập",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.lightBlue,
                                    decoration: TextDecoration.underline
                                )
                            ),
                            onTap: (){
                              Navigator.pushReplacementNamed(context, 'login');
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
