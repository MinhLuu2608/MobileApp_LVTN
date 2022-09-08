import 'dart:convert';
import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/models/donhang.dart';
import 'package:MobileApp_LVTN/screens/customer/service_info.dart';
import 'package:MobileApp_LVTN/screens/customer/order_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

final urlAPI = url;
class OrderListScreen extends StatefulWidget {
  @override
  OrderListScreenState createState() => OrderListScreenState();
}

class OrderListScreenState extends State<OrderListScreen> {

  static const TextStyle optionMainStyle = TextStyle(fontSize: 16);
  static const TextStyle optionSubStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  static const TextStyle styleContent = TextStyle(fontSize: 20);

  int radioValue = 0;
  var updateState = false;
  final _txtSearch = TextEditingController();

  late Box box1;
  Future<List<DonHang>> getDonHang() async {
    box1 = await Hive.openBox('logindata');
    final int IDAccount = box1.get("IDAccount");
    final url = Uri.http(urlAPI, 'api/MobileApp/getCustomerOrders/$IDAccount/$radioValue');

    final resp = await http.get(url, headers: {
      // "Access-Control-Allow-Origin": "*",
      // "Access-Control-Allow-Credentials": "true",
      "Content-type": "application/json",
      // "Accept": "application/json"
    });
    final response = donHangFromJson(resp.body);
    return response;
  }

  showImage(String image){
    return Image.memory(base64Decode(image));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFilter(context),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildSearchField(),
              FutureBuilder(
                future: getDonHang(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Text("Something Wrong");
                  }
                  if (snapshot.hasData) {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(10),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(3),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => OrderInfo(donHang: snapshot.data[index])));
                            },
                            child: buildDonHang(snapshot, index),
                          ),
                        );
                      },
                    );
                  }
                  return const Text("Error while Calling API");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card buildDonHang(AsyncSnapshot<dynamic> snapshot, int index) {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      color: Colors.white70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(snapshot.data[index].maDonHang, style: styleContent),
                ), // Mã đơn hàng
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(snapshot.data[index].tenKhachHang, style: styleContent),
                ), // Tên khách hàng
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(snapshot.data[index].ngayTao, style: styleContent),
                ), // Ngày tạo
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  FloatingActionButton buildFilter(BuildContext context) {
    return FloatingActionButton(
      tooltip: "Lọc",
      child: const Icon(Icons.filter_alt_rounded),
      onPressed: () {
        int _value = radioValue;
        showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  title: const Center(child: Text("Lọc loại dịch vụ theo:")),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Kỳ thu
                      RadioListTile(
                        title: const Text("Chờ tiếp nhận", style: TextStyle(fontSize: 20)),
                        value: 0,
                        groupValue: _value,
                        onChanged: (value) {
                          setState(() {
                            _value = int.parse(value.toString());
                            // print(radioValue);
                          });
                        },
                      ), // Trong nhà
                      RadioListTile(
                        title: const Text("Đã tiếp nhận", style: TextStyle(fontSize: 20)),
                        value: 1,
                        groupValue: _value,
                        onChanged: (value) {
                          setState(() {
                            _value = int.parse(value.toString());
                            // print(radioValue);
                          });
                        },
                      ),
                      RadioListTile(
                        title: const Text("Đã hoàn thành", style: TextStyle(fontSize: 20)),
                        value: 2,
                        groupValue: _value,
                        onChanged: (value) {
                          setState(() {
                            _value = int.parse(value.toString());
                            // print(radioValue);
                          });
                        },
                      ), // Ngoài trời
                      RadioListTile(
                        title: const Text("Đã bị huỷ", style: TextStyle(fontSize: 20)),
                        value: 3,
                        groupValue: _value,
                        onChanged: (value) {
                          setState(() {
                            _value = int.parse(value.toString());
                            // print(radioValue);
                          });
                        },
                      ), // Tất cả
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          radioValue = _value;
                          this.setState(() {
                            updateState = !updateState;
                          });
                        },
                        child:
                            const Text("Lọc", style: TextStyle(fontSize: 20))),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Huỷ bỏ", style: TextStyle(fontSize: 20)))
                  ],
                );
              });
            });
      },
    );
  }

  Row buildSearchField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          width: 400,
          child: TextField(
              controller: _txtSearch,
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  onPressed: () {
                    print("Searching...");
                  },
                  icon: const Icon(Icons.search),
                ),
                hintText: 'Tên dịch vụ',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.red)),
              ),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              onChanged: (value) {
                print("Change");
              }
          ),
        ),
      ],
    );
  }
}