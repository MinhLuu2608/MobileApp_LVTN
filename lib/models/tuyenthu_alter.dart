// To parse this JSON data, do
//
//     final tuyenThu = tuyenThuFromJson(jsonString);

import 'dart:convert';

List<TuyenThu> tuyenThu1FromJson(String str) => List<TuyenThu>.from(json.decode(str).map((x) => TuyenThu.fromJson(x)));

String tuyenThuToJson(List<TuyenThu> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TuyenThu {
  TuyenThu({
    required this.idTuyenThu,
    required this.maTuyenThu,
    required this.tenTuyenThu,
    required this.ngayBatDau,
    this.ngayKetThuc,
  });

  int idTuyenThu;
  String maTuyenThu;
  String tenTuyenThu;
  String ngayBatDau;
  dynamic ngayKetThuc;

  factory TuyenThu.fromJson(Map<String, dynamic> json) => TuyenThu(
    idTuyenThu: json["IDTuyenThu"],
    maTuyenThu: json["MaTuyenThu"],
    tenTuyenThu: json["TenTuyenThu"],
    ngayBatDau: json["NgayBatDau"],
    ngayKetThuc: json["NgayKetThuc"] == null ? "Đang hoạt động" : json["NgayThu"],
  );

  Map<String, dynamic> toJson() => {
    "IDTuyenThu": idTuyenThu,
    "MaTuyenThu": maTuyenThu,
    "TenTuyenThu": tenTuyenThu,
    "NgayBatDau": ngayBatDau,
    "NgayKetThuc": ngayKetThuc,
  };
}
