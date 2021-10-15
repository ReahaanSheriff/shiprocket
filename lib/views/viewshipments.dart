import 'package:flutter/material.dart';
import 'package:shipping/views/eachshipment.dart';

class ViewShipments extends StatefulWidget {
  const ViewShipments({Key? key}) : super(key: key);

  @override
  _ViewShipmentsState createState() => _ViewShipmentsState();
}

class _ViewShipmentsState extends State<ViewShipments> {
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
                Container(
                  height: 100,
                  child: Card(
                      child: ListTile(
                          contentPadding: EdgeInsets.all(10),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EachShipment()),
                            );
                          },
                          title: Text("Order ID" + " 12345677890"),
                          subtitle: Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(padding: EdgeInsets.only(top: 40)),
                                    Text("10/10/21"),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            right: 15, top: 10)),
                                    Text("Rs. 500"),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            right: 15, top: 10)),
                                    Text("Dispatched")
                                  ],
                                ),
                              ],
                            ),
                          ),
                          leading: Icon(
                            Icons.assignment_rounded,
                            size: 40,
                          ),
                          trailing: Icon(Icons.arrow_forward_ios_outlined))),
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
