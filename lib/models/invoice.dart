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
    required this.ngayTao,
    required this.ngayThu,
    required this.tenKyThu,
    required this.thang,
    required this.idAccount,
    required this.maKH,
    required this.hoTenKH,
    required this.diaChiKH,
    required this.tenLoai,
    required this.gia,
  });

  int idHoaDon;
  String maSoPhieu;
  String ngayTao;
  String ngayThu;
  String tenKyThu;
  int thang;
  int idAccount;
  String maKH;
  String hoTenKH;
  String diaChiKH;
  String tenLoai;
  int gia;

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
    idHoaDon: json["IDHoaDon"],
    maSoPhieu: json["MaSoPhieu"],
    ngayTao: json["NgayTao"],
    ngayThu: json["NgayThu"] == null ? "Chưa thu" : json["NgayThu"],
    tenKyThu: json["TenKyThu"],
    thang: json["Thang"],
    idAccount: json["IDAccount"],
    maKH: json["MaKhachHang"],
    hoTenKH: json["HoTenKH"],
    diaChiKH: json["DiaChiKH"],
    tenLoai: json["TenLoai"],
    gia: json["Gia"],
  );

  Map<String, dynamic> toJson() => {
    "IDHoaDon": idHoaDon,
    "MaSoPhieu": maSoPhieu,
    "NgayTao" : ngayTao,
    "NgayThu": ngayThu == null ? null : ngayThu,
    "TenKyThu": tenKyThu,
    "Thang": thang,
    "IDAccount": idAccount,
    "MaKhachHang": maKH,
    "HoTenKH": hoTenKH,
    "DiaChiKH": diaChiKH,
    "TenLoai": tenLoai,
    "Gia": gia,
  };
}
