// To parse this JSON data, do
//
//     final userAccount = userAccountFromJson(jsonString);

import 'dart:convert';

List<UserAccount> userAccountFromJson(String str) => List<UserAccount>.from(json.decode(str).map((x) => UserAccount.fromJson(x)));

String userAccountToJson(List<UserAccount> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserAccount {
  UserAccount({
    required this.id,
    required this.email,
    required this.pwd,
  });

  int id;
  String email;
  String pwd;

  factory UserAccount.fromJson(Map<String, dynamic> json) => UserAccount(
    id: json["id"],
    email: json["email"],
    pwd: json["pwd"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "pwd": pwd,
  };
}
