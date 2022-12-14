import 'dart:convert';
import 'package:MobileApp_LVTN/constants.dart';
import 'package:MobileApp_LVTN/models/dichvu.dart';
import 'package:MobileApp_LVTN/screens/customer/service_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final urlAPI = url;
class ServiceListScreen extends StatefulWidget {
  @override
  ServiceListScreenState createState() => ServiceListScreenState();
}

class ServiceListScreenState extends State<ServiceListScreen> {

  static const TextStyle optionMainStyle = TextStyle(fontSize: 16);
  static const TextStyle optionSubStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  static const TextStyle styleContent = TextStyle(fontSize: 20);

  int radioValue = -1;
  var updateState = false;
  final _txtSearch = TextEditingController();

  Future<List<DichVu>> getServices() async {
    if(_txtSearch.text.isEmpty){
      final url = Uri.http(urlAPI, 'api/DichVu/$radioValue/1');
      final resp = await http.get(url, headers: {
        // "Access-Control-Allow-Origin": "*",
        // "Access-Control-Allow-Credentials": "true",
        "Content-type": "application/json",
        // "Accept": "application/json"
      });
      final response = dichVuFromJson(resp.body);
      return response;
    }
    else{
      final url = Uri.http(urlAPI, 'api/DichVu/searchDV');
      var jsonBody = {
        'TenDichVu': _txtSearch.text
      };
      String jsonStr = json.encode(jsonBody);
      final resp = await http.post(url, body: jsonStr, headers: {
        // "Access-Control-Allow-Origin": "*",
        // "Access-Control-Allow-Credentials": "true",
        "Content-type": "application/json",
        // "Accept": "application/json"
      });
      final response = dichVuFromJson(resp.body);
      return response;
    }
  }

  showImage(String image){
    return Image.memory(base64Decode(image));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFilter(context),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildSearchField(),
              FutureBuilder(
                future: getServices(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Text("Something Wrong");
                  }
                  if (snapshot.hasData) {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(10),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(3),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ServiceInfo(
                                      dichVuInfo: snapshot.data[index])));
                            },
                            child: buildDichVu(snapshot, index),
                          ),
                        );
                      },
                    );
                  }
                  return const Text("Error while Calling API");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card buildDichVu(AsyncSnapshot<dynamic> snapshot, int index) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      color: Colors.white70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child:
                      Text(snapshot.data[index].tenDichVu, style: styleContent),
                ), // T??n d???ch v???
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  FloatingActionButton buildFilter(BuildContext context) {
    return FloatingActionButton(
      tooltip: "L???c",
      child: Icon(Icons.filter_alt_rounded),
      onPressed: () {
        int _value = radioValue;
        showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  title: const Center(child: Text("L???c lo???i d???ch v??? theo:")),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // K??? thu
                      RadioListTile(
                        title: const Text("Trong nh??",
                            style: TextStyle(fontSize: 20)),
                        value: 1,
                        groupValue: _value,
                        onChanged: (value) {
                          setState(() {
                            _value = int.parse(value.toString());
                            // print(radioValue);
                          });
                        },
                      ), // Trong nh??
                      RadioListTile(
                        title: const Text("Ngo??i tr???i",
                            style: TextStyle(fontSize: 20)),
                        value: 2,
                        groupValue: _value,
                        onChanged: (value) {
                          setState(() {
                            _value = int.parse(value.toString());
                            // print(radioValue);
                          });
                        },
                      ), // Ngo??i tr???i
                      RadioListTile(
                        title: const Text("T???t c???",
                            style: TextStyle(fontSize: 20)),
                        value: -1,
                        groupValue: _value,
                        onChanged: (value) {
                          setState(() {
                            _value = int.parse(value.toString());
                            // print(radioValue);
                          });
                        },
                      ), // T???t c???
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          radioValue = _value;
                          this.setState(() {
                            updateState = !updateState;
                          });
                        },
                        child: const Text("L???c", style: TextStyle(fontSize: 20))),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Hu??? b???", style: TextStyle(fontSize: 20)))
                  ],
                );
              });
            });
      },
    );
  }

  Row buildSearchField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          width: 350,
          child: TextField(
            controller: _txtSearch,
            decoration: InputDecoration(
              prefixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    updateState = !updateState;
                  });
                },
                icon: const Icon(Icons.search),
              ),
              hintText: 'Nh???p t??n d???ch v??? c???n t??m',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.red)),
            ),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            onChanged: (value) {
              setState(() {
                updateState = !updateState;
              });
            }
          ),
        ),
      ],
    );
  }
}