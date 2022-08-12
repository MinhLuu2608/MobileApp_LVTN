// To parse this JSON data, do
//
//     final nhanVien = nhanVienFromJson(jsonString);

import 'dart:convert';

List<NhanVien> nhanVienFromJson(String str) => List<NhanVien>.from(json.decode(str).map((x) => NhanVien.fromJson(x)));

String nhanVienToJson(List<NhanVien> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NhanVien {
  NhanVien({
    required this.idNhanVien,
    required this.maNhanVien,
    required this.hoTen,
    required this.email,
    required this.gioiTinh,
    required this.soDienThoai,
    required this.ngaySinh,
    required this.diaChi,
    required this.cccd,
    required this.profilePicture,
  });

  int idNhanVien;
  String maNhanVien;
  String hoTen;
  String email;
  String gioiTinh;
  String soDienThoai;
  DateTime ngaySinh;
  String diaChi;
  String cccd;
  String profilePicture;

  factory NhanVien.fromJson(Map<String, dynamic> json) => NhanVien(
    idNhanVien: json["IDNhanVien"],
    maNhanVien: json["MaNhanVien"],
    hoTen: json["HoTen"],
    email: json["Email"],
    gioiTinh: json["GioiTinh"],
    soDienThoai: json["SoDienThoai"],
    ngaySinh: DateTime.parse(json["NgaySinh"]),
    diaChi: json["DiaChi"],
    cccd: json["CCCD"],
    profilePicture: json["ProfilePicture"],
  );

  Map<String, dynamic> toJson() => {
    "IDNhanVien": idNhanVien,
    "MaNhanVien": maNhanVien,
    "HoTen": hoTen,
    "Email": email,
    "GioiTinh": gioiTinh,
    "SoDienThoai": soDienThoai,
    "NgaySinh": ngaySinh.toIso8601String(),
    "DiaChi": diaChi,
    "CCCD": cccd,
    "ProfilePicture": profilePicture,
  };
}
