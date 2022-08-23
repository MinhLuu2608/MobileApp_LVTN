import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/models/emp_invoice.dart';
import 'package:MobileApp_LVTN/models/invoice.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'dart:convert';


final urlAPI = url;

class InvoiceInfo extends StatefulWidget{
  final int idHoaDon;
  InvoiceInfo({required this.idHoaDon});

  @override
  InvoiceInfoState createState() => InvoiceInfoState(idHoaDon: idHoaDon);
}

class InvoiceInfoState extends State<InvoiceInfo>{
  final int idHoaDon;
  InvoiceInfoState({required this.idHoaDon});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var updateState = false;

  static const TextStyle headerStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static const TextStyle contentStyle = TextStyle(fontSize: 20,);
  static const TextStyle chuaThuStyle = TextStyle(fontSize: 20, color: Colors.pink);

  Future<List<EmpInvoice>> getHoaDonInfo() async {
    final url = Uri.http(urlAPI, 'api/MobileApp/empHoaDonInfo/$idHoaDon');

    final resp = await http.get(url, headers: {
      // "Access-Control-Allow-Origin": "*",
      // "Access-Control-Allow-Credentials": "true",
      "Content-type": "application/json",
      // "Accept": "application/json"
    });
    final response = empInvoiceFromJson(resp.body);
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
        future: getHoaDonInfo(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState != ConnectionState.done){
            return Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError){
            return Text("Something Wrong");
          }
          if(snapshot.hasData){
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                      child: Text("Hoá đơn tháng ${snapshot.data[0].thang}",
                          style: const TextStyle( fontSize: 30, fontWeight: FontWeight.bold))),
                ), // Title hoá đơn
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Mã số phiếu:",
                        style: headerStyle,
                      ),
                      const SizedBox(width: 5),
                      Text(snapshot.data[0].maSoPhieu, style: contentStyle),
                    ],
                  ),
                ), // Mã số phiếu
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Mã khách hàng:", style: headerStyle),
                      const SizedBox(width: 5),
                      Text(snapshot.data[0].maKhachHang, style: contentStyle),
                    ],
                  ),
                ), // Mã khách hàng
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Tên khách hàng:", style: headerStyle),
                      const SizedBox(width: 5),
                      Text(snapshot.data[0].hoTenKH, style: contentStyle),
                    ],
                  ),
                ), // Tên khách hàng
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Loại khách hàng:", style: headerStyle),
                      const SizedBox(width: 5),
                      Text(snapshot.data[0].tenLoai, style: contentStyle),
                    ],
                  ),
                ), // Loại khách hàng
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Địa chỉ:", style: headerStyle),
                      const SizedBox(width: 5),
                      Flexible(
                          child: Text(snapshot.data[0].diaChiKH,
                              style: contentStyle)),
                    ],
                  ),
                ), // Địa chỉ khách hàng
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Ngày tạo hoá đơn:", style: headerStyle),
                      const SizedBox(width: 5),
                      Text(snapshot.data[0].ngayTao, style: contentStyle),
                    ],
                  ),
                ), // Ngày tạo
                Padding(
                  padding: const EdgeInsets.all(10),
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
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Giá:", style: headerStyle),
                      const SizedBox(width: 5),
                      Text(snapshot.data[0].gia.toString() + "đ",
                          style: contentStyle),
                    ],
                  ),
                ), // Giá
                snapshot.data[0].ngayThu == "Chưa thu"
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.greenAccent,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )),
                              onPressed: () async {
                                if (await checkAbleToPay(
                                    snapshot.data[0].idHoaDon)) {
                                  var response = await handleConfirm(
                                      idHoaDon: snapshot.data[0].idHoaDon,
                                      idNhanVien: snapshot.data[0].idNhanVien,
                                      idTuyenThu: snapshot.data[0].idTuyenThu
                                  );
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Icon(Icons.check_circle_outline, color: Colors.green),
                                                Flexible(child: Text(response, style: TextStyle(fontSize: 18)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ));
                                  setState(() {
                                    updateState = !updateState;
                                  });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: const [
                                                    Icon( Icons.warning_amber, color: Colors.amber),
                                                    Flexible(
                                                      child: Text(
                                                        "Hoá đơn trước chưa thanh toán", style: TextStyle(fontSize: 18),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ));
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text("Xác nhận thu tiền", style: TextStyle(fontSize: 22, letterSpacing: 2.2, color: Colors.blue)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20)
                          ],
                        ),
                      )
                    : FutureBuilder(
                        future:
                            getHinhThucThanhToan(snapshot.data[0].idHoaDon),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState != ConnectionState.done) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Text("Something Wrong");
                          }
                          if (snapshot.hasData) {
                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text("Hình thức thanh toán:", style: headerStyle),
                                  const SizedBox(width: 5),
                                  Text(snapshot.data, style: contentStyle),
                                ],
                              ),
                            );
                          }
                          return Text("Error while Calling API");
                        },
                      )
              ],
            );
          }
          return Text("Error while Calling API");
        },
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