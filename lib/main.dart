
import 'package:flutter/material.dart';
import 'package:MobileApp_LVTN/providers/useraccount_provider.dart';
import 'package:MobileApp_LVTN/screens/home_screen.dart';
import 'package:MobileApp_LVTN/screens/login_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserAccount_provider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Material App",
        routes: {
          'login' : (_) => LoginScreen(),
          'home' : (_) => HomeScreen(),
        },
        initialRoute: 'login',
      ),
    );
  }
}