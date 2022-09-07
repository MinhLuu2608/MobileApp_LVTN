import 'package:MobileApp_LVTN/screens/employee_thutien/emp_info.dart';
import 'package:MobileApp_LVTN/screens/settings.dart';
import 'order_screen.dart';
import 'package:flutter/material.dart';

class EmpDichVuHomeScreen extends StatefulWidget{
  EmpDichVuHomeScreen({Key? key}) : super (key: key);

  @override
  _EmpHomeScreenState createState() => _EmpHomeScreenState();
}

class _EmpHomeScreenState extends State<EmpDichVuHomeScreen>{
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  List<Widget> title = [
    Text('Thông tin nhân viên', style: optionStyle),
    Text('Đơn hàng', style: optionStyle),
    Text('Cài đặt', style: optionStyle),
  ];

  List<Widget> screens = [
    EmpInfo(),
    OrderScreen(),
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
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Đơn hàng"),
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