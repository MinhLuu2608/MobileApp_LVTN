import 'package:flutter/material.dart';

class NavigateScreen extends StatelessWidget{
  const NavigateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Chọn trang")),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  backgroundColor: Colors.lightGreen),
              onPressed: () async {
                Navigator.pushReplacementNamed(context, 'employee_thutien/home');
              },
              child: const Text("Đi tới trang của nhân viên thu tiền", style: TextStyle( fontSize: 15, letterSpacing: 2.2, color: Colors.black)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  backgroundColor: Colors.amberAccent),
              onPressed: () async{
                Navigator.pushReplacementNamed(context, 'employee_dichvu/home');
              },
              child: const Text("Đi tới trang của nhân viên dịch vụ", style: TextStyle( fontSize: 15, letterSpacing: 2.2, color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }

}