import 'package:MobileApp_LVTN/screens/customer/services_screen.dart';
import 'package:MobileApp_LVTN/screens/settings.dart';

import 'invoices_screen.dart';
import 'package:MobileApp_LVTN/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget{
  HomeScreen({Key? key}) : super (key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  List<Widget> title = [
    Text('Trang chủ', style: optionStyle),
    Text('Hoá đơn', style: optionStyle),
    Text('Dịch vụ', style: optionStyle),
    Text('Cài đặt', style: optionStyle),
  ];

  List<Widget> screens = [
    Text('Home', style: optionStyle),
    InvoicesScreen(),
    ServicesScreen(),
    SettingsPage(),
  ];

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: title[_selectedIndex]),
      ),
      body: (
          screens[_selectedIndex]
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Hoá đơn"),
          BottomNavigationBarItem(icon: Icon(Icons.cleaning_services_sharp), label: "Dịch vụ"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Cài đặt"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.black,
        iconSize: 30,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
      ),
    );
  }
}