import 'package:MobileApp_LVTN/constants.dart';
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
  static const TextStyle contentStyle = TextStyle(fontSize: 18,);
  static const TextStyle chuaThuStyle = TextStyle(fontSize: 18, color: Colors.pink);

  Map<String, dynamic>? paymentIntent;

  Future<List<Invoice>> getHoaDonInfo() async {
    final url = Uri.http(urlAPI, 'api/MobileApp/customerHoaDonInfo/$idHoaDon');

    final resp = await http.get(url, headers: {
      // "Access-Control-Allow-Origin": "*",
      // "Access-Control-Allow-Credentials": "true",
      "Content-type": "application/json",
      // "Accept": "application/json"
    });
    final response = invoiceFromJson(resp.body);
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
                      child: Text(
                          "Hoá đơn tháng ${snapshot.data[0].thang}",
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
                      Text(snapshot.data[0].maKH, style: contentStyle),
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
                      Flexible(child: Text(snapshot.data[0].diaChiKH, style: contentStyle)),
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
                          ? Text(snapshot.data[0].ngayThu, style: chuaThuStyle)
                          : Text(snapshot.data[0].ngayThu, style: contentStyle)
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
                      Text(snapshot.data[0].gia.toString() + "đ", style: contentStyle),
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
                        onPressed: () async{
                          // print("Xác nhận thanh toán");
                          if( await checkAbleToPay(snapshot.data[0].idHoaDon)){
                            await makePayment(snapshot.data[0].gia.toString(), "VND", snapshot.data[0]);
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
                                            child: Text("Hoá đơn trước chưa thanh toán", style: TextStyle(fontSize: 18)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ));
                          }
                          // Navigator.pop(context);
                          // widget.reRender;
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
                    : FutureBuilder(
                  future: getHinhThucThanhToan(snapshot.data[0].idHoaDon),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Hình thức thanh toán:", style: headerStyle),
                            const SizedBox(width: 5),
                            Flexible(child: Text(snapshot.data, style: contentStyle)),
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

  Future<void> makePayment(String amount, String currency, Invoice invoice) async {
    try {
      paymentIntent = await createPaymentIntent(amount, currency);
      //Payment Sheet
      await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent!['client_secret'],
              // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
              // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
              style: ThemeMode.dark,
              merchantDisplayName: 'Flutter Stripe Payment Demo',
              // appearance: PaymentSheetAppearance(
              //   colors: PaymentSheetAppearanceColors(
              //     background: Colors.lightBlue,
              //     primary: Colors.blue,
              //     componentBorder: Colors.red,
              //   ),
              //   shapes: PaymentSheetShape(
              //     borderRadius: 10,
              //     borderWidth: 10,
              //     shadow: PaymentSheetShadowParams(color: Colors.red),
              //   ),
              //   primaryButton: PaymentSheetPrimaryButtonAppearance(
              //     shapes: PaymentSheetPrimaryButtonShape(blurRadius: 8),
              //     colors: PaymentSheetPrimaryButtonTheme(
              //       light: PaymentSheetPrimaryButtonThemeColors(
              //         background: Color.fromARGB(255, 36, 101, 58),
              //         text: Color.fromARGB(255, 235, 92, 30),
              //         border: Color.fromARGB(255, 235, 92, 30),
              //       ),
              //     ),
              //   ),
              // ),
            ),
          ).then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet(invoice: invoice);

    } catch (e, s) {
      // print('exception:$e$s');
    }
  }

  displayPaymentSheet({required Invoice invoice}) async {

    try {
      await Stripe.instance.presentPaymentSheet(
      ).then((value) async{
        final url = Uri.http(urlAPI, 'api/MobileApp/payment');
        var jsonBody = {
          'IDHoaDon': invoice.idHoaDon,
          'IDAccount': invoice.idAccount
        };
        String jsonStr = json.encode(jsonBody);
        final resp = await http.put(url, body: jsonStr, headers: {
          // "Access-Control-Allow-Origin": "*",
          // "Access-Control-Allow-Credentials": "true",
          "Content-type": "application/json",
          // "Accept": "application/json"
        });
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.check_circle, color: Colors.green,),
                      Text("Payment Successfull"),
                    ],
                  ),
                ],
              ),
            ));
        paymentIntent = null;
        setState(() {
          updateState = !updateState;
        });
      }).onError((error, stackTrace){
        // print('Error is:--->$error $stackTrace');
      });


    } on StripeException catch (e) {
      // print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Text("Cancelled "),
          ));
    } catch (e) {
      // print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer sk_test_51LYlhhBpklmPdZX2em963MdGkasAKns73xQ6yyisqO4JTHf8eVOTIHI8GhlQLZtXuyGxRxwXphI17P0A4raA6fIz00wagWVIhu',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      // print('err charging user: ${err.toString()}');
    }
  }

  // calculateAmount(String amount) {
  //   final calculatedAmout = (int.parse(amount)) *15000 ;
  //   return calculatedAmout.toString();
  // }

}