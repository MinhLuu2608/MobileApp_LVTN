import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/models/donhang.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:MobileApp_LVTN/models/chitiet_dichvu.dart';
import 'dart:convert';
import 'package:intl/intl.dart';


const urlAPI = url;

class OrderEditAndComplete extends StatefulWidget{
  final DonHang donHang;
  final List<ChiTietDichVu> dichVuList;
  OrderEditAndComplete({required this.donHang, required this.dichVuList});

  @override
  OrderEditAndCompleteState createState() => OrderEditAndCompleteState();
}

class OrderEditAndCompleteState extends State<OrderEditAndComplete>{
  OrderEditAndCompleteState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _txtHoTen.text = widget.donHang.hoTen;
    _txtDiaChi.text = widget.donHang.diaChiKh;
    _txtSDT.text = widget.donHang.soDienThoaiKh;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var updateState = false;
  final _txtHoTen = TextEditingController();
  final _txtSDT = TextEditingController();
  final _txtDiaChi = TextEditingController();
  final _txtTongTienDH = TextEditingController();

  List<String> buoiHen = ["Sáng", "Chiều"];

  static const TextStyle headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const TextStyle contentStyle = TextStyle(fontSize: 20,);
  static const TextStyle chuaThuStyle = TextStyle(fontSize: 20, color: Colors.pink);
  static const TextStyle tableHeaderStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  static const TextStyle tableRowStyle = TextStyle(fontSize: 14);


  Future refresh() async{
    setState(() {
      updateState = !updateState;
    });
  }

  getServiceList() async {
    final url = Uri.http(urlAPI, 'api/MobileApp/getOrdersServiceInfo/${widget.donHang.idDonHang}');
    final resp = await http.get(url, headers: {
      // "Access-Control-Allow-Origin": "*",
      // "Access-Control-Allow-Credentials": "true",
      "Content-type": "application/json",
      // "Accept": "application/json"
    });
    final response = json.decode(resp.body);
    return response;
  }

  String checkValid() {
    if(_txtHoTen.text.isEmpty || _txtDiaChi.text.isEmpty) {
      return 'Họ tên hoặc địa chỉ không thể trống';
    }
    if(_txtSDT.text.length != 10){
      return 'Số điện thoại phải có 10 chữ số';
    }
    return "OK";
  }

  void updateAmount(int index, int amount){
    widget.dichVuList[index].soLuong = amount;
    var newTongTienDV = amount * widget.dichVuList[index].donGia;
    var updateTongTienDH = newTongTienDV - widget.dichVuList[index].tongTienDv;
    widget.dichVuList[index].tongTienDv = amount * widget.dichVuList[index].donGia;
    widget.donHang.tongTienDh += updateTongTienDH.toInt();

  }

  handleCompleteConfirm() async{
    final url = Uri.http(urlAPI, 'api/MobileApp/acceptOrder/');
    // var jsonBody = {
    //   'IDDonHang': widget.idDonHang,
    //   'IDNhanVien': IDNhanVien,
    //   'NgayHen': dateString,
    //   'BuoiHen': valueBuoiHen
    // };
    // String jsonStr = json.encode(jsonBody);
    // final resp = await http.post(url, body: jsonStr, headers: {
    //   // "Access-Control-Allow-Origin": "*",
    //   // "Access-Control-Allow-Credentials": "true",
    //   "Content-type": "application/json",
    //   // "Accept": "application/json"
    // });
    // final response = resp.body;
    // return response;
  }

