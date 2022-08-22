// To parse this JSON data, do
//
//     final empInvoice = empInvoiceFromJson(jsonString);

import 'dart:convert';

List<EmpInvoice> empInvoiceFromJson(String str) => List<EmpInvoice>.from(json.decode(str).map((x) => EmpInvoice.fromJson(x)));

String empInvoiceToJson(List<EmpInvoice> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EmpInvoice {
  EmpInvoice({
    required this.idHoaDon,
    required this.maSoPhieu,
    required this.ngayTao,
    required this.ngayThu,
    required this.tenKyThu,
    required this.thang,
    required this.idTuyenThu,
    required this.tenTuyenThu,
    required this.idNhanVien,
    required this.hoTen,
    required this.soDienThoai,
    required this.maKhachHang,
    required this.hoTenKH,
    required this.gia,
    required this.tenLoai,
    required this.diaChiKH,
  });

  int idHoaDon;
  String maSoPhieu;
  String ngayTao;
  String ngayThu;
  String tenKyThu;
  int thang;
  int idTuyenThu;
  String tenTuyenThu;
  int idNhanVien;
  String hoTen;
  String soDienThoai;
  String maKhachHang;
  String hoTenKH;
  int gia;
  String tenLoai;
  String diaChiKH;

  factory EmpInvoice.fromJson(Map<String, dynamic> json) => EmpInvoice(
    idHoaDon: json["IDHoaDon"],
    maSoPhieu: json["MaSoPhieu"],
    ngayTao: json["NgayTao"],
    ngayThu: json["NgayThu"] == null ? "Chưa thu" : json["NgayThu"],
    tenKyThu: json["TenKyThu"],
    thang: json["Thang"],
    idTuyenThu: json["IDTuyenThu"],
    tenTuyenThu: json["TenTuyenThu"],
    idNhanVien: json["IDNhanVien"],
    hoTen: json["HoTen"],
    soDienThoai: json["SoDienThoai"],
    maKhachHang: json["MaKhachHang"],
    hoTenKH: json["HoTenKH"],
    gia: json["Gia"],
    tenLoai: json["TenLoai"],
    diaChiKH: json["DiaChiKH"],
  );

  Map<String, dynamic> toJson() => {
    "IDHoaDon": idHoaDon,
    "MaSoPhieu": maSoPhieu,
    "NgayTao": ngayTao,
    "NgayThu": ngayThu == null ? null : ngayThu,
    "TenKyThu": tenKyThu,
    "Thang": thang,
    "IDTuyenThu": idTuyenThu,
    "TenTuyenThu": tenTuyenThu,
    "IDNhanVien": idNhanVien,
    "HoTen": hoTen,
    "SoDienThoai": soDienThoai,
    "MaKhachHang": maKhachHang,
    "HoTenKH": hoTenKH,
    "Gia": gia,
    "TenLoai": tenLoai,
    "DiaChiKH": diaChiKH,
  };
}
