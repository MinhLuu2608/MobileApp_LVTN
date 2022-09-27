import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/models/donhang.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const urlAPI = url;
class OrderInfo extends StatefulWidget{
  final DonHang donHang;
  OrderInfo({required this.donHang});
  @override
  OrderInfoState createState() => OrderInfoState();
}

class OrderInfoState extends State<OrderInfo>{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var updateState = false;

  static const TextStyle headerStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static const TextStyle contentStyle = TextStyle(fontSize: 18,);
  static const TextStyle tableHeaderStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  static const TextStyle tableRowStyle = TextStyle(fontSize: 15);

  Map<String, dynamic>? paymentIntent;

  getOrderServiceInfo() async {
    final url = Uri.http(urlAPI, 'api/MobileApp/getOrdersServiceInfo/${widget.donHang.idDonHang}');
    final resp = await http.get(url, headers: {
      // "Access-Control-Allow-Origin": "*",
      // "Access-Control-Allow-Credentials": "true",
      "Content-type": "application/json",
      // "Accept": "application/json"
    });
    final response = json.decode(resp.body);
    return response;
  }

  cancelOrders() async {
    final url = Uri.http(urlAPI, 'api/MobileApp/delete/${widget.donHang.idDonHang}');
    final resp = await http.delete(url, headers: {
      // "Access-Control-Allow-Origin": "*",
      // "Access-Control-Allow-Credentials": "true",
      "Content-type": "application/json",
      // "Accept": "application/json"
    });
    final response = json.decode(resp.body);
    print(response);
    return response;
  }

  Future refresh() async{
    setState(() {
      updateState = !updateState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Padding(padding: EdgeInsets.only(left: 50), child: Text('Chi tiết hoá đơn')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                      child: Text(
                          "Đơn hàng ${widget.donHang.maDonHang}",
                          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
                      )
                  ),
                ), // Title đơn hàng
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Tên khách hàng:",style: headerStyle,),
                      const SizedBox(width: 5),
                      Text(widget.donHang.tenKhachHang, style: contentStyle),
                    ],
                  ),
                ), // Ten KH
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Số điện thoại KH:", style: headerStyle),
                      const SizedBox(width: 5),
                      Text(widget.donHang.soDienThoaiKh, style: contentStyle),
                    ],
                  ),
                ), // SDT KH
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Địa chỉ:", style: headerStyle),
                      const SizedBox(width: 5),
                      Flexible(child: Text(widget.donHang.diaChiKh, style: contentStyle)),
                    ],
                  ),
                ), // Địa chỉ
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Ngày tạo:", style: headerStyle),
                      const SizedBox(width: 5),
                      Text(widget.donHang.ngayTao, style: contentStyle),
                    ],
                  ),
                ), // Ngày tạo
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Tình trạng:", style: headerStyle),
                      const SizedBox(width: 5),
                      Flexible(child: Text(widget.donHang.tinhTrangXuLy, style: contentStyle)),
                    ],
                  ),
                ), // Tình trạng xử lý
                widget.donHang.tinhTrangXuLy == 'Đã bị huỷ' ? buildNote() :
                widget.donHang.tinhTrangXuLy != 'Chờ xử lý' ? buildEmpInfo() :
                widget.donHang.ngayHen != "Đơn hàng chưa xử lý" ? buildNgayHen() :
                widget.donHang.tinhTrangXuLy == 'Đã hoàn thành' ? buildNgayThu() :
                buildTableHeader(context),
                FutureBuilder(
                  future: getOrderServiceInfo(),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    if(snapshot.connectionState != ConnectionState.done){
                      return const Center(child: CircularProgressIndicator());
                    }
                    if(snapshot.hasError){
                      return const Text("Something Wrong");
                    }
                    if(snapshot.hasData){
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 5.0, top: 5.0, bottom: 5.0),
                            child: buildTableRow(context, snapshot, index),
                          );
                        },
                      );
                    }
                    return const Text("Error while Calling API");
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 60),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xC4e64c86),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          title: const Text("Huỷ đơn hàng"),
                          content: const Text("Bạn có chắc chắn huỷ đơn hàng?"),
                          actions: [
                            TextButton(
                              onPressed: () async{
                                String response = await cancelOrders();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.white30,
                                    content: Text(response,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        )
                                    )
                                  )
                                );
                                if(response == 'Đơn hàng được huỷ thành công'){
                                  Navigator.of(context).popUntil((route) => route.isFirst);
                                }
                              },
                              child: const Text("OK"),

                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("CANCEL"),
                            )
                          ],
                        )
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(Icons.cancel_outlined),
                        SizedBox(width: 10),
                        Text("Huỷ đơn hàng", style: TextStyle(fontSize: 22, letterSpacing: 2.2)),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Row buildTableRow(BuildContext context, AsyncSnapshot<dynamic> snapshot, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(right: 5.0),
          width: MediaQuery.of(context).size.width * 0.29,
          child: Text(snapshot.data[index]['TenDichVu'], style: tableRowStyle),
        ),
        Container(
          padding: const EdgeInsets.only(right: 5.0),
          width: MediaQuery.of(context).size.width * 0.22,
          child: Text(snapshot.data[index]['SoLuong'].toString(),
              style: tableRowStyle),
        ),
        Container(
          padding: const EdgeInsets.only(right: 5.0),
          width: MediaQuery.of(context).size.width * 0.22,
          child: Text(snapshot.data[index]['DonGia'].toString(),
              style: tableRowStyle),
        ),
        Container(
          padding: const EdgeInsets.only(right: 5.0),
          width: MediaQuery.of(context).size.width * 0.22,
          child: Text(snapshot.data[index]['TongTienDV'].toString(),
              style: tableRowStyle),
        ),
      ],
    );
  }

  Padding buildTableHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 5.0, top: 15.0, bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.29,
            child: const Text("Tên dịch vụ", style: tableHeaderStyle),
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.22,
            child: const Text("Số lượng", style: tableHeaderStyle),
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.22,
            child: const Text("Đơn giá", style: tableHeaderStyle),
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.22,
            child: const Text("Tổng tiền", style: tableHeaderStyle),
          ),
        ],
      ),
    );
  }

  Padding buildNote() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Lý do:", style: headerStyle),
          const SizedBox(width: 5),
          Flexible(child: Text(widget.donHang.note, style: contentStyle)),
        ],
      ),
    );
  }

  Padding buildNgayThu() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Ngày thu:", style: headerStyle),
          const SizedBox(width: 5),
          Flexible(child: Text(widget.donHang.ngayThu, style: contentStyle)),
        ],
      ),
    );
  }

  Padding buildNgayHen() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Ngày hẹn:", style: headerStyle),
          const SizedBox(width: 5),
          Flexible(
              child: Text("${widget.donHang.ngayHen} ${widget.donHang.buoiHen}",
                  style: contentStyle)),
        ],
      ),
    );
  }

  Column buildEmpInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Mã nhân viên:", style: headerStyle),
              const SizedBox(width: 5),
              Text(widget.donHang.maNhanVien, style: contentStyle),
            ],
          ),
        ), // Mã nhân viên
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Họ tên nhân viên:", style: headerStyle),
              const SizedBox(width: 5),
              Text(widget.donHang.hoTen, style: contentStyle),
            ],
          ),
        ), // Họ tên
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Số điện thoại nhân viên:", style: headerStyle),
              const SizedBox(width: 5),
              Text(widget.donHang.soDienThoai, style: contentStyle),
            ],
          ),
        ), // SDT nhân viên
      ],
    );
  }


}