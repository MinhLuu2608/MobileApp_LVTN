import 'package:MobileApp_LVTN/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:MobileApp_LVTN/screens/home_screen.dart';
import 'package:MobileApp_LVTN/screens/login_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

void main() async{
  await Hive.initFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Material App",
      routes: {
        'login' : (_) => LoginPage(),
        'register' : (_) => RegisterScreen(),
        'home' : (_) => HomeScreen(),
      },
      initialRoute: 'login',
    );
  }
}