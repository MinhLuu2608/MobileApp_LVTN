import 'package:flutter/material.dart';

class HomeDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height * .38,
            decoration: BoxDecoration(
              color: Color(0xBB8ECE9A),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Chào mừng bạn đến với EnviApp",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                buildSearchBar(),
                const SizedBox(height: 10),
                Row(
                  children: [
                    buildFunctionShortcut(context,Icons.receipt_rounded, "Thanh toán hóa đơn"),
                    const SizedBox(width: 10),
                    buildFunctionShortcut(context,Icons.cleaning_services_rounded, "Yêu cầu dịch vụ"),
                    const SizedBox(width: 10),
                    buildFunctionShortcut(context,Icons.add_link_rounded, "Liên kết mã khách hàng"),
                    const SizedBox(width: 10),
                    buildFunctionShortcut(context,Icons.receipt_long_rounded, "Đăng ký \n hợp đồng")
                  ],
                )

              ],
            )
          )
        ],
      ),
    );
  }

  InkWell buildFunctionShortcut(BuildContext context, IconData iconData, String txt) {
    return InkWell(
      onTap: (){
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Thông báo"),
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
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xCDD5C8C0),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(20),
                child: Center(child: Icon(iconData, size: 30)),
              ),
              const SizedBox(height: 5),
              Container(
                width: 80,
                child: Center(
                    child: Text(
                  txt,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )),
              )
            ],
          ),
        ],
      ),
    );
  }

  Container buildSearchBar() {
    return Container(
                padding: const EdgeInsets.all(15),
                width: 350,
                child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.search),
                      ),
                      hintText: 'Tìm kiếm',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.red)),
                    ),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    onChanged: (value) {}
                ),
              );
  }
}