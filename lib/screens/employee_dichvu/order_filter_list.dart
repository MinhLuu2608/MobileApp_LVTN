import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/models/donhang.dart';
import 'package:MobileApp_LVTN/screens/employee_dichvu/order_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

final urlAPI = url;

class OrderFilterList extends StatefulWidget {
  const OrderFilterList({Key? key, required this.filterType}) : super(key: key);
  final int filterType;

  @override
  OrderFilterListState createState() => OrderFilterListState();
}

class OrderFilterListState extends State<OrderFilterList> {
  OrderFilterListState();

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
    final int IDAccount = box1.get("IDAccount");
    final url = Uri.http(urlAPI, 'api/MobileApp/getEmpOrders/$IDAccount/${widget.filterType}');

    final resp = await http.get(url, headers: {
      // "Access-Control-Allow-Origin": "*",
      // "Access-Control-Allow-Credentials": "true",
      "Content-type": "application/json",
      // "Accept": "application/json"
    });
    final response = donHangFromJson(resp.body);
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
                  return buildDonHang(context, snapshot, index);
                },
              ),
            );
          }
          return Text("Error while Calling API");
        },
      ),
    );
  }

  Padding buildDonHang(
      BuildContext context, AsyncSnapshot<dynamic> snapshot, int index) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: InkWell(
        onTap: () async{
          final response = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => OrderInfo(
                  idDonHang: snapshot.data[index].idDonHang,
                  )));
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
                      child: Text("M?? ????n h??ng: ${snapshot.data[index].maDonHang}", style: styleContent),
                    ), //M?? ????n h??ng
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text("T??n kh??ch h??ng: ${snapshot.data[index].tenKhachHang}", style: styleContent),
                    ), // T??n kh??ch h??ng
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text("?????a ch???: ${snapshot.data[index].diaChiKh}", style: styleContent),
                    ), //?????a ch??? KH
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child:
                          Text("S??? ??i???n tho???i: ${snapshot.data[index].soDienThoaiKh}", style: styleContent),
                    ), //SDT

                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: (buildTextTinhTrangXuLy(snapshot, index))
                    ), // T??nh tr???ng x??? l??
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildTextTinhTrangXuLy(AsyncSnapshot<dynamic> snapshot, int index) {
    if(snapshot.data[index].tinhTrangXuLy == "Ch??? x??? l??") {
      return Row(
        children: [
          const Text("T??nh tr???ng x??? l??: ", style: TextStyle(fontSize: 20,)),
          Text(snapshot.data[index].tinhTrangXuLy, style: const TextStyle(fontSize: 20, color: Colors.pinkAccent)),
        ],
      );
    }
    if(snapshot.data[index].tinhTrangXuLy == "???? ti???p nh???n"){
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("T??nh tr???ng x??? l??: ", style: TextStyle(fontSize: 20,)),
              Text(snapshot.data[index].tinhTrangXuLy, style: const TextStyle(fontSize: 20, color: Colors.blue)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text("Ng??y h???n: ${snapshot.data[index].ngayHen} ${snapshot.data[index].buoiHen}", style: TextStyle(fontSize: 20),),
          )
        ],
      );
    }
    if(snapshot.data[index].tinhTrangXuLy == "???? ho??n th??nh"){
        return Row(
          children: [
            const Text("T??nh tr???ng x??? l??: ", style: TextStyle(fontSize: 20,)),
            Text(snapshot.data[index].tinhTrangXuLy, style: const TextStyle(fontSize: 20, color: Colors.green)),
          ],
        );
    }
    if(snapshot.data[index].tinhTrangXuLy == "???? b??? hu???"){
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("T??nh tr???ng x??? l??: ", style: TextStyle(fontSize: 20,)),
              Text("${snapshot.data[index].tinhTrangXuLy} ", style: const TextStyle(fontSize: 20, color: Colors.grey)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text("L?? do: ${snapshot.data[index].note}", style: const TextStyle(fontSize: 20)),
          )
        ],
      );
    }
    return Text(snapshot.data[index].tinhTrangXuLy);
  }
}
