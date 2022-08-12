import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:MobileApp_LVTN/models/comment.dart';

void getCommentsFromAPI() async {
  try {
    final urlAPI = '10.0.2.2:5199';
    final url1 = Uri.http(urlAPI, 'api/kythu');
    print(url1);
    // final response = await httpClient.get(Uri.parse(url));
    final response = await http.get(url1, headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "Content-type": "application/json",
      "Accept": "application/json"
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final responseData = json.decode(response.body) as List;
    }
    else{
      print("Không thể lấy API");
    }
  } catch (exception) {
    print("Vào catch");
    print(exception.toString());
  }
}
