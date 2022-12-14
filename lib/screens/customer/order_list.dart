import 'dart:convert';
import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/models/donhang.dart';
import 'package:MobileApp_LVTN/screens/customer/service_info.dart';
import 'package:MobileApp_LVTN/screens/customer/order_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

const urlAPI = url;
class OrderListScreen extends StatefulWidget {
  const OrderListScreen({Key? key}) : super(key: key);

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
    if(_txtSearch.text.isEmpty){
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
    else{
      String maHD = _txtSearch.text.toUpperCase();
      final url = Uri.http(urlAPI, 'api/MobileApp/getSearchOrder/$maHD');
      final resp = await http.get(url, headers: {
        // "Access-Control-Allow-Origin": "*",
        // "Access-Control-Allow-Credentials": "true",
        "Content-type": "application/json",
        // "Accept": "application/json"
      });
      final response = donHangFromJson(resp.body);
      return response;
    }
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
                            onTap: () async{
                              final refresh = await Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => OrderInfo(donHang: snapshot.data[index])));
                              // if(refresh == true){
                              //   setState(() {
                              //     updateState = !updateState;
                              //   });
                              // }
                              if(refresh == null){
                                setState(() {
                                  updateState = !updateState;
                                });
                              }
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
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(snapshot.data[index].maDonHang, style: styleContent),
                ), // M?? ????n h??ng
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text("T??n KH: ${snapshot.data[index].tenKhachHang}", style: styleContent),
                ), // T??n kh??ch h??ng
                buildNgayTao(snapshot, index), // Ng??y t???o
                if(snapshot.data[index].tinhTrangXuLy == "???? ti???p nh???n") buildNgayHen(snapshot, index),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: buildTextTinhTrangXuLy(snapshot, index),
                ), // T??nh tr???ng x??? l??
              ],
            ),
          ),
          Expanded(
            flex: 1,
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

  Padding buildNgayTao(AsyncSnapshot<dynamic> snapshot, int index) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text("Ng??y t???o: ${snapshot.data[index].ngayTao}",
          style: styleContent),
    );
  }
  Padding buildNgayHen(AsyncSnapshot<dynamic> snapshot, int index) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text("Ng??y h???n: ${snapshot.data[index].ngayHen} ${snapshot.data[index].buoiHen}",
          style: styleContent),
    );
  }

  buildTextTinhTrangXuLy(AsyncSnapshot<dynamic> snapshot, int index) {
    if(snapshot.data[index].tinhTrangXuLy == "Ch??? x??? l??") {
      return Row(
        children: [
          const Text("T??nh tr???ng x??? l??: ", style: TextStyle(fontSize: 20,)),
          Text(snapshot.data[index].tinhTrangXuLy, style: const TextStyle(fontSize: 20, color: Colors.pinkAccent)),
        ],
      );
    }
    if(snapshot.data[index].tinhTrangXuLy == "???? ti???p nh???n"){
      return Row(
        children: [
          const Text("T??nh tr???ng x??? l??: ", style: TextStyle(fontSize: 20,)),
          Text(snapshot.data[index].tinhTrangXuLy, style: const TextStyle(fontSize: 20, color: Colors.blue)),
        ],
      );
    }
    if(snapshot.data[index].tinhTrangXuLy == "???? ho??n th??nh"){
      return Row(
        children: [
          const Text("T??nh tr???ng x??? l??: ", style: TextStyle(fontSize: 20,)),
          Text(snapshot.data[index].tinhTrangXuLy, style: const TextStyle(fontSize: 20, color: Colors.green)),
        ],
      );
    }
    if(snapshot.data[index].tinhTrangXuLy == "???? b??? hu???"){
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("T??nh tr???ng x??? l??: ", style: TextStyle(fontSize: 20,)),
              Text("${snapshot.data[index].tinhTrangXuLy} ", style: const TextStyle(fontSize: 20, color: Colors.grey)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text("L?? do: ${snapshot.data[index].note}", style: const TextStyle(fontSize: 20)),
          )
        ],
      );
    }
    return Text(snapshot.data[index].tinhTrangXuLy);
  }

  FloatingActionButton buildFilter(BuildContext context) {
    return FloatingActionButton(
      tooltip: "L???c",
      child: const Icon(Icons.filter_alt_rounded),
      onPressed: () {
        int _value = radioValue;
        showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  title: const Center(child: Text("L???c lo???i d???ch v??? theo:")),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // K??? thu
                      RadioListTile(
                        title: const Text("Ch??? ti???p nh???n", style: TextStyle(fontSize: 20)),
                        value: 0,
                        groupValue: _value,
                        onChanged: (value) {
                          setState(() {
                            _value = int.parse(value.toString());
                            // print(radioValue);
                          });
                        },
                      ), // Trong nh??
                      RadioListTile(
                        title: const Text("???? ti???p nh???n", style: TextStyle(fontSize: 20)),
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
                        title: const Text("???? ho??n th??nh", style: TextStyle(fontSize: 20)),
                        value: 2,
                        groupValue: _value,
                        onChanged: (value) {
                          setState(() {
                            _value = int.parse(value.toString());
                            // print(radioValue);
                          });
                        },
                      ), // Ngo??i tr???i
                      RadioListTile(
                        title: const Text("???? b??? hu???", style: TextStyle(fontSize: 20)),
                        value: 3,
                        groupValue: _value,
                        onChanged: (value) {
                          setState(() {
                            _value = int.parse(value.toString());
                            // print(radioValue);
                          });
                        },
                      ), // T???t c???
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
                            const Text("L???c", style: TextStyle(fontSize: 20))),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Hu??? b???", style: TextStyle(fontSize: 20)))
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
          width: 350,
          child: TextField(
              controller: _txtSearch,
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      updateState = !updateState;
                    });
                  },
                  icon: const Icon(Icons.search),
                ),
                hintText: 'Nh???p m?? ????n h??ng c???n t??m',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.red)),
              ),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              onChanged: (value) {
                setState(() {
                  updateState = !updateState;
                });
              }
          ),
        ),
      ],
    );
  }
}