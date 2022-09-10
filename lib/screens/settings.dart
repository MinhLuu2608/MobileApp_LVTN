import 'package:MobileApp_LVTN/screens/edit_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool valNotify1 = true;

  onChangeFunction1(bool newValue){
    setState(() {
      valNotify1 = newValue;
    });
  }

  bool valNotify2 = true;

  onChangeFunction2(bool newValue){
    setState(() {
      valNotify2 = newValue;
    });
  }

  goToInfoPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProfilePage()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Row(
              children: const [
                Icon(Icons.person, color: Colors.green),
                SizedBox(width: 8),
                Text("Tài khoản", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 15, thickness: 2),
            const SizedBox(height: 10),
            buildOptionWithEvent(context, "Thông tin cá nhân", goToInfoPage),
            buildAccountOptionRow(context, "Đổi mật khẩu"),
            buildAccountOptionRow(context, "Ngôn ngữ"),
            buildAccountOptionRow(context, "Bảo mật"),
            const SizedBox(height: 30),
            Row(
              children: const [
                Icon(Icons.volume_up_outlined, color: Colors.green),
                SizedBox(width: 8),
                Text("Thông báo",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 15,thickness: 2),
            const SizedBox(height: 10),
            buildNotificationOptionRow("Thông báo hoá đơn tháng", valNotify1, onChangeFunction1),
            buildNotificationOptionRow("Thông báo đơn hàng", valNotify2, onChangeFunction2),
            const SizedBox(height: 30),
            Row(
              children: const [
                Icon(Icons.book_outlined, color: Colors.green),
                SizedBox(width: 8),
                Text("Trợ giúp", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 15, thickness: 2),
            const SizedBox(height: 10),
            buildAccountOptionRow(context, "Trợ giúp từ bot"),
            buildAccountOptionRow(context, "Yêu cầu trợ giúp trực tiếp"),
            const SizedBox(height: 30),
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
      ),
    );
  }

  GestureDetector buildOptionWithEvent(BuildContext context, String title, Function handleChangePage) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => EditProfilePage()));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[600])),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Row buildNotificationOptionRow(String title, bool isActive, Function onChangeMethod) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[600])),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: isActive,
              onChanged: (bool val) {
                onChangeMethod(val);
              },
            )
        )
      ],
    );
  }

  GestureDetector buildAccountOptionRow(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("Chức năng đang cập nhật")
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Close")),
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}