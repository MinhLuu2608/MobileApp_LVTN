import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/models/employee.dart';
import 'package:MobileApp_LVTN/models/tuyenthu.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

final urlAPI = url;

class EmpInfo extends StatefulWidget{
  EmpInfo({Key? key}) : super (key: key);

  @override
  EmpInfoState createState() => EmpInfoState();
}

class EmpInfoState extends State<EmpInfo>{

  static const TextStyle headerStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static const TextStyle contentStyle = TextStyle(fontSize: 20,);

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

  Future<List<Employee>> getNhanVien() async {
    box1 = await Hive.openBox('logindata');
    final int IDNhanVien = box1.get("IDNhanVien");
    final url = Uri.http(urlAPI, 'api/MobileApp/getEmp/$IDNhanVien');

    final resp = await http.get(url, headers: {
      // "Access-Control-Allow-Origin": "*",
      // "Access-Control-Allow-Credentials": "true",
      "Content-type": "application/json",
      // "Accept": "application/json"
    });
    final response = employeeFromJson(resp.body);
    return response;
  }

  Future<List<TuyenThu>> getTuyenThuByNhanVien() async {
    box1 = await Hive.openBox('logindata');
    final int IDNhanVien = box1.get("IDNhanVien");
    final url = Uri.http(urlAPI, 'api/MobileApp/getTuyenThu/$IDNhanVien');

    final resp = await http.get(url, headers: {
      // "Access-Control-Allow-Origin": "*",
      // "Access-Control-Allow-Credentials": "true",
      "Content-type": "application/json",
      // "Accept": "application/json"
    });
    final response = tuyenThuFromJson(resp.body);
    return response;
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getNhanVien(),
      builder: (BuildContext context, AsyncSnapshot snapshotNV) {
        if (snapshotNV.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshotNV.hasError) {
          return Text("Something Wrong");
        }
        if (snapshotNV.hasData) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.person, color: Colors.black12, size: 100)
                  ],
                ), // Icon
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Mã nhân viên:", style: headerStyle),
                      const SizedBox(width: 5),
                      Text(snapshotNV.data[0].maNhanVien, style: contentStyle),
                    ],
                  ),
                ), // Mã nhân viên
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Tên nhân viên:", style: headerStyle),
                      const SizedBox(width: 5),
                      Text(snapshotNV.data[0].hoTen, style: contentStyle),
                    ],
                  ),
                ), //Tên nhân viên
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Ngày sinh:", style: headerStyle),
                      const SizedBox(width: 5),
                      Text(snapshotNV.data[0].ngaySinh, style: contentStyle),
                    ],
                  ),
                ), //Ngày sinh
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Tên nhân viên:", style: headerStyle),
                      const SizedBox(width: 5),
                      Text(snapshotNV.data[0].hoTen, style: contentStyle),
                    ],
                  ),
                ), // Giới tính
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("CCCD:", style: headerStyle),
                      const SizedBox(width: 5),
                      Text(snapshotNV.data[0].cccd, style: contentStyle),
                    ],
                  ),
                ), //CCCD
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Địa chỉ:", style: headerStyle),
                      const SizedBox(width: 5),
                      Flexible(child: Text(snapshotNV.data[0].diaChi, style: contentStyle)),
                    ],
                  ),
                ), //Địa chỉ
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("SĐT:", style: headerStyle),
                      const SizedBox(width: 5),
                      Text(snapshotNV.data[0].soDienThoai, style: contentStyle),
                    ],
                  ),
                ), // SDT
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Email:", style: headerStyle),
                      const SizedBox(width: 5),
                      Text(snapshotNV.data[0].email, style: contentStyle),
                    ],
                  ),
                ), //Email
              ],
            ),
          );
        }
        return Text("Error while Calling API");
      },
    );
  }
}