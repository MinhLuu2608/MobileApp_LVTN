// To parse this JSON data, do
//
//     final khachHang = khachHangFromJson(jsonString);

import 'dart:convert';

List<KhachHang> khachHangFromJson(String str) => List<KhachHang>.from(json.decode(str).map((x) => KhachHang.fromJson(x)));

String khachHangToJson(List<KhachHang> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class KhachHang {
  KhachHang({
    required this.idKhachHang,
    required this.hoTenKh,
    required this.maKhachHang,
    required this.cccd,
    required this.ngayCap,
    required this.ngayTao,
    required this.diaChi,
    required this.tenXaPhuong,
    required this.tenQuanHuyen,
    required this.tenLoai,
    required this.trangThai,
  });

  int idKhachHang;
  String hoTenKh;
  String maKhachHang;
  String cccd;
  DateTime ngayCap;
  DateTime ngayTao;
  String diaChi;
  String tenXaPhuong;
  String tenQuanHuyen;
  String tenLoai;
  int trangThai;

  factory KhachHang.fromJson(Map<String, dynamic> json) => KhachHang(
    idKhachHang: json["IDKhachHang"],
    hoTenKh: json["HoTenKH"],
    maKhachHang: json["MaKhachHang"],
    cccd: json["CCCD"],
    ngayCap: DateTime.parse(json["NgayCap"]),
    ngayTao: DateTime.parse(json["NgayTao"]),
    diaChi: json["DiaChi"],
    tenXaPhuong: json["TenXaPhuong"],
    tenQuanHuyen: json["TenQuanHuyen"],
    tenLoai: json["TenLoai"],
    trangThai: json["TrangThai"],
  );

  Map<String, dynamic> toJson() => {
    "IDKhachHang": idKhachHang,
    "HoTenKH": hoTenKh,
    "MaKhachHang": maKhachHang,
    "CCCD": cccd,
    "NgayCap": ngayCap.toIso8601String(),
    "NgayTao": ngayTao.toIso8601String(),
    "DiaChi": diaChi,
    "TenXaPhuong": tenXaPhuong,
    "TenQuanHuyen": tenQuanHuyen,
    "TenLoai": tenLoai,
    "TrangThai": trangThai,
  };
}
