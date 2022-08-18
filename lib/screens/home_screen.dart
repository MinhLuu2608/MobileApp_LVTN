import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget{
  HomeScreen({Key? key}) : super (key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const screens = [
    Text('Home', style: optionStyle),
    Text('Receipt', style: optionStyle),
    Text('Settings', style: optionStyle),
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
        title: Center(child: screens[_selectedIndex]),
      ),
      body: Center(
        child: screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Receipt"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting"),
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