// import 'package:MobileApp_LVTN/constants.dart';
// import 'package:MobileApp_LVTN/models/invoice.dart';
// import 'package:MobileApp_LVTN/screens/customer/order_info.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
//
//
// final urlAPI = url;
// class ExpansionList extends StatefulWidget {
//   @override
//   _ExpansionListState createState() => _ExpansionListState();
// }
//
// class _ExpansionListState extends State<ExpansionList> {
//   // static const TextStyle optionMainStyle = TextStyle(fontSize: 16);
//   // static const TextStyle optionSubStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
//
//   late Box box1;
//
//   var updateState = false;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     createOpenBox();
//     super.initState();
//   }
//
//   void createOpenBox() async {
//     box1 = await Hive.openBox('logindata');
//   }
//
//   Future<List<Invoice>> getHoaDon() async {
//     box1 = await Hive.openBox('logindata');
//     final int IDAccount = box1.get("IDAccount");
//     final url = Uri.http(urlAPI, 'api/MobileApp/getHoaDon/$IDAccount');
//
//     final resp = await http.get(url, headers: {
//       // "Access-Control-Allow-Origin": "*",
//       // "Access-Control-Allow-Credentials": "true",
//       "Content-type": "application/json",
//       // "Accept": "application/json"
//     });
//     final response = invoiceFromJson(resp.body);
//     return response;
//   }
//
//   Future refresh() async{
//     setState(() {
//       updateState = !updateState;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: getHoaDon(),
//       builder: (BuildContext context, AsyncSnapshot snapshot){
//         if(snapshot.connectionState != ConnectionState.done){
//           return Center(child: CircularProgressIndicator());
//         }
//         if(snapshot.hasError){
//           return Text("Something Wrong");
//         }
//         if(snapshot.hasData){
//           return RefreshIndicator(
//             onRefresh: refresh,
//             child: ListView.builder(
//               shrinkWrap: true,
//               padding: const EdgeInsets.all(10),
//               itemCount: snapshot.data.length,
//               itemBuilder: (BuildContext context, int index){
//                 return Padding(
//                   padding: const EdgeInsets.all(3),
//                   child: InkWell(
//                     onTap: (){
//                       Navigator.of(context).push(
//                           MaterialPageRoute(builder: (context) => InvoiceInfo(invoice: snapshot.data[index])
//                           ));
//                     },
//                     child: Card(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10)
//                       ),
//                       color: Colors.grey[300],
//                       elevation: 10,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Padding(
//                                 padding: const EdgeInsets.all(5.0),
//                                 child: Text(snapshot.data[index].maSoPhieu),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(5.0),
//                                 child: Text(snapshot.data[index].tenKyThu),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(5.0),
//                                 child: Text(snapshot.data[index].hoTenKH),
//                               ),
//                             ],
//                           ),
//                           Expanded(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(10.0),
//                                   child: snapshot.data[index].ngayThu == "Ch??a thu"
//                                       ?
//                                   Text("Ch??a thu", style: TextStyle(color: Colors.pink, fontSize: 20),)
//                                       :
//                                   Text("???? thu", style: TextStyle(color: Colors.lightGreen, fontSize: 20)),
//                                 ),
//
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         }
//
//         return Text("Error while Calling API");
//       },
//     );
//   }
// }
//
