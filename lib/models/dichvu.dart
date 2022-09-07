// To parse this JSON data, do
//
//     final dichVu = dichVuFromJson(jsonString);

import 'dart:convert';

List<DichVu> dichVuFromJson(String str) => List<DichVu>.from(json.decode(str).map((x) => DichVu.fromJson(x)));

String dichVuToJson(List<DichVu> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DichVu {
  DichVu({
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

  factory DichVu.fromJson(Map<String, dynamic> json) => DichVu(
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
