import 'package:flutter/material.dart';

class NoRoles extends StatelessWidget{
  const NoRoles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Không có quyền")),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Text("Không có quyền thao tác", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Center(
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'login');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.logout_outlined),
                    SizedBox(width: 10),
                    Text("Đăng xuất", style: TextStyle(fontSize: 22, letterSpacing: 2.2, color: Colors.black)),
                  ],
                )
            ),
          )
        ],
      ),
    );
  }

}