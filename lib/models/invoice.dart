// To parse this JSON data, do
//
//     final invoice = invoiceFromJson(jsonString);

import 'dart:convert';

List<Invoice> invoiceFromJson(String str) => List<Invoice>.from(json.decode(str).map((x) => Invoice.fromJson(x)));

String invoiceToJson(List<Invoice> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Invoice {
  Invoice({
    required this.idHoaDon,
    required this.maSoPhieu,
    required this.ngayThu,
    required this.tenKyThu,
    required this.idAccount,
    required this.hoTenKH,
    required this.gia,
  });

  int idHoaDon;
  String maSoPhieu;
  String ngayThu;
  String tenKyThu;
  int idAccount;
  String hoTenKH;
  int gia;

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
    idHoaDon: json["IDHoaDon"],
    maSoPhieu: json["MaSoPhieu"],
    ngayThu: json["NgayThu"] == null ? "Chưa thu" : json["NgayThu"],
    tenKyThu: json["TenKyThu"],
    idAccount: json["IDAccount"],
    hoTenKH: json["HoTenKH"],
    gia: json["Gia"],
  );

  Map<String, dynamic> toJson() => {
    "IDHoaDon": idHoaDon,
    "MaSoPhieu": maSoPhieu,
    "NgayThu": ngayThu == null ? null : ngayThu,
    "TenKyThu": tenKyThu,
    "IDAccount": idAccount,
    "HoTenKH": hoTenKH,
    "Gia": gia,
  };
}
