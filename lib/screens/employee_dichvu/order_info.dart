import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/models/donhang.dart';
import 'package:MobileApp_LVTN/screens/employee_dichvu/order_accept.dart';
import 'package:MobileApp_LVTN/screens/employee_dichvu/order_cancel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


final urlAPI = url;

class OrderInfo extends StatefulWidget{
  final int idDonHang;
  OrderInfo({required this.idDonHang});

  @override
  OrderInfoState createState() => OrderInfoState();
}

class OrderInfoState extends State<OrderInfo>{
  OrderInfoState();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late Box box1;

  var dichVuList;
  var updateState = false;

  static const TextStyle headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const TextStyle contentStyle = TextStyle(fontSize: 20,);
  static const TextStyle chuaThuStyle = TextStyle(fontSize: 20, color: Colors.pink);
  static const TextStyle tableHeaderStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  static const TextStyle tableRowStyle = TextStyle(fontSize: 14);

  getHoaDon() async {
    final url = Uri.http(urlAPI, 'api/MobileApp/getOrderInfo/${widget.idDonHang}');
    final resp = await http.get(url, headers: {
      // "Access-Control-Allow-Origin": "*",
      // "Access-Control-Allow-Credentials": "true",
      "Content-type": "application/json",
      // "Accept": "application/json"
    });
    final response = donHangFromJson(resp.body);
    return response;
  }

  getServiceList() async {
    final url = Uri.http(urlAPI, 'api/MobileApp/getOrdersServiceInfo/${widget.idDonHang}');
    final resp = await http.get(url, headers: {
      // "Access-Control-Allow-Origin": "*",
      // "Access-Control-Allow-Credentials": "true",
      "Content-type": "application/json",
      // "Accept": "application/json"
    });
    final response = json.decode(resp.body);
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          FutureBuilder(
            future: getHoaDon(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Text("Something Wrong");
              }
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buildOrderInfo(snapshot),
                    const Padding(
                        padding: EdgeInsets.all(5),
                        child: Text("Danh sách dịch vụ", style: headerStyle)
                    ),
                    Padding(
                        padding: const EdgeInsets.all(5),
                        child: FutureBuilder(
                          future: getServiceList(),
                          builder: (BuildContext context, AsyncSnapshot snapshot2) {
                            if (snapshot2.connectionState != ConnectionState.done) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (snapshot2.hasError) {
                              return const Text("Something Wrong");
                            }
                            if (snapshot2.hasData) {
                              return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot2.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return buildTableRow(context, snapshot2, index);
                                },
                              );
                            }
                            return const Text("Error while Calling API");
                          },
                        )
                    ), //Dịch vụ list
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (snapshot.data[0].tinhTrangXuLy == 'Chờ xử lý') buildButtonChoXuLy(context),
                        if (snapshot.data[0].tinhTrangXuLy == 'Đã tiếp nhận') buildButtonChoXuLy(context),
                      ],
                    )
                  ],
                );
              }
              return const Text("Error while Calling API");
            },
          ),
        ],
      )
    );
  }

  Column buildOrderInfo(AsyncSnapshot<dynamic> snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Center(
            child: Text("Đơn hàng ${snapshot.data[0].maDonHang}", style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
        ), // Title đơn hàng
        Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Tên khách hàng",
                style: headerStyle,
              ),
              const SizedBox(width: 5),
              Text(snapshot.data[0].tenKhachHang, style: contentStyle),
            ],
          ),
        ), // Tên khách hàng
        Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Địa chỉ:", style: headerStyle),
              const SizedBox(width: 5),
              Flexible(
                  child: Text(snapshot.data[0].diaChiKh, style: contentStyle)),
            ],
          ),
        ), // Địa chỉ khách hàng
        Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Số điện thoại:", style: headerStyle),
              const SizedBox(width: 5),
              Text(snapshot.data[0].soDienThoaiKh, style: contentStyle),
            ],
          ),
        ), // Số điện thoại KH
        Padding(
            padding: const EdgeInsets.all(5.0),
            child:
                (buildTextTinhTrangXuLy(snapshot.data[0]))), // Tình trạng xử lý
        Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Ngày thu:", style: headerStyle),
              const SizedBox(width: 5),
              snapshot.data[0].ngayThu == "Chưa thu"
                  ? Text(snapshot.data[0].ngayThu, style: chuaThuStyle)
                  : Text(snapshot.data[0].ngayThu, style: contentStyle)
            ],
          ),
        ), // Ngày thu
      ],
    );
  }

  Row buildButtonChoXuLy(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.lightGreen),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OrderAccept(idDonHang: widget.idDonHang)));
            },
            child: const Text("Nhận đơn hàng", style: TextStyle( fontSize: 15, letterSpacing: 2.2, color: Colors.black)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0, left: 10.0),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.purpleAccent),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OrderCancel(idDonHang: widget.idDonHang)));
            },
            child: const Text("Huỷ đơn hàng", style: TextStyle( fontSize: 15, letterSpacing: 2.2, color: Colors.black)),
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