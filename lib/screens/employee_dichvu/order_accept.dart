import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/models/donhang.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';


const urlAPI = url;

class OrderAccept extends StatefulWidget{
  final int idDonHang;
  OrderAccept({required this.idDonHang});

  @override
  OrderAcceptState createState() => OrderAcceptState();
}

class OrderAcceptState extends State<OrderAccept>{
  OrderAcceptState();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late Box box1;
  var updateState = false;
  var chosenDate;
  final _txtNgayHen = TextEditingController();
  final _txtBuoiHen = TextEditingController();

  static const TextStyle headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const TextStyle contentStyle = TextStyle(fontSize: 20,);
  static const TextStyle chuaThuStyle = TextStyle(fontSize: 20, color: Colors.pink);
  static const TextStyle tableHeaderStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  static const TextStyle tableRowStyle = TextStyle(fontSize: 14);

  Future refresh() async{
    setState(() {
      updateState = !updateState;
    });
  }

  handleAcceptConfirm() async{
    box1 = await Hive.openBox('logindata');
    final int IDNhanVien = box1.get("IDNhanVien");
    final url = Uri.http(urlAPI, 'api/MobileApp/cancelByNV/');
    // var jsonBody = {
    //   'IDDonHang': widget.idDonHang,
    //   'IDNhanVien': IDNhanVien,
    //   'Note': _txtNote.text
    // };
    // String jsonStr = json.encode(jsonBody);
    // final resp = await http.delete(url, body: jsonStr, headers: {
    //   // "Access-Control-Allow-Origin": "*",
    //   // "Access-Control-Allow-Credentials": "true",
    //   "Content-type": "application/json",
    //   // "Accept": "application/json"
    // });
    // final response = resp.body;
    // return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Padding(padding: EdgeInsets.only(left: 50), child: Text('Nhận đơn hàng')),
        ),
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              buildDatePicker(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: TextField(
                  controller: _txtBuoiHen,
                  style: const TextStyle(fontSize: 20),
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 3),
                      labelText: "Buổi hẹn: ",
                      floatingLabelBehavior: FloatingLabelBehavior.always
                  ),
                ),
              ),
              Expanded(child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildButton(context),
                ],
              )),
            ],
          ),
        )
    );
  }

  Row buildDatePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          width: 350,
          child: TextField(
              controller: _txtNgayHen,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    showDatePicker(
                        context: context,
                        initialDate: chosenDate ?? DateTime.now(),
                        firstDate: DateTime(DateTime.now().year),
                        lastDate: DateTime(DateTime.now().year+2)
                    ).then((date) {
                      if (date != null) {
                        setState(() {
                          chosenDate = date;
                          String dateString = DateFormat('dd/MM/yyyy').format(date);
                          // String dateString = '${date.day}/${date.month}/${date.year}';
                          _txtNgayHen.text = dateString;
                        });
                      }
                    });
                  },
                  icon: const Icon(Icons.calendar_month),
                ),
                hintText: 'Ngày hẹn: dd/mm/yyyy',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.red)),
              ),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              onChanged: (value) {
                setState(() {
                  updateState = !updateState;
                });
              }),
        ),
      ],
    );
  }

  Row buildButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.purpleAccent),
            onPressed: () async{
              String response = await handleAcceptConfirm();
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(response, style: const TextStyle(fontSize: 20),))
              );
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text("Xác nhận", style: TextStyle( fontSize: 16, letterSpacing: 2.2, color: Colors.black)),
          ),
        ),
      ],
    );
  }

  Padding buildTableRow(BuildContext context, AsyncSnapshot<dynamic> snapshot, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 5.0, bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.29,
            child: Center(child: Text(snapshot.data[index]['TenDichVu'], style: tableRowStyle)),
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.20,
            child: Center(child: Text(snapshot.data[index]['SoLuong'].toString(), style: tableRowStyle),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.20,
            child: Center(child: Text(snapshot.data[index]['DonGia'].toString(), style: tableRowStyle)),
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.20,
            child: Center(child: Text(snapshot.data[index]['TongTienDV'].toString(), style: tableRowStyle)),
          ),
        ],
      ),
    );
  }

  Padding buildTableHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 5.0, bottom: 15.0, top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.29,
            child: const Center(child: Text("Tên dịch vụ", style: tableHeaderStyle)),
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.20,
            child: const Center(child: Text("Số lượng", style: tableHeaderStyle)),
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.20,
            child: const Center(child: Text("Đơn giá", style: tableHeaderStyle)),
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.20,
            child: const Center(child: Text("Tổng", style: tableHeaderStyle)),
          ),
        ],
      ),
    );
  }

  buildTextTinhTrangXuLy(DonHang donHang) {
    if(donHang.tinhTrangXuLy == "Chờ xử lý") {
      return Row(
        children: [
          Text("Tình trạng xử lý: ", style: headerStyle),
          Text(donHang.tinhTrangXuLy, style: const TextStyle(fontSize: 20, color: Colors.pinkAccent)),
        ],
      );
    }
    if(donHang.tinhTrangXuLy == "Đã tiếp nhận"){
      return Row(
        children: [
          Text("Tình trạng xử lý: ", style: headerStyle),
          Text(donHang.tinhTrangXuLy, style: const TextStyle(fontSize: 20, color: Colors.blue)),
        ],
      );
    }
    if(donHang.tinhTrangXuLy == "Đã hoàn thành"){
      return Row(
        children: [
          Text("Tình trạng xử lý: ", style: headerStyle),
          Text(donHang.tinhTrangXuLy, style: const TextStyle(fontSize: 20, color: Colors.green)),
        ],
      );
    }
    if(donHang.tinhTrangXuLy == "Đã bị huỷ"){
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("Tình trạng xử lý: ", style: headerStyle),
              Text("${donHang.tinhTrangXuLy} ", style: const TextStyle(fontSize: 20, color: Colors.grey)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text("Lý do: ${donHang.note}", style: const TextStyle(fontSize: 20)),
          )
        ],
      );
    }
    return Text(donHang.tinhTrangXuLy);
  }

  AlertDialog buildAlertDialogWarning() {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(Icons.warning_amber, color: Colors.amber),
              Flexible(child: Text( "Hoá đơn trước chưa thanh toán", style: TextStyle(fontSize: 18)))
            ],
          ),
        ],
      ),
    );
  }

  AlertDialog buildAlertDialogSuccess(response) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.green),
              Flexible(child: Text(response, style: TextStyle(fontSize: 18)))
            ],
          ),
        ],
      ),
    );
  }

}