import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/models/chitiet_dichvu.dart';
import 'package:MobileApp_LVTN/models/donhang.dart';
import 'package:MobileApp_LVTN/screens/employee_dichvu/order_accept.dart';
import 'package:MobileApp_LVTN/screens/employee_dichvu/order_cancel.dart';
import 'package:MobileApp_LVTN/screens/employee_dichvu/order_edit_and_complete.dart';
import 'package:MobileApp_LVTN/screens/employee_dichvu/preview_print_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
    final response = chiTietDichVuFromJson(resp.body);
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
        title: const Padding(padding: EdgeInsets.only(left: 50), child: Text('Chi ti???t ????n h??ng')),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                          child: Text("Danh s??ch d???ch v???", style: headerStyle)
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: buildTableHeader(context),
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
                      ), //D???ch v??? list
                      Padding(
                        padding: const EdgeInsets.only(right: 50, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text("T???ng ti???n: ", style: headerStyle),
                            Text("${snapshot.data[0].tongTienDh.toString()}??", style: contentStyle),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (snapshot.data[0].tinhTrangXuLy == 'Ch??? x??? l??') buildButtonChoXuLy(context),
                          if (snapshot.data[0].tinhTrangXuLy == '???? ti???p nh???n') buildButtonDaTiepNhan(context),
                          if (snapshot.data[0].tinhTrangXuLy == '???? ho??n th??nh') buildButtonDaHoanThanh(context),
                        ],
                      )
                    ],
                  );
                }
                return const Text("Error while Calling API");
              },
            ),
          ],
        ),
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
            child: Text("????n h??ng ${snapshot.data[0].maDonHang}", style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
        ), // Title ????n h??ng
        Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "T??n kh??ch h??ng",
                style: headerStyle,
              ),
              const SizedBox(width: 5),
              Text(snapshot.data[0].tenKhachHang, style: contentStyle),
            ],
          ),
        ), // T??n kh??ch h??ng
        Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("?????a ch???:", style: headerStyle),
              const SizedBox(width: 5),
              Flexible(
                  child: Text(snapshot.data[0].diaChiKh, style: contentStyle)),
            ],
          ),
        ), // ?????a ch??? kh??ch h??ng
        Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("S??? ??i???n tho???i:", style: headerStyle),
              const SizedBox(width: 5),
              Text(snapshot.data[0].soDienThoaiKh, style: contentStyle),
            ],
          ),
        ), // S??? ??i???n tho???i KH
        Padding(
            padding: const EdgeInsets.all(5.0),
            child:
                (buildTextTinhTrangXuLy(snapshot.data[0]))), // T??nh tr???ng x??? l??
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
      ],
    );
  }

  Row buildButtonDaHoanThanh(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.lightGreen),
            onPressed: () async {
              List<DonHang> donHangList = await getHoaDon();
              DonHang donHang = donHangList[0];
              List<ChiTietDichVu> dichVuList = await getServiceList();
              final response = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PreviewScreenOrder(donHang: donHang, dichVuList: dichVuList)));
              if(response == null){
                setState(() {
                  updateState = !updateState;
                });
              }
            },
            child: const Text("In ????n h??ng", style: TextStyle( fontSize: 16, letterSpacing: 2.2, color: Colors.black)),
          ),
        )
      ],
    );
  }

  Row buildButtonDaTiepNhan(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.lightGreen),
            onPressed: () async {
              List<DonHang> donHangList = await getHoaDon();
              DonHang donHang = donHangList[0];
              List<ChiTietDichVu> dichVuList = await getServiceList();
              final response = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OrderEditAndComplete(donHang: donHang, dichVuList: dichVuList)));
              if(response == null){
                setState(() {
                  updateState = !updateState;
                });
              }
            },
            child: const Text("Ch???nh s???a v?? ho??n th??nh", style: TextStyle( fontSize: 15, letterSpacing: 1.0, color: Colors.black)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0, left: 10.0),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.purpleAccent),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OrderCancel(idDonHang: widget.idDonHang)));
            },
            child: const Text("Hu??? ????n h??ng", style: TextStyle( fontSize: 15, letterSpacing: 1.5, color: Colors.black)),
          ),
        ),
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
            onPressed: () async {
              final response = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OrderAccept(idDonHang: widget.idDonHang)));
              if(response == null){
                setState(() {
                  updateState = !updateState;
                });
              }
            },
            child: const Text("Nh???n ????n h??ng", style: TextStyle( fontSize: 15, letterSpacing: 2.2, color: Colors.black)),
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
            child: const Text("Hu??? ????n h??ng", style: TextStyle( fontSize: 15, letterSpacing: 2.2, color: Colors.black)),
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
            child: Center(child: Text(snapshot.data[index].tenDichVu, style: tableRowStyle)),
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.20,
            child: Center(child: Text(snapshot.data[index].soLuong.toString(), style: tableRowStyle),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.20,
            child: Center(child: Text(snapshot.data[index].donGia.toString(), style: tableRowStyle)),
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.20,
            child: Center(child: Text(snapshot.data[index].tongTienDv.toString(), style: tableRowStyle)),
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
            child: const Center(child: Text("T??n d???ch v???", style: tableHeaderStyle)),
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.20,
            child: const Center(child: Text("S??? l?????ng", style: tableHeaderStyle)),
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.20,
            child: const Center(child: Text("????n gi??", style: tableHeaderStyle)),
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.20,
            child: const Center(child: Text("T???ng", style: tableHeaderStyle)),
          ),
        ],
      ),
    );
  }

  buildTextTinhTrangXuLy(DonHang donHang) {
    if(donHang.tinhTrangXuLy == "Ch??? x??? l??") {
      return Row(
        children: [
          Text("T??nh tr???ng x??? l??: ", style: headerStyle),
          Text(donHang.tinhTrangXuLy, style: const TextStyle(fontSize: 20, color: Colors.pinkAccent)),
        ],
      );
    }
    if(donHang.tinhTrangXuLy == "???? ti???p nh???n"){
      return Row(
        children: [
          Text("T??nh tr???ng x??? l??: ", style: headerStyle),
          Text(donHang.tinhTrangXuLy, style: const TextStyle(fontSize: 20, color: Colors.blue)),
        ],
      );
    }
    if(donHang.tinhTrangXuLy == "???? ho??n th??nh"){
      return Row(
        children: [
          Text("T??nh tr???ng x??? l??: ", style: headerStyle),
          Text(donHang.tinhTrangXuLy, style: const TextStyle(fontSize: 20, color: Colors.green)),
        ],
      );
    }
    if(donHang.tinhTrangXuLy == "???? b??? hu???"){
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("T??nh tr???ng x??? l??: ", style: headerStyle),
              Text("${donHang.tinhTrangXuLy} ", style: const TextStyle(fontSize: 20, color: Colors.grey)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text("L?? do: ${donHang.note}", style: const TextStyle(fontSize: 20)),
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
              Flexible(child: Text(response, style: TextStyle(fontSize: 18)))
            ],
          ),
        ],
      ),
    );
  }

}