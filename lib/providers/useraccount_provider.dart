import 'package:flutter/material.dart';
import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/models/useraccount.dart';
import 'package:http/http.dart' as http;

final urlAPI = url;

class UserAccount_provider with ChangeNotifier{
  List<UserAccount> userAccount = [];

  UserAccount_provider(){
    getUserAccount();
  }

  getUserAccount() async{
    final url = Uri.http(urlAPI, 'apiTest/UserAccount');
    final resp = await http.get(url, headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "Content-type": "application/json",
      "Accept": "application/json"
    });
    final response = userAccountFromJson(resp.body);
    userAccount = response;
    notifyListeners();
  }
}