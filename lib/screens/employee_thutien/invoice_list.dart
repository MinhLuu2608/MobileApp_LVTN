import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/models/emp_invoice.dart';
import 'package:MobileApp_LVTN/models/khachhang.dart';
import 'package:MobileApp_LVTN/models/kythu.dart';
import 'package:MobileApp_LVTN/models/tuyenthu_alter.dart';
import 'package:MobileApp_LVTN/screens/employee_thutien//invoice_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

final urlAPI = url;

class InvoiceList extends StatefulWidget {
  const InvoiceList({Key? key, required this.filterType, required this.id}) : super(key: key);
  final int filterType;
  final int id;

  @override
  InvoiceListState createState() => InvoiceListState();
}

class InvoiceListState extends State<InvoiceList> {
  InvoiceListState();

  static const TextStyle optionMainStyle = TextStyle(fontSize: 16);
  static const TextStyle optionSubStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

  static const TextStyle styleContent = TextStyle(fontSize: 20);

  late Box box1;

  var updateState = false;

  @override
  void initState() {
    // TODO: implement initState
    createOpenBox();
    super.initState();
  }

  void createOpenBox() async {
    box1 = await Hive.openBox('logindata');
  }

  getHoaDon() async {
    box1 = await Hive.openBox('logindata');
    final int IDAccount = box1.get("IDAccount");
    final url = Uri.http(
        urlAPI, 'api/MobileApp/getEmpHoaDonFilter/$IDAccount/${widget.filterType}/${widget.id}');

    final resp = await http.get(url, headers: {
      // "Access-Control-Allow-Origin": "*",
      // "Access-Control-Allow-Credentials": "true",
      "Content-type": "application/json",
      // "Accept": "application/json"
    });
    final response = empInvoiceFromJson(resp.body);
    return response;
  }

  Future refresh() async {
    setState(() {
      updateState = !updateState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Danh sách hoá đơn")),
      body: FutureBuilder(
        future: getHoaDon(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Text("Something Wrong");
          }
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: refresh,
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(10),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildHoaDon(context, snapshot, index);
                },
              ),
            );
          }
          return const Text("Error while Calling API");
        },
      ),
    );
  }
  Padding buildHoaDon(
      BuildContext context, AsyncSnapshot<dynamic> snapshot, int index) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: InkWell(
        onTap: () async{
          final response = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => InvoiceInfo(idHoaDon: snapshot.data[index].idHoaDon)));
          if(response == null){
            setState(() {
              updateState = !updateState;
            });
          }
        },
        child: Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.grey[300],
          elevation: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(snapshot.data[index].maSoPhieu, style: styleContent),
                    ), //Mã số phiếu
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(snapshot.data[index].tenKyThu, style: styleContent),
                    ), // Tên kỳ thu
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(snapshot.data[index].hoTenKH, style: styleContent),
                    ), //Họ tên KH
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child:
                      Text("Tuyến thu: ${snapshot.data[index].tenTuyenThu}", style: styleContent),
                    ), //Tên tuyến thu
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: snapshot.data[index].ngayThu == "Chưa thu"
                          ? const Text( "Chưa thu", style: TextStyle(color: Colors.pink, fontSize: 20))
                          : const Text("Đã thu", style: TextStyle(color: Colors.lightGreen, fontSize: 20)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
