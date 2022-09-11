// To parse this JSON data, do
//
//     final donHang = donHangFromJson(jsonString);

import 'dart:convert';

List<DonHang> donHangFromJson(String str) => List<DonHang>.from(json.decode(str).map((x) => DonHang.fromJson(x)));

String donHangToJson(List<DonHang> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DonHang {
  DonHang({
    required this.idDonHang,
    required this.maDonHang,
    required this.tenKhachHang,
    required this.diaChiKh,
    required this.soDienThoaiKh,
    required this.ngayTao,
    required this.ngayHen,
    required this.buoiHen,
    required this.ngayThu,
    required this.tinhTrangXuLy,
    required this.note,
    required this.tongTienDh,
    this.maNhanVien,
    this.hoTen,
    this.soDienThoai,
  });

  int idDonHang;
  String maDonHang;
  String tenKhachHang;
  String diaChiKh;
  String soDienThoaiKh;
  String ngayTao;
  dynamic ngayHen;
  String buoiHen;
  dynamic ngayThu;
  String tinhTrangXuLy;
  String note;
  int tongTienDh;
  dynamic maNhanVien;
  dynamic hoTen;
  dynamic soDienThoai;

  factory DonHang.fromJson(Map<String, dynamic> json) => DonHang(
    idDonHang: json["IDDonHang"],
    maDonHang: json["MaDonHang"],
    tenKhachHang: json["TenKhachHang"],
    diaChiKh: json["DiaChiKH"],
    soDienThoaiKh: json["SoDienThoaiKH"],
    ngayTao: json["NgayTao"],
    ngayHen: json["NgayHen"] ?? "Đơn hàng chưa xử lý",
    buoiHen: json["BuoiHen"] ?? "Đơn hàng chưa xử lý",
    ngayThu: json["NgayThu"] ?? "Chưa thu",
    tinhTrangXuLy: json["TinhTrangXuLy"],
    note: json["Note"],
    tongTienDh: json["TongTienDH"],
    maNhanVien: json["MaNhanVien"],
    hoTen: json["HoTen"],
    soDienThoai: json["SoDienThoai"],
  );

  Map<String, dynamic> toJson() => {
    "IDDonHang": idDonHang,
    "MaDonHang": maDonHang,
    "TenKhachHang": tenKhachHang,
    "DiaChiKH": diaChiKh,
    "SoDienThoaiKH": soDienThoaiKh,
    "NgayTao": ngayTao,
    "NgayHen": ngayHen,
    "BuoiHen": buoiHen,
    "NgayThu": ngayThu,
    "TinhTrangXuLy": tinhTrangXuLy,
    "Note": note,
    "TongTienDH": tongTienDh,
    "MaNhanVien": maNhanVien,
    "HoTen": hoTen,
    "SoDienThoai": soDienThoai,
  };
}
