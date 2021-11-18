// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';

// import 'package:load/load.dart';
// import 'package:shipping/views/eachshipment.dart';
// import 'package:http/http.dart' as http;

// class Search extends StatefulWidget {
//   final String value;
//   final String data;
//   const Search({
//     Key? key,
//     required this.value,
//     required this.data,
//   }) : super(key: key);

//   @override
//   _SearchState createState() => _SearchState();
// }

// class _SearchState extends State<Search> {
//   var orderid;
//   var jsonData;
//   var response;
//   var statusCode;

//   searchShipment() async {
//     final uri = Uri.parse(
//         'http://reahaan.pythonanywhere.com/getshipment/${widget.data}');

//     final headers = {'Authorization': 'Token ' + widget.value.toString()};
//     try {
//       var vresponse = await http.get(
//         uri,
//         headers: headers,
//       );
//       statusCode = vresponse.statusCode;
//       var vjsonData = jsonDecode(vresponse.body);

//       print(vjsonData);
//       setState(() {
//         vresponse;
//         vjsonData;
//       });
//       //print(statusCode);
//     } on Exception catch (e) {
//       print("error on login function");
//     }

//     return statusCode;
//   }

//   @override
//   void initState() {
//     searchShipment();
//     showLoadingDialog();
//     Timer(Duration(seconds: 1), () {
//       hideLoadingDialog();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("View Shipments"),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(12),
//               children: <Widget>[
//                 Padding(padding: EdgeInsets.only(top: 10)),
//                 if (jsonData == null)
//                   Center(child: Text("No shipments"))
//                 else if (jsonData != null)
//                   for (var i in jsonData)
//                     Container(
//                       height: 100,
//                       child: Card(
//                           child: ListTile(
//                               contentPadding: EdgeInsets.all(10),
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => new EachShipment(
//                                           value: i["orderId"],
//                                           token: widget.value)),
//                                 );
//                               },
//                               // ignore: unnecessary_brace_in_string_interps
//                               title: Text("Order ID-" + ' ${i["orderId"]}'),
//                               subtitle: Container(
//                                 child: Column(
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Padding(
//                                             padding: EdgeInsets.only(top: 40)),
//                                         Text("${i['created']}"
//                                                 .substring(8, 10) +
//                                             "${i['created']}".substring(4, 8) +
//                                             "${i['created']}".substring(0, 4)),
//                                         Padding(
//                                             padding: EdgeInsets.only(
//                                                 right: 15, top: 10)),
//                                         Text("Rs. ${i['productValue']}"),
//                                         Padding(
//                                             padding: EdgeInsets.only(
//                                                 right: 15, top: 10)),
//                                         Text("pin ${i['dpincode']}")
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               leading: Icon(
//                                 Icons.assignment_rounded,
//                                 size: 40,
//                               ),
//                               trailing:
//                                   Icon(Icons.arrow_forward_ios_outlined))),
//                     ),
//                 Padding(padding: EdgeInsets.only(top: 10)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
