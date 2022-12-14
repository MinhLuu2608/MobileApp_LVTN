import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/models/emp_invoice.dart';
import 'package:MobileApp_LVTN/screens/employee_thutien/preview_print_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:crypto/crypto.dart';

const urlAPI = url;

class InvoiceInfo extends StatefulWidget{
  final int idHoaDon;
  const InvoiceInfo({Key? key, required this.idHoaDon}) : super(key: key);
  @override
  InvoiceInfoState createState() => InvoiceInfoState();
}

class InvoiceInfoState extends State<InvoiceInfo>{

  var updateState = false;
  var hinhThucThanhToan = "";
  final _password = TextEditingController();
  bool _showpass = true;

  late Box box1;

  static const TextStyle headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const TextStyle contentStyle = TextStyle(fontSize: 20,);
  static const TextStyle chuaThuStyle = TextStyle(fontSize: 20, color: Colors.pink);

  Future<String> handleCheckPass() async{
    final url = Uri.http(urlAPI, 'api/MobileApp/checkRepass');
    box1 = await Hive.openBox('logindata');
    final int IDAccount = box1.get("IDAccount");
    var jsonBody = {
      'IDAccount': IDAccount,
      'Password': getHashMD5(_password.text)
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

  Future<List<EmpInvoice>> getHoaDonInfo() async {
    final url = Uri.http(urlAPI, 'api/MobileApp/empHoaDonInfo/${widget.idHoaDon}');

    final resp = await http.get(url, headers: {
      // "Access-Control-Allow-Origin": "*",
      // "Access-Control-Allow-Credentials": "true",
      "Content-type": "application/json",
      // "Accept": "application/json"
    });
    final response = empInvoiceFromJson(resp.body);
    hinhThucThanhToan = await getHinhThucThanhToan(widget.idHoaDon);
    return response;
  }

  Future refresh() async{
    setState(() {
      updateState = !updateState;
    });
  }

  getHashMD5(String input){
    var bytes = utf8.encode(input);
    var md5Hash = md5.convert(bytes).toString();
    return md5Hash;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(padding: EdgeInsets.only(left: 50), child: Text('Chi ti???t ho?? ????n')),
      ),
      body: FutureBuilder(
        future: getHoaDonInfo(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState != ConnectionState.done){
            return const Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError){
            return const Text("Something Wrong");
          }
          if(snapshot.hasData){
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Center(
                      child: Text("Ho?? ????n th??ng ${snapshot.data[0].thang}",
                          style: const TextStyle( fontSize: 30, fontWeight: FontWeight.bold))),
                ), // Title ho?? ????n
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "M?? s??? phi???u:",
                        style: headerStyle,
                      ),
                      const SizedBox(width: 5),
                      Text(snapshot.data[0].maSoHoaDon, style: contentStyle),
                    ],
                  ),
                ), // M?? s??? phi???u
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("M?? kh??ch h??ng:", style: headerStyle),
                      const SizedBox(width: 5),
                      Text(snapshot.data[0].maKhachHang, style: contentStyle),
                    ],
                  ),
                ), // M?? kh??ch h??ng
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("T??n kh??ch h??ng:", style: headerStyle),
                      const SizedBox(width: 5),
                      Text(snapshot.data[0].hoTenKH, style: contentStyle),
                    ],
                  ),
                ), // T??n kh??ch h??ng
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Lo???i kh??ch h??ng:", style: headerStyle),
                      const SizedBox(width: 5),
                      Text(snapshot.data[0].tenLoai, style: contentStyle),
                    ],
                  ),
                ), // Lo???i kh??ch h??ng
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("?????a ch???:", style: headerStyle),
                      const SizedBox(width: 5),
                      Flexible(child: Text(snapshot.data[0].diaChiKH,style: contentStyle)),
                    ],
                  ),
                ), // ?????a ch??? kh??ch h??ng
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Ng??y t???o ho?? ????n:", style: headerStyle),
                      const SizedBox(width: 5),
                      Text(snapshot.data[0].ngayTao, style: contentStyle),
                    ],
                  ),
                ), // Ng??y t???o
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Ng??y thu:", style: headerStyle),
                      const SizedBox(width: 5),
                      snapshot.data[0].ngayThu == "Ch??a thu"
                          ? Text(snapshot.data[0].ngayThu, style: chuaThuStyle)
                          : Text(snapshot.data[0].ngayThu, style: contentStyle)
                    ],
                  ),
                ), // Ng??y thu
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Gi??:", style: headerStyle),
                      const SizedBox(width: 5),
                      Text("${snapshot.data[0].gia}??", style: contentStyle),
                    ],
                  ),
                ), // Gi??
                snapshot.data[0].ngayThu == "Ch??a thu"
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
                                await showDialog(context: context,builder: (context) {
                                  return StatefulBuilder(builder: (context, setState) {
                                    return AlertDialog(
                                      title: const Center(child: Text("X??c nh???n ho??n th??nh")),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: _password,
                                            obscureText: _showpass,
                                            decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.only(bottom: 3),
                                                labelText: "Nh???p l???i m???t kh???u:",
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                suffixIcon: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _showpass = !_showpass;
                                                      });
                                                    },
                                                    icon: Icon(_showpass ? Icons.visibility : Icons.visibility_off, color: Colors.grey)
                                                )
                                            ),
                                            style: const TextStyle(fontSize: 20),
                                          )
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            String checkResponse = await handleCheckPass();
                                            if(checkResponse != "\"OK\"") {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text(checkResponse, style: const TextStyle(fontSize: 20)))
                                              );
                                            }
                                            else{
                                              if (await checkAbleToPay(snapshot.data[0].idHoaDon)) {
                                                var response = await handleConfirm(
                                                  idHoaDon: snapshot.data[0].idHoaDon,
                                                  idNhanVien: snapshot.data[0].idNhanVien,
                                                  idTuyenThu: snapshot.data[0].idTuyenThu
                                                );
                                                Navigator.of(context).pop();
                                                showDialog(
                                                  context: context,
                                                  builder: (_) => buildAlertDialogSuccess(response));
                                              }
                                              else {
                                                showDialog(
                                                  context: context,
                                                  builder: (_) => buildAlertDialogWarning());
                                              }
                                            }
                                          },
                                          child: const Text("X??c nh???n", style: TextStyle(fontSize: 20))),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Hu??? b???", style: TextStyle(fontSize: 20)))
                                      ],
                                    );
                                  });
                                });
                                setState(() {
                                  updateState = !updateState;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text("X??c nh???n thu ti???n", style: TextStyle(fontSize: 22, letterSpacing: 2.2, color: Colors.blue)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20)
                          ],
                        ),
                      )
                    : buildDaThuButton(snapshot)
              ],
            );
          }
          return const Text("Error while Calling API");
        },
      ),
    );
  }

  Expanded buildDaThuButton(AsyncSnapshot<dynamic> snapshot) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("H??nh th???c thanh to??n: ", style: headerStyle),
                Flexible(child: Text(hinhThucThanhToan, style: contentStyle))
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                buildInHoaDonButton(snapshot),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column buildInHoaDonButton(AsyncSnapshot<dynamic> snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )),
          onPressed: () async {
            _displayPdf(snapshot.data[0]);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text("In ho?? ????n",style: TextStyle(fontSize: 22, letterSpacing: 2.2, color: Colors.blue)),
            ],
          ),
        ),
        const SizedBox(height: 20)
      ],
    );
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
              Flexible(child: Text( "Ho?? ????n tr?????c ch??a thanh to??n", style: TextStyle(fontSize: 18)))
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
              Flexible(child: Text(response, style: const TextStyle(fontSize: 18)))
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
    final response = json.decode(resp.body);
    return response;
  }



  void _displayPdf(EmpInvoice empInvoice) {
    Navigator.push(context, MaterialPageRoute(builder:
        (context) => PreviewScreen(empInvoice: empInvoice),));
  }

}