// To parse this JSON data, do
//
//     final employee_thutien = employeeFromJson(jsonString);

import 'dart:convert';

List<Employee> employeeFromJson(String str) => List<Employee>.from(json.decode(str).map((x) => Employee.fromJson(x)));

String employeeToJson(List<Employee> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Employee {
  Employee({
    required this.maNhanVien,
    required this.hoTen,
    required this.email,
    required this.gioiTinh,
    required this.soDienThoai,
    required this.ngaySinh,
    required this.diaChi,
    required this.cccd,
  });

  String maNhanVien;
  String hoTen;
  String email;
  String gioiTinh;
  String soDienThoai;
  String ngaySinh;
  String diaChi;
  String cccd;

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    maNhanVien: json["MaNhanVien"],
    hoTen: json["HoTen"],
    email: json["Email"],
    gioiTinh: json["GioiTinh"],
    soDienThoai: json["SoDienThoai"],
    ngaySinh: json["NgaySinh"],
    diaChi: json["DiaChi"],
    cccd: json["CCCD"],
  );

  Map<String, dynamic> toJson() => {
    "MaNhanVien": maNhanVien,
    "HoTen": hoTen,
    "Email": email,
    "GioiTinh": gioiTinh,
    "SoDienThoai": soDienThoai,
    "NgaySinh": ngaySinh,
    "DiaChi": diaChi,
    "CCCD": cccd,
  };
}
