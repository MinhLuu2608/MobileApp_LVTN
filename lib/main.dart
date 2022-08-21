import 'package:MobileApp_LVTN/screens/employee/home_screen.dart';
import 'package:MobileApp_LVTN/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:MobileApp_LVTN/screens/customer/home_screen.dart';
import 'package:MobileApp_LVTN/screens/login_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
    "pk_test_51LYlhhBpklmPdZX2H96DE6Eb5LiY6579BgmBXclgTycNcB62eeUT1qZ1qvDjjKAWLSTDRWXXkjDTxRIrMfUVbK9B00tX6O8uwC";
  await Stripe.instance.applySettings();
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
        'customer/home' : (_) => HomeScreen(),
        'employee/home' : (_) => EmpHomeScreen(),
      },
      initialRoute: 'login',
    );
  }
}