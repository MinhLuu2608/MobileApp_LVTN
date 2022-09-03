// To parse this JSON data, do
//
//     final khachHang = khachHangFromJson(jsonString);

import 'dart:convert';

List<KhachHang> khachHangFromJson(String str) => List<KhachHang>.from(json.decode(str).map((x) => KhachHang.fromJson(x)));

String khachHangToJson(List<KhachHang> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class KhachHang {
  KhachHang({
    required this.idKhachHang,
    required this.maKhachHang,
    required this.hoTenKh,
    required this.diaChi,
    required this.cccd,
  });

  int idKhachHang;
  String maKhachHang;
  String hoTenKh;
  String diaChi;
  String cccd;

  factory KhachHang.fromJson(Map<String, dynamic> json) => KhachHang(
    idKhachHang: json["IDKhachHang"],
    maKhachHang: json["MaKhachHang"],
    hoTenKh: json["HoTenKH"],
    diaChi: json["DiaChi"],
    cccd: json["CCCD"],
  );

  Map<String, dynamic> toJson() => {
    "IDKhachHang": idKhachHang,
    "MaKhachHang": maKhachHang,
    "HoTenKH": hoTenKh,
    "DiaChi": diaChi,
    "CCCD": cccd,
  };
}
