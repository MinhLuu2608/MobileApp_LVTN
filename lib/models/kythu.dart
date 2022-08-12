// To parse this JSON data, do
//
//     final kyThu = kyThuFromJson(jsonString);

import 'dart:convert';

List<KyThu> kyThuFromJson(String str) => List<KyThu>.from(json.decode(str).map((x) => KyThu.fromJson(x)));

String kyThuToJson(List<KyThu> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class KyThu {
  KyThu({
    required this.idKyThu,
    this.tenKyThu,
    required this.thang,
    required this.nam,
    required this.ngayTao,
  });

  int idKyThu;
  String? tenKyThu;
  int thang;
  int nam;
  DateTime ngayTao;

  factory KyThu.fromJson(Map<String, dynamic> json) => KyThu(
    idKyThu: json["IDKyThu"],
    tenKyThu: json["TenKyThu"],
    thang: json["Thang"],
    nam: json["Nam"],
    ngayTao: DateTime.parse(json["NgayTao"]),
  );

  Map<String, dynamic> toJson() => {
    "IDKyThu": idKyThu,
    "TenKyThu": tenKyThu,
    "Thang": thang,
    "Nam": nam,
    "NgayTao": ngayTao.toIso8601String(),
  };
}
