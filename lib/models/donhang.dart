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
  });

  int idDonHang;
  String maDonHang;
  String tenKhachHang;
  String diaChiKh;
  String soDienThoaiKh;
  String ngayTao;
  String ngayHen;
  String buoiHen;
  String ngayThu;
  String tinhTrangXuLy;
  String note;
  int tongTienDh;

  factory DonHang.fromJson(Map<String, dynamic> json) => DonHang(
    idDonHang: json["IDDonHang"],
    maDonHang: json["MaDonHang"],
    tenKhachHang: json["TenKhachHang"],
    diaChiKh: json["DiaChiKH"],
    soDienThoaiKh: json["SoDienThoaiKH"],
    ngayTao: json["NgayTao"],
    ngayHen: json["NgayHen"] == null ? "Đơn hàng chưa xử lý" : json["NgayHen"],
    buoiHen: json["BuoiHen"] == null ? "Đơn hàng chưa xử lý" : json["BuoiHen"],
    ngayThu: json["NgayThu"] == null ? "Chưa thu" : json["NgayThu"],
    tinhTrangXuLy: json["TinhTrangXuLy"],
    note: json["Note"],
    tongTienDh: json["TongTienDH"],
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
  };
}
