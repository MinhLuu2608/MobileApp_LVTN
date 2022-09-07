// To parse this JSON data, do
//
//     final dichVu = dichVuFromJson(jsonString);

import 'dart:convert';

List<DichVu> dichVuFromJson(String str) => List<DichVu>.from(json.decode(str).map((x) => DichVu.fromJson(x)));

String dichVuToJson(List<DichVu> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DichVu {
  DichVu({
    required this.idDichVu,
    required this.maDichVu,
    required this.loaiDichVu,
    required this.tenDichVu,
    required this.donViTinh,
    required this.donGiaDv,
    required this.tinhTrangDv,
  });

  int idDichVu;
  String maDichVu;
  String loaiDichVu;
  String tenDichVu;
  String donViTinh;
  int donGiaDv;
  int tinhTrangDv;

  factory DichVu.fromJson(Map<String, dynamic> json) => DichVu(
    idDichVu: json["IDDichVu"],
    maDichVu: json["MaDichVu"],
    loaiDichVu: json["LoaiDichVu"],
    tenDichVu: json["TenDichVu"],
    donViTinh: json["DonViTinh"],
    donGiaDv: json["DonGiaDV"],
    tinhTrangDv: json["TinhTrangDV"],
  );

  Map<String, dynamic> toJson() => {
    "IDDichVu": idDichVu,
    "MaDichVu": maDichVu,
    "LoaiDichVu": loaiDichVu,
    "TenDichVu": tenDichVu,
    "DonViTinh": donViTinh,
    "DonGiaDV": donGiaDv,
    "TinhTrangDV": tinhTrangDv,
  };
}
