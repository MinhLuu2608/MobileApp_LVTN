// To parse this JSON data, do
//
//     final tuyenThu = tuyenThuFromJson(jsonString);

import 'dart:convert';

List<TuyenThu> tuyenThuFromJson(String str) => List<TuyenThu>.from(json.decode(str).map((x) => TuyenThu.fromJson(x)));

String tuyenThuToJson(List<TuyenThu> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TuyenThu {
  TuyenThu({
    required this.idTuyenThu,
    required this.tenTuyenThu,
    required this.tenQuanHuyen,
  });

  int idTuyenThu;
  String tenTuyenThu;
  String tenQuanHuyen;

  factory TuyenThu.fromJson(Map<String, dynamic> json) => TuyenThu(
    idTuyenThu: json["IDTuyenThu"],
    tenTuyenThu: json["TenTuyenThu"],
    tenQuanHuyen: json["TenQuanHuyen"],
  );

  Map<String, dynamic> toJson() => {
    "IDTuyenThu": idTuyenThu,
    "TenTuyenThu": tenTuyenThu,
    "TenQuanHuyen": tenQuanHuyen,
  };
}
