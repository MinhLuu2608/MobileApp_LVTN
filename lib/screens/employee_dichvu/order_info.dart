import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/models/donhang.dart';
import 'package:MobileApp_LVTN/models/chitiet_dichvu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


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

  var dichVuList;
  var updateState = false;

  static const TextStyle headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const TextStyle contentStyle = TextStyle(fontSize: 20,);
  static const TextStyle chuaThuStyle = TextStyle(fontSize: 20, color: Colors.pink);

  Future<List<DonHang>> getDonHangInfo() async {
    final url = Uri.http(urlAPI, 'api/MobileApp/getEmpOrdersInfo/${widget.idDonHang}');
    final resp = await http.get(url, headers: {
      // "Access-Control-Allow-Origin": "*",
      // "Access-Control-Allow-Credentials": "true",
      "Content-type": "application/json",
      // "Accept": "application/json"
    });
    final response = donHangFromJson(resp.body);
    dichVuList = await getDichVuList();
    return response;
  }

  Future<List<ChiTietDichVu>> getDichVuList() async {
    final url = Uri.http(urlAPI, 'api/MobileApp/getEmpOrdersServiceInfo/${widget.idDonHang}');
    final resp = await http.get(url, headers: {
      // "Access-Control-Allow-Origin": "*",
      // "Access-Control-Allow-Credentials": "true",
      "Content-type": "application/json",
      // "Accept": "application/json"
    });
    final response = dichVuFromJson(resp.body);
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
      body: FutureBuilder(
        future: getDonHangInfo(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState != ConnectionState.done){
            return Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError){
            return Text("Something Wrong");
          }
          if(snapshot.hasData){
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Center(
                        child: Text("Đơn hàng ${snapshot.data[0].maDonHang}",
                            style: const TextStyle( fontSize: 30, fontWeight: FontWeight.bold))),
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
                        Flexible(child: Text(snapshot.data[0].diaChiKh,style: contentStyle)),
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
                      child: (buildTextTinhTrangXuLy(snapshot))
                  ), // Tình trạng xử lý
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Ngày thu:", style: headerStyle),
                        const SizedBox(width: 5),
                        snapshot.data[0].ngayThu == "Chưa thu"
                            ? Text(snapshot.data[0].ngayThu,
                                style: chuaThuStyle)
                            : Text(snapshot.data[0].ngayThu,
                                style: contentStyle)
                      ],
                    ),
                  ), // Ngày thu
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text("Danh sách dịch vụ", style: headerStyle)
                  ), //Danh sách dịch vụ header
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: buildTableDichVu()
                  ), //Dịch vụ list
                ],
              ),
            );
          }
          return Text("Error while Calling API");
        },
      ),
    );
  }

  Table buildTableDichVu() {
    return Table(
      border: TableBorder.all(),
      columnWidths: const <int, TableColumnWidth>{
        0: FractionColumnWidth(0.3),
        1: FractionColumnWidth(0.1),
        2: FractionColumnWidth(0.2),
        3: FractionColumnWidth(0.2),
        4: FractionColumnWidth(0.2)
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            Text("Tên dịch vụ", style: headerStyle),
            Text("ĐVT", style: headerStyle),
            Text("Đơn giá", style: headerStyle),
            Text("SL", style: headerStyle),
            Text("Tổng", style: headerStyle),
          ],
        )
      ]
    );
  }

  buildTextTinhTrangXuLy(AsyncSnapshot<dynamic> snapshot) {
    if(snapshot.data[0].tinhTrangXuLy == "Chờ xử lý") {
      return Row(
        children: [
          Text("Tình trạng xử lý: ", style: const TextStyle(fontSize: 20,)),
          Text(snapshot.data[0].tinhTrangXuLy, style: const TextStyle(fontSize: 20, color: Colors.pinkAccent)),
        ],
      );
    }
    if(snapshot.data[0].tinhTrangXuLy == "Đã tiếp nhận"){
      return Row(
        children: [
          Text("Tình trạng xử lý: ", style: headerStyle),
          Text(snapshot.data[0].tinhTrangXuLy, style: const TextStyle(fontSize: 20, color: Colors.blue)),
        ],
      );
    }
    if(snapshot.data[0].tinhTrangXuLy == "Đã hoàn thành"){
      return Row(
        children: [
          Text("Tình trạng xử lý: ", style: headerStyle),
          Text(snapshot.data[0].tinhTrangXuLy, style: const TextStyle(fontSize: 20, color: Colors.green)),
        ],
      );
    }
    if(snapshot.data[0].tinhTrangXuLy == "Đã bị huỷ"){
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Tình trạng xử lý: ", style: headerStyle),
              Text("${snapshot.data[0].tinhTrangXuLy} ", style: const TextStyle(fontSize: 20, color: Colors.grey)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text("Lý do: ${snapshot.data[0].note}", style: const TextStyle(fontSize: 20)),
          )
        ],
      );
    }
    return Text(snapshot.data[0].tinhTrangXuLy);
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

  checkAbleToPay(int idHoaDon) async{
    final url = Uri.http(urlAPI, 'api/MobileApp/isAbleToPay/$idHoaDon');
    final resp = await http.get(url, headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "Content-type": "application/json",
      "Accept": "application/json"
    });
    final response = resp.body;

    if(response == "true") {
      return true;
    }
    else {
      return false;
    }
  }

  Future<String> getHinhThucThanhToan(int idHoaDon) async {
    final url = Uri.http(urlAPI, 'api/MobileApp/PaymentType/$idHoaDon');
    final resp = await http.get(url, headers: {
      // "Access-Control-Allow-Origin": "*",
      // "Access-Control-Allow-Credentials": "true",
      "Content-type": "application/json",
      // "Accept": "application/json"
    });
    final response = resp.body;
    return response;
  }

  handleConfirm({required int idHoaDon, required int idNhanVien, required int idTuyenThu}) async{
    final url = Uri.http(urlAPI, 'api/MobileApp/confirm/');
    var jsonBody = {
      'IDHoaDon': idHoaDon,
      'IDNhanVien': idNhanVien,
      'IDTuyenThu': idTuyenThu
    };
    String jsonStr = json.encode(jsonBody);
    final resp = await http.post(url, body: jsonStr, headers: {
      // "Access-Control-Allow-Origin": "*",
      // "Access-Control-Allow-Credentials": "true",
      "Content-type": "application/json",
      // "Accept": "application/json"
    });
    final response = resp.body;
    return response;
  }


}