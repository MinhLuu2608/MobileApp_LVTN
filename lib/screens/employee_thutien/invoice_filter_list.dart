import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/models/emp_invoice.dart';
import 'package:MobileApp_LVTN/models/khachhang.dart';
import 'package:MobileApp_LVTN/models/kythu.dart';
import 'package:MobileApp_LVTN/models/tuyenthu_alter.dart';
import 'package:MobileApp_LVTN/screens/employee_thutien//invoice_info.dart';
import 'package:MobileApp_LVTN/screens/employee_thutien/invoice_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

final urlAPI = url;

class InvoiceFilterList extends StatefulWidget {
  final int filterType;
  const InvoiceFilterList({Key? key, required this.filterType}) : super(key: key);

  @override
  InvoiceFilterListState createState() => InvoiceFilterListState();
}

class InvoiceFilterListState extends State<InvoiceFilterList> {
  InvoiceFilterListState();

  static const TextStyle optionMainStyle = TextStyle(fontSize: 16);
  static const TextStyle optionSubStyle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

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
    final int IDNhanVien = box1.get("IDNhanVien");
    final url = Uri.http(
        urlAPI, 'api/MobileApp/getEmpFilter/$IDNhanVien/${widget.filterType}');

    final resp = await http.get(url, headers: {
      // "Access-Control-Allow-Origin": "*",
      // "Access-Control-Allow-Credentials": "true",
      "Content-type": "application/json",
      // "Accept": "application/json"
    });
    var response;
    if (widget.filterType == 0) response = kyThuFromJson(resp.body);
    if (widget.filterType == 1) response = tuyenThu1FromJson(resp.body);
    if (widget.filterType == 2) response = khachHangFromJson(resp.body);
    if (widget.filterType == 3) response = empInvoiceFromJson(resp.body);
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
      body: FutureBuilder(
        future: getHoaDon(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text("Something Wrong");
          }
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: refresh,
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(10),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  if (widget.filterType == 0)
                    return buildKyThu(context, snapshot, index);
                  if (widget.filterType == 1)
                    return buildTuyenThu(context, snapshot, index);
                  if (widget.filterType == 2)
                    return buildKhachHang(context, snapshot, index);
                  if (widget.filterType == 3)
                    return buildHoaDon(context, snapshot, index);
                  return buildHoaDon(context, snapshot, index);
                },
              ),
            );
          }
          return Text("Error while Calling API");
        },
      ),
    );
  }

  Padding buildKhachHang(BuildContext context, AsyncSnapshot<dynamic> snapshot, int index) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => InvoiceList(
                  filterType: widget.filterType,
                  id: snapshot.data[index].idKhachHang
              )));
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.grey[300],
          elevation: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(snapshot.data[index].maKhachHang, style: styleContent),
                  ), // Mã khách hàng
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child:
                        Text(snapshot.data[index].hoTenKh, style: styleContent),
                  ), // Tên khách hàng
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("Địa chỉ: ${snapshot.data[index].diaChi}", style: styleContent),
                  ), //Địa chỉ
                  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text("CCCD: ${snapshot.data[index].cccd}", style: styleContent)), //CCCD
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildTuyenThu(BuildContext context, AsyncSnapshot<dynamic> snapshot, int index) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => InvoiceList(
                  filterType: widget.filterType,
                  id: snapshot.data[index].idTuyenThu
              )));
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.grey[300],
          elevation: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(snapshot.data[index].maTuyenThu, style: styleContent),
                  ), // Mã tuyến thu
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(snapshot.data[index].tenTuyenThu, style: styleContent),
                  ), // Tên tuyến thu
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("Ngày bắt đầu: ${snapshot.data[index].ngayBatDau}", style: styleContent),
                  ), //Ngày bắt đầu
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        const Text("Ngày kết thúc: ", style: styleContent),
                        snapshot.data[index].ngayKetThuc == "Đang hoạt động"
                            ? Text(snapshot.data[index].ngayKetThuc,
                                style: TextStyle(color: Colors.lightGreen, fontSize: 20))
                            : Text(snapshot.data[index].ngayKetThuc,
                                style: TextStyle(color: Colors.pinkAccent, fontSize: 20)),
                      ],
                    ),
                  ), //Ngày kết thúc
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildKyThu(BuildContext context, AsyncSnapshot<dynamic> snapshot, int index) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => InvoiceList(
                  filterType: widget.filterType,
                  id: snapshot.data[index].idKyThu
              )));
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.grey[300],
          elevation: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(snapshot.data[index].tenKyThu, style: styleContent),
                  ), // Tên kỳ thu
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("Ngày tạo: ${snapshot.data[index].ngayTao}", style: styleContent),
                  ), //Ngày tạo
                ],
              ),
            ],
          ),
        ),
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
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(snapshot.data[index].maSoHoaDon, style: styleContent),
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
                          ? const Text(
                              "Chưa thu",
                              style:
                                  TextStyle(color: Colors.pink, fontSize: 20),
                            )
                          : const Text("Đã thu",
                              style: TextStyle(
                                  color: Colors.lightGreen, fontSize: 20)),
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
