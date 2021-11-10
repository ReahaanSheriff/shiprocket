import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:load/load.dart';
import 'package:shipping/views/eachshipment.dart';
import 'package:http/http.dart' as http;

class ViewShipments extends StatefulWidget {
  const ViewShipments({Key? key}) : super(key: key);

  @override
  _ViewShipmentsState createState() => _ViewShipmentsState();
}

class _ViewShipmentsState extends State<ViewShipments> {
  var orderid;
  var jsonData;
  var response;
  viewAllShipment() async {
    try {
      response =
          await http.get(Uri.parse('http://reahaan.pythonanywhere.com/'));
      jsonData = jsonDecode(response.body);
      // for (var i in jsonData) {
      //   print(i);
      // }
      setState(() {
        response;
        jsonData;
      });
      orderid = jsonData[0]["orderId"];
    } on Exception catch (e) {
      // TODO
      print(e);
    }
  }

  @override
  void initState() {
    viewAllShipment();
    Timer(Duration(seconds: 1), () {
      hideLoadingDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Shipments"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 10)),
                if (jsonData != null)
                  for (var i in jsonData)
                    Container(
                      height: 100,
                      child: Card(
                          child: ListTile(
                              contentPadding: EdgeInsets.all(10),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EachShipment(value: i["orderId"])),
                                );
                              },
                              // ignore: unnecessary_brace_in_string_interps
                              title: Text("Order ID-" + ' ${i["orderId"]}'),
                              subtitle: Container(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(top: 40)),
                                        Text("${i['created']}"
                                                .substring(8, 10) +
                                            "${i['created']}".substring(4, 8) +
                                            "${i['created']}".substring(0, 4)),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                right: 15, top: 10)),
                                        Text("Rs. ${i['productValue']}"),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                right: 15, top: 10)),
                                        Text("pin ${i['dpincode']}")
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              leading: Icon(
                                Icons.assignment_rounded,
                                size: 40,
                              ),
                              trailing:
                                  Icon(Icons.arrow_forward_ios_outlined))),
                    ),
                Padding(padding: EdgeInsets.only(top: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
