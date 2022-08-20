import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/models/invoice.dart';
import 'package:flutter/material.dart';

final urlAPI = url;

class InvoiceInfo extends StatefulWidget{
  Invoice invoice;
  InvoiceInfo({required this.invoice});
  @override
  InvoiceInfoState createState() => InvoiceInfoState(invoice: invoice);
}

class InvoiceInfoState extends State<InvoiceInfo>{
  Invoice invoice;
  InvoiceInfoState({required this.invoice});

  static const TextStyle headerStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static const TextStyle contentStyle = TextStyle(fontSize: 20,);
  static const TextStyle chuaThuStyle = TextStyle(fontSize: 20, color: Colors.pink);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Text(invoice.maKH, style: contentStyle),
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
                        onPressed: () {
                          print("Xác nhận thanh toán");
                          // paymentController.makePayment(amount: '5', currency: 'USD');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.payment_outlined),
                            SizedBox(width: 10),
                            Text("Thanh toán",
                                style: TextStyle(
                                    fontSize: 22,
                                    letterSpacing: 2.2,
                                    color: Colors.blue)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20)
                    ],
                  ),
                )
              : const Text("")
        ],
      ),
    );
  }
}