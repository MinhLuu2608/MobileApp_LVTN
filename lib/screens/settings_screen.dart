import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 22, fontWeight: FontWeight.bold);

  bool valNotify1 = true;

  onChangeFunction1(bool newValue1){
    setState(() {
      valNotify1 = newValue1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: [
          Row(
            children: const [
              Icon(Icons.person, color: Colors.blue),
              SizedBox(width: 20),
              Text("Tài khoản", style: optionStyle)
            ],
          ),
          const Divider(height: 20,thickness: 2,),
          const SizedBox(height: 10,),
          buildAccountOption(context, "Cập nhật thông tin"),
          buildAccountOption(context, "Phản hồi ý kiến"),
          buildAccountOption(context, "Thay đổi mật khẩu"),
          SizedBox(height: 40,),
          Row(
            children: const [
              Icon(Icons.notifications,color: Colors.blue),
              SizedBox(width: 10),
              Text("Thông báo",style: optionStyle,)
            ],
          ),
          const Divider(height: 20,thickness: 2),
          const SizedBox(height: 10),
          buildNotificationOption("Nhận thông báo hoá đơn mới", valNotify1, onChangeFunction1),
          SizedBox(height: 50),
          Center(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                )
              ),
              onPressed: (){

                Navigator.pushReplacementNamed(context, 'login');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.logout_outlined),
                  SizedBox(width: 10),
                  Text("Đăng xuất", style: TextStyle(
                    fontSize: 22, letterSpacing: 2.2, color: Colors.black
                  )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Padding buildNotificationOption(
      String title, bool value, Function onChangeMethod) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600]),
          ),
          Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              activeColor: Colors.blue,
              trackColor: Colors.grey[600],
              value: value,
              onChanged: (bool newValue) {
                onChangeMethod(newValue);
              },
            ),
          )
        ],
      ),
    );
  }

  GestureDetector buildAccountOption(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text("Option 1"), Text("Option 2")],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Close"))
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600]),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
