import 'package:flutter/material.dart';
import 'package:MobileApp_LVTN/models/useraccount.dart';
import 'package:MobileApp_LVTN/providers/useraccount_provider.dart';
import 'package:MobileApp_LVTN/widgets/inputDecoration.dart';
import 'package:MobileApp_LVTN/widgets/inputTextFormField.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
    final userAccountProvider = Provider.of<UserAccount_provider>(context);
    var _txtEmail = TextEditingController();
    var _txtPassword = TextEditingController();
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 250,
          ),
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(horizontal: 30),
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
                Text('Login', style: Theme.of(context).textTheme.headline4),
                const SizedBox(height: 30),
                Container(
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        TextFormField(
                          autocorrect: false,
                          controller: _txtEmail,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecorations.inputDecoration(
                              hintText: 'minhluu2608@gmail.com',
                              labelText: 'Username or Email',
                              icon: Icon(Icons.alternate_email_rounded)),
                          validator: (value) {
                            String pattern =
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                            RegExp regExp = new RegExp(pattern);
                            return regExp.hasMatch(value ?? '')
                                ? null
                                : 'Không phải định dạng email';
                          },
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          autocorrect: false,
                          controller: _txtPassword,
                          obscureText: true,
                          validator: (value) {
                            return (value != null && value.length >= 6)
                                ? null
                                : "Password có ít nhất 6 ký tự";
                          },
                          decoration: InputDecorations.inputDecoration(
                              hintText: '*******',
                              labelText: 'Password',
                              icon: Icon(Icons.lock_outline)),
                        ),
                        const SizedBox(height: 30),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          disabledColor: Colors.grey,
                          color: Colors.deepPurple,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 80, vertical: 15),
                            child: Text('Đăng nhập',
                                style: TextStyle(color: Colors.white)),
                          ),
                          onPressed: () {
                            var userAccount = userAccountProvider.userAccount;
                            if(userAccount.where((e) => e.email == _txtEmail.text).length > 0
                              && userAccount.where((e) => e.pwd == _txtPassword.text).length > 0){
                                  print("Đăng nhập thành công");
                                  Navigator.pushReplacementNamed(context, 'home');
                            }
                            else{
                              print("Đăng nhập thất bại");
                            }
                          },
                        )
                      ],
                    ),
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
          Positioned(child: bubbleDecoration(), top: 90, left: 30),
          Positioned(child: bubbleDecoration(), top: -40, left: -30),
          Positioned(child: bubbleDecoration(), bottom: -50, left: 10),
          Positioned(child: bubbleDecoration(), top: -50, right: -20),
          Positioned(child: bubbleDecoration(), bottom: 120, right: 20),
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
