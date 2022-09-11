// To parse this JSON data, do
//
//     final account = accountFromJson(jsonString);

import 'dart:convert';

List<Account> accountFromJson(String str) => List<Account>.from(json.decode(str).map((x) => Account.fromJson(x)));

String accountToJson(List<Account> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Account {
  Account({
    required this.idAccount,
    required this.username,
    required this.password,
    required this.hoTen,
    required this.diaChi,
    required this.sdt,
    required this.pictureLink,
  });

  int idAccount;
  String username;
  String password;
  String hoTen;
  String diaChi;
  String sdt;
  String pictureLink;

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    idAccount: json["IDAccount"],
    username: json["username"],
    password: json["password"],
    hoTen: json["HoTenAccount"] ?? '',
    diaChi: json["DiaChiAccount"] ?? '',
    sdt: json["SDT"],
    pictureLink: json["pictureLink"],
  );

  Map<String, dynamic> toJson() => {
    "IDAccount": idAccount,
    "username": username,
    "password": password,
    "HoTenAccount": hoTen,
    "DiaChiAccount": diaChi,
    "SDT": sdt,
    "pictureLink": pictureLink,
  };
}
