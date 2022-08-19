import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/models/invoice.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


final urlAPI = url;
class ExpansionList extends StatefulWidget {
  @override
  _ExpansionListState createState() => _ExpansionListState();
}

class _ExpansionListState extends State<ExpansionList> {
  static const TextStyle optionMainStyle = TextStyle(fontSize: 16);
  static const TextStyle optionSubStyle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

  List<Invoice> invoices = [];
  List<Item> _data = [];

  late Box box1;

  @override
  void initState() {
    // TODO: implement initState
    createOpenBox();
    super.initState();
  }

  void createOpenBox() async {
    box1 = await Hive.openBox('logindata');
  }

  Future<List<Invoice>> getHoaDon() async {
    final int IDAccount = box1.get("IDAccount");
    final url = Uri.http(urlAPI, 'api/MobileApp/getHoaDon/$IDAccount');

    final resp = await http.get(url, headers: {
      // "Access-Control-Allow-Origin": "*",
      // "Access-Control-Allow-Credentials": "true",
      "Content-type": "application/json",
      // "Accept": "application/json"
    });
    final response = invoiceFromJson(resp.body);
    return response;
  }

  Widget _buildListPanel() {
    createOpenBox();
    return ExpansionPanelList(
      dividerColor: Colors.black38,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
            canTapOnHeader: true,
            // backgroundColor: Colors.amberAccent,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                leading: Icon(Icons.receipt),
                title: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 1),
                        Text(item.maSoPhieu, style: optionMainStyle),
                        SizedBox(height: 2),
                        Text(item.tenKyThu, style: optionMainStyle),
                        SizedBox(height: 3),
                      ],
                    ),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(height: 10),
                        Text("Đã thu", style: optionMainStyle)
                      ],
                    )),
                  ],
                ),
                subtitle: Text("Tên khách hàng", style: optionSubStyle),
              );
            },
            body: ListTile(
              title: Text("Info chi tiết"),
              onTap: () {
                setState(() {
                  _data.removeWhere((currentItem) => item == currentItem);
                });
              },
            ),
            isExpanded: item.isExpanded);
      }).toList(),
    );
  }

  // Widget _buildListView(List<Item> items){
  //   return ListView(
  //     children: items.map((Item item) {
  //       return Card(
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(10)
  //         ),
  //         elevation: 10,
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: <Widget>[
  //             Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 Padding(padding: EdgeInsets.only(top: 10)),
  //                 Text(item.maSoPhieu),
  //                 Text(item.tenKyThu),
  //                 Text(item.hoTenKH),
  //               ],
  //             )
  //           ],
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: getHoaDon(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          return Text("hello");
        },
      ),
    );
  }
}

class Item {
  int idHoaDon;
  String maSoPhieu;
  String ngayThu;
  String tenKyThu;
  int idAccount;
  String hoTenKH;
  int gia;
  bool isExpanded;

  Item(
      {this.idHoaDon = 0,
      this.maSoPhieu = '',
      this.ngayThu = '',
      this.tenKyThu = '',
      this.idAccount = 0,
      this.hoTenKH = '',
      this.gia = 0,
      this.isExpanded = false});
}

List<Item> generateItems(List<Invoice> invoices) {
  return invoices.map((invoice) {
    return Item(
        idHoaDon: invoice.idHoaDon,
        maSoPhieu: invoice.maSoPhieu,
        ngayThu: invoice.ngayThu,
        tenKyThu: invoice.tenKyThu,
        idAccount: invoice.idAccount,
        hoTenKH: invoice.hoTenKH,
        gia: invoice.gia);
  }).toList();
}
