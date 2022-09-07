import 'package:MobileApp_LVTN/screens/customer/service_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServicesScreen extends StatefulWidget {
  @override
  ServicesScreenState createState() => ServicesScreenState();
}

class ServicesScreenState extends State<ServicesScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(
            children: [
              const TabBar(
                unselectedLabelColor: Colors.black12,
                unselectedLabelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                labelColor: Colors.green,
                labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: "Dịch vụ"),
                  Tab(text: "Đơn hàng")
                ],
              ),
              Expanded(child: TabBarView(
                children: [
                  ServiceListScreen(),
                  Text('Person')
                ],
              ))
            ],
          ),
        )
    );
  }
}