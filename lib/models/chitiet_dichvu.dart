// To parse this JSON data, do
//
//     final dichVu = dichVuFromJson(jsonString);

import 'dart:convert';

List<ChiTietDichVu> dichVuFromJson(String str) => List<ChiTietDichVu>.from(json.decode(str).map((x) => ChiTietDichVu.fromJson(x)));

String dichVuToJson(List<ChiTietDichVu> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChiTietDichVu {
  ChiTietDichVu({
    required this.idDichVu,
    required this.tenDichVu,
    required this.donViTinh,
    required this.donGia,
    required this.soLuong,
    required this.tongTienDv,
  });

  int idDichVu;
  String tenDichVu;
  String donViTinh;
  int donGia;
  int soLuong;
  int tongTienDv;

  factory ChiTietDichVu.fromJson(Map<String, dynamic> json) => ChiTietDichVu(
    idDichVu: json["IDDichVu"],
    tenDichVu: json["TenDichVu"],
    donViTinh: json["DonViTinh"],
    donGia: json["DonGia"],
    soLuong: json["SoLuong"],
    tongTienDv: json["TongTienDV"],
  );

  Map<String, dynamic> toJson() => {
    "IDDichVu": idDichVu,
    "TenDichVu": tenDichVu,
    "DonViTinh": donViTinh,
    "DonGia": donGia,
    "SoLuong": soLuong,
    "TongTienDV": tongTienDv,
  };
}
