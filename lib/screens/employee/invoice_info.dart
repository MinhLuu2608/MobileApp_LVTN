import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/models/emp_invoice.dart';
import 'package:MobileApp_LVTN/models/invoice.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'dart:convert';


final urlAPI = url;

class InvoiceInfo extends StatefulWidget{
  EmpInvoice invoice;
  InvoiceInfo({required this.invoice});

  @override
  InvoiceInfoState createState() => InvoiceInfoState(invoice: invoice);
}

class InvoiceInfoState extends State<InvoiceInfo>{
  EmpInvoice invoice;
  InvoiceInfoState({required this.invoice});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var updateState = false;

  static const TextStyle headerStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static const TextStyle contentStyle = TextStyle(fontSize: 20,);
  static const TextStyle chuaThuStyle = TextStyle(fontSize: 20, color: Colors.pink);

  Map<String, dynamic>? paymentIntent;

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
          Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
                child: Text(
                    "Hoá đơn tháng ${invoice.thang}",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
                )
            ),
          ), // Title hoá đơn
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("Mã số phiếu:",style: headerStyle,),
                const SizedBox(width: 5),
                Text(invoice.maSoPhieu, style: contentStyle),
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
                Text(invoice.maKhachHang, style: contentStyle),
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
                Text(invoice.hoTenKH, style: contentStyle),
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
                Text(invoice.tenLoai, style: contentStyle),
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
                Flexible(child: Text(invoice.diaChiKH, style: contentStyle)),
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
                Text(invoice.ngayTao, style: contentStyle),
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
                invoice.ngayThu == "Chưa thu"
                    ? Text(invoice.ngayThu, style: chuaThuStyle)
                    : Text(invoice.ngayThu, style: contentStyle)
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
                Text(invoice.gia.toString() + "đ", style: contentStyle),
              ],
            ),
          ), // Giá
          invoice.ngayThu == "Chưa thu"
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
                        onPressed: () async{
                          if(await checkAbleToPay(invoice.idHoaDon)){
                            var response = await handleConfirm(
                                idHoaDon: invoice.idHoaDon,
                                idNhanVien: invoice.idNhanVien,
                                idTuyenThu: invoice.idTuyenThu
                            );
                            final snackBar = SnackBar(content: Text(response));
                            _scaffoldKey.currentState!.showSnackBar(snackBar);
                            setState(() {
                              updateState = !updateState;
                            });
                          }
                          else{
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
                                          Icon(Icons.warning_amber, color: Colors.amber,),
                                          Flexible(
                                            child: Text("Hoá đơn trước chưa thanh toán", style: TextStyle(fontSize: 18),),
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
                            // Icon(Icons.payment_outlined),
                            // SizedBox(width: 10),
                            Text("Xác nhận thu tiền", style: TextStyle(fontSize: 22, letterSpacing: 2.2, color: Colors.blue)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20)
                    ],
                  ),
                )
              : FutureBuilder(
                  future: getHinhThucThanhToan(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                            Text("Hình thức thanh toán:", style: headerStyle),
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

  Future<String> getHinhThucThanhToan() async {
    final url = Uri.http(urlAPI, 'api/MobileApp/PaymentType/${invoice.idHoaDon}');
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