  handleEditConfirm() async{
    final url = Uri.http(urlAPI, 'api/MobileApp/editOrder/');
    var jsonBody = {
      'IDDonHang': widget.donHang.idDonHang,
      'TenKhachHang': _txtHoTen.text,
      'DiaChiKH': _txtDiaChi.text,
      'SoDienThoaiKH': _txtSDT.text,
      'TongTienDH': _txtTongTienDH.text,
      'DichVuList': ''
    };
    // String jsonStr = json.encode(jsonBody);
    // final resp = await http.put(url, body: jsonStr, headers: {
    //   // "Access-Control-Allow-Origin": "*",
    //   // "Access-Control-Allow-Credentials": "true",
    //   "Content-type": "application/json",
    //   // "Accept": "application/json"
    // });
    // final response = resp.body;
    // return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Padding(padding: EdgeInsets.only(left: 0), child: Text('Chỉnh sửa và hoàn thành')),
        ),
        body: GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
                child: buildInfo(context)
            )
        )
    );
  }

  Column buildInfo(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
          child: Column(
            children: [
              const Center(child: Text("Thông tin đơn hàng", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
              const SizedBox(height: 35),
              buildTextField("Họ và tên", _txtHoTen, false, true),
              buildTextFieldSDT("Số điện thoại", _txtSDT, false, true),
              buildTextField("Địa chỉ", _txtDiaChi, false, true),
            ],
          ),
        ),
        const Center(child: Text("Thông tin dịch vụ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        Padding(
          padding: const EdgeInsets.all(5),
          child: buildTableHeader(context),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.dichVuList.length,
          itemBuilder: (BuildContext context, int index) {
            return buildTableRow(context, index);
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 30, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Tổng tiền: ", style: headerStyle),
              Text(widget.donHang.tongTienDh.toString()),
            ],
          ),
        ),
        buildButton(context)
      ],
    );
  }

  Padding buildTableRow(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 5.0, bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.27,
            child: Center(child: Text(widget.dichVuList[index].tenDichVu, style: tableRowStyle)),
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.19,
            child: Center(child: Text(widget.dichVuList[index].soLuong.toString(), style: tableRowStyle),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.19,
            child: Center(child: Text(widget.dichVuList[index].donGia.toString(), style: tableRowStyle)),
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.19,
            child: Center(child: Text(widget.dichVuList[index].tongTienDv.toString(), style: tableRowStyle)),
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.05,
            child: IconButton(
              icon: const Icon(Icons.edit),
              iconSize: 25,
              tooltip: "Edit",
              color: Colors.amber,
              splashColor: Colors.grey,
              onPressed: () async{
                await showDialog(context: context,builder: (context) {
                  return StatefulBuilder(builder: (context, setState) {
                    final _value = TextEditingController(text: widget.dichVuList[index].soLuong.toString());
                    return AlertDialog(
                      title: const Center(child: Text("Chỉnh sửa dịch vụ")),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _value,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                            ],
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 3),
                                labelText: "Số lượng:",
                                floatingLabelBehavior: FloatingLabelBehavior.always
                            ),
                            style: const TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              updateAmount(index, int.parse(_value.text));
                              print(widget.dichVuList[index].soLuong);
                              this.setState(() {
                                updateState = !updateState;
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text("Xác nhận", style: TextStyle(fontSize: 20))),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Huỷ bỏ", style: TextStyle(fontSize: 20)))
                      ],
                    );
                  });
                }
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Padding buildTableHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 5.0, bottom: 15.0, top: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.27,
            child: const Center(child: Text("Tên dịch vụ", style: tableHeaderStyle)),
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.19,
            child: const Center(child: Text("Số lượng", style: tableHeaderStyle)),
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.19,
            child: const Center(child: Text("Đơn giá", style: tableHeaderStyle)),
          ),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width * 0.19,
            child: const Center(child: Text("Tổng", style: tableHeaderStyle)),
          ),
        ],
      ),
    );
  }

  Row buildButton(BuildContext context) {
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

            },
            child: const Text("Hoàn thành", style: TextStyle( fontSize: 15, letterSpacing: 2.2, color: Colors.black)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0, left: 10.0),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.amberAccent),
            onPressed: () {

            },
            child: const Text("Chỉnh sửa", style: TextStyle( fontSize: 15, letterSpacing: 2.2, color: Colors.black)),
          ),
        ),
      ],
    );
  }

  Widget buildTextField(
      String labelText, TextEditingController controller, bool isPasswordTextField, bool enableStatus) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        enabled: enableStatus,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 3),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always
        ),
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  Widget buildTextFieldSDT(
      String labelText, TextEditingController controller, bool isPasswordTextField, bool enableStatus) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        enabled: enableStatus,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
        ],
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 3),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always
        ),
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

}