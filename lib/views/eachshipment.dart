import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:load/load.dart';
import 'package:timeline_tile/timeline_tile.dart';

class EachShipment extends StatefulWidget {
  final String value;

  const EachShipment({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  _EachShipmentState createState() => _EachShipmentState();
}

goBack(BuildContext context) {
  Navigator.pop(context);
}

class _EachShipmentState extends State<EachShipment> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              bottom: const TabBar(
                tabs: [
                  Text(
                    "Order Details",
                    style: TextStyle(fontSize: 15),
                  ),
                  Text("Tracking", style: TextStyle(fontSize: 15)),
                ],
              ),
              automaticallyImplyLeading: true,
              title: Text(widget.value),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  goBack(context);
                },
              )),
          body: TabBarView(
            children: [
              OrderDetails(data: widget.value),
              Tracking(data: widget.value),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderDetails extends StatefulWidget {
  final String data;
  const OrderDetails({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  var tjsonData;
  var tresponse;
  var vresponse, vjsonData;
  viewAllShipment() async {
    try {
      vresponse = await http.get(Uri.parse(
          'http://reahaan.pythonanywhere.com/getshipment/${widget.data}'));
      vjsonData = jsonDecode(vresponse.body);
      //print(jsonData);
      setState(() {
        vresponse;
        vjsonData;
      });
    } on Exception catch (e) {
      // TODO
      print(e);
    }
  }

  bool scheduled = true;
  bool outforpickup = false;

  bool pickedup = false;
  bool transit = false;
  bool outfordelivery = false;
  bool delivered = false;
  var status;
  TrackOneShipment() async {
    try {
      tresponse = await http.get(Uri.parse(
          'http://reahaan.pythonanywhere.com/trackOneShipment/${widget.data}'));
      tjsonData = jsonDecode(tresponse.body);
      //print(jsonData);

      setState(() {
        tresponse;
        tjsonData;

        scheduled = tjsonData['pickScheduled'];
        outforpickup = tjsonData['outForPickup'];
        pickedup = tjsonData['pickedUp'];
        transit = tjsonData['transit'];
        outfordelivery = tjsonData['outForDelivery'];
        delivered = tjsonData['delivered'];
      });
    } on Exception catch (e) {
      // TODO
      print(e);
    }
  }

  getStatus() {
    if (delivered == true) {
      status = "Delivered";
    } else if (outfordelivery == true) {
      status = "Out For Delivery";
    } else if (transit == true) {
      status = "In Transit";
    } else if (pickedup == true) {
      status = "Picked up";
    } else if (outforpickup == true) {
      status = "Out for Pickup";
    } else {
      status = "Pickup Scheduled";
    }
    return status;
  }

  @override
  void initState() {
    viewAllShipment();
    showLoadingDialog();
    Timer(Duration(seconds: 1), () {
      hideLoadingDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      if (vjsonData != null)
        Expanded(
            child:
                ListView(padding: const EdgeInsets.all(12), children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 10)),
          Container(
              height: 100,
              child: Card(
                  child: ListTile(
                contentPadding: EdgeInsets.all(10),
                onTap: () {},
                title: Text(getStatus()),
                subtitle: Container(
                  child:
                      Text("Estimated delivery ${vjsonData['estimateDate']}"),
                  padding: EdgeInsets.only(top: 15),
                ),
                leading: Icon(
                  Icons.airport_shuttle,
                  size: 40,
                ),
              ))),
          Container(
            height: 400,
            child: Card(
                child: ListTile(
              contentPadding: EdgeInsets.all(10),
              onTap: () {},
              title: Text(
                "Recipient Details",
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
              ),
              subtitle:
                  //Text("Add and check your shiprocket wallet balance."),

                  Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Table(
                    border: TableBorder(
                        horizontalInside: BorderSide(
                            width: 1,
                            color: Colors.white,
                            style: BorderStyle.solid)),
                    // Allows to add a border decoration around your table
                    children: [
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Name'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('${vjsonData["dname"]}'),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Mobile no',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('${vjsonData["dmobile"]}'),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Address'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('${vjsonData["daddress"]}'),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Country',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('${vjsonData["dcountry"]}'),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'City',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('${vjsonData["dcity"]}'),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Pincode',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('${vjsonData["dpincode"]}'),
                        ),
                      ]),
                    ]),
              ),
              leading: Icon(
                Icons.person,
                size: 30,
              ),
              //trailing: Icon(Icons.arrow_forward_ios_outlined)
            )),
          ),
          Container(
            height: 250,
            child: Card(
                child: ListTile(
              contentPadding: EdgeInsets.all(10),
              onTap: () {},
              title: Text(
                "Product Details",
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
              ),
              subtitle:
                  //Text("Add and check your shiprocket wallet balance."),

                  Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Table(
                    border: TableBorder(
                        horizontalInside: BorderSide(
                            width: 1,
                            color: Colors.white,
                            style: BorderStyle.solid)),
                    // Allows to add a border decoration around your table
                    children: [
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Product Name'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('${vjsonData["productName"]}'),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Weight',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('${vjsonData["weight"]} kg'),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Dimensions'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                              '${vjsonData["length"]} X ${vjsonData["width"]} X ${vjsonData["height"]}'),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Value'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Rs. ${vjsonData["productValue"]}'),
                        ),
                      ]),
                    ]),
              ),
              leading: Icon(
                Icons.assistant,
                size: 30,
              ),
              //trailing: Icon(Icons.add_box_outlined)
            )),
          ),
          Container(
            height: 300,
            child: Card(
                child: ListTile(
              contentPadding: EdgeInsets.all(10),
              onTap: () {},
              title: Text(
                "Shipments Details",
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
              ),
              subtitle:
                  //Text("Add and check your shiprocket wallet balance."),

                  Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Table(
                    border: TableBorder(
                        horizontalInside: BorderSide(
                            width: 1,
                            color: Colors.white,
                            style: BorderStyle.solid)),
                    // Allows to add a border decoration around your table
                    children: [
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text('Pickup Location'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                              '${vjsonData["paddress"]}, ${vjsonData["pcity"]}, ${vjsonData["pstate"]}, ${vjsonData["pcountry"]}'),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            'Order Created At',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text('${vjsonData["created"]}'),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text('Shipping charges'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text('Rs. ${vjsonData["shippingPrice"]}'),
                        ),
                      ]),
                    ]),
              ),
              leading: Icon(
                Icons.approval,
                size: 30,
              ),
              //trailing: Icon(Icons.add_box_outlined)
            )),
          ),
          new Container(
            child: ElevatedButton(
              child: Text("Cancel Shipment"),
              onPressed: () {},
            ),
          ),
        ])),
    ]));
  }
}

class Tracking extends StatefulWidget {
  final String data;
  const Tracking({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _TrackingState createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  var jsonData;
  var response;
  bool scheduled = true;
  bool outforpickup = false;
  bool pickedup = false;
  bool transit = false;
  bool outfordelivery = false;
  bool delivered = false;

  var vresponse, vjsonData, est;
  viewAllShipment() async {
    try {
      vresponse = await http.get(Uri.parse(
          'http://reahaan.pythonanywhere.com/getshipment/${widget.data}'));
      vjsonData = jsonDecode(vresponse.body);
      //print(jsonData);
      setState(() {
        vresponse;
        vjsonData;
        est = vjsonData["estimateDate"];
      });
    } on Exception catch (e) {
      // TODO
      print(e);
    }
  }

  TrackOneShipment() async {
    try {
      response = await http.get(Uri.parse(
          'http://reahaan.pythonanywhere.com/trackOneShipment/${widget.data}'));
      jsonData = jsonDecode(response.body);
      //print(jsonData);

      setState(() {
        response;
        jsonData;
        scheduled = jsonData['pickScheduled'];
        outforpickup = jsonData['outForPickup'];
        pickedup = jsonData['pickedUp'];
        transit = jsonData['transit'];
        outfordelivery = jsonData['outForDelivery'];
        delivered = jsonData['delivered'];
      });
    } on Exception catch (e) {
      // TODO
      print(e);
    }
  }

  @override
  void initState() {
    TrackOneShipment();
    viewAllShipment();
    showLoadingDialog();
    Timer(Duration(seconds: 1), () {
      hideLoadingDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text("Estimated Delivery ${est}"),
              SizedBox(
                height: 20,
              ),
              if (scheduled == true)
                TimelineTile(
                  //alignment: TimelineAlign.center,
                  isFirst: true,
                  indicatorStyle: IndicatorStyle(
                    width: 40,
                    color: Colors.blue,
                    //indicatorXY: ,
                    //padding: const EdgeInsets.all(8),
                    // iconStyle: IconStyle(
                    //   color: Colors.white,
                    //   iconData: Icons.insert_emoticon,
                    // ),
                  ),

                  endChild: Padding(
                    padding: const EdgeInsets.only(right: 15.0, left: 10),
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 90,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.network(
                                "https://i.pinimg.com/originals/fa/8e/de/fa8ede4d6dd48feafa4539dedc3ff6b0.png",
                                width: 70,
                                height: 80,
                                alignment: Alignment.bottomLeft,
                              ),
                              Text(
                                  "\t\t\Pickup scheduled \n\n\t\t We have received your order"),
                            ],
                          )
                        ],
                      ),
                      //color: Colors.amberAccent,
                    ),
                  ),
                ),
              if (outforpickup == true)
                TimelineTile(
                  //alignment: TimelineAlign.center,
                  isFirst: false,
                  indicatorStyle: IndicatorStyle(
                    width: 40,
                    color: Colors.blue,
                    //indicatorXY: ,
                    //padding: const EdgeInsets.all(8),
                    // iconStyle: IconStyle(
                    //   color: Colors.white,
                    //   iconData: Icons.insert_emoticon,
                    // ),
                  ),

                  endChild: Padding(
                    padding: const EdgeInsets.only(right: 15.0, left: 10),
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 100,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.network(
                                "https://buysellgraphic.com/images/graphic_preview/thumb/shipper_conception_painting_delivery_man_icon_cartoon_character_40572.jpg",
                                width: 70,
                                height: 80,
                                alignment: Alignment.bottomLeft,
                              ),
                              Text(
                                  "\t\t\tOut for pickup \n\n \t\tWe are processing your order"),
                            ],
                          )
                        ],
                      ),
                      //color: Colors.amberAccent,
                    ),
                  ),
                ),
              if (pickedup == true)
                TimelineTile(
                  //alignment: TimelineAlign.center,
                  isFirst: false,
                  indicatorStyle: IndicatorStyle(
                    width: 40,
                    color: Colors.blue,
                    //indicatorXY: ,
                    //padding: const EdgeInsets.all(8),
                    // iconStyle: IconStyle(
                    //   color: Colors.white,
                    //   iconData: Icons.insert_emoticon,
                    // ),
                  ),

                  endChild: Padding(
                    padding: const EdgeInsets.only(right: 15.0, left: 10),
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 100,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.network(
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQm3PS1vI0ThKMXPjfYt2w2RHcSnTVRKJzUYg&usqp=CAU",
                                width: 80,
                                height: 80,
                                alignment: Alignment.bottomLeft,
                              ),
                              Text(
                                  "\tOrder Picked \n\n Your order has been Picked"),
                            ],
                          )
                        ],
                      ),
                      //color: Colors.amberAccent,
                    ),
                  ),
                ),
              if (transit == true)
                TimelineTile(
                  //alignment: TimelineAlign.center,
                  isFirst: false,
                  indicatorStyle: IndicatorStyle(
                    width: 40,
                    color: Colors.blue,
                    //indicatorXY: ,
                    //padding: const EdgeInsets.all(8),
                    // iconStyle: IconStyle(
                    //   color: Colors.white,
                    //   iconData: Icons.insert_emoticon,
                    // ),
                  ),

                  endChild: Padding(
                    padding: const EdgeInsets.only(right: 15.0, left: 10),
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 100,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.network(
                                "https://cdn.iconscout.com/icon/premium/png-256-thumb/delivery-bus-3796388-3166912.png",
                                width: 80,
                                height: 80,
                                alignment: Alignment.bottomLeft,
                              ),
                              Text(
                                  "\tOrder In Transit \n\n Your order is on the way"),
                            ],
                          )
                        ],
                      ),
                      //color: Colors.amberAccent,
                    ),
                  ),
                ),
              if (outfordelivery == true)
                TimelineTile(
                  //alignment: TimelineAlign.center,
                  isFirst: false,
                  indicatorStyle: IndicatorStyle(
                    width: 40,
                    color: Colors.blue,
                    //indicatorXY: ,
                    //padding: const EdgeInsets.all(8),
                    // iconStyle: IconStyle(
                    //   color: Colors.white,
                    //   iconData: Icons.insert_emoticon,
                    // ),
                  ),

                  endChild: Padding(
                    padding: const EdgeInsets.only(right: 15.0, left: 10),
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 100,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.network(
                                "https://cdn-icons-png.flaticon.com/128/2331/2331708.png",
                                width: 80,
                                height: 80,
                                alignment: Alignment.bottomLeft,
                              ),
                              Text(
                                  "\t\tOrder out for Delivery\n\n\tYour order will be delivered soon"),
                            ],
                          )
                        ],
                      ),
                      //color: Colors.amberAccent,
                    ),
                  ),
                ),
              if (delivered == true)
                TimelineTile(
                  //alignment: TimelineAlign.center,
                  isLast: true,
                  indicatorStyle: IndicatorStyle(
                    width: 40,
                    color: Colors.blue,
                    //indicatorXY: ,
                    //padding: const EdgeInsets.all(8),
                    // iconStyle: IconStyle(
                    //   color: Colors.white,
                    //   iconData: Icons.insert_emoticon,
                    // ),
                  ),

                  endChild: Padding(
                    padding: const EdgeInsets.only(right: 15.0, left: 10),
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 100,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.network(
                                "https://cdn.iconscout.com/icon/premium/png-256-thumb/gift-giving-3682561-3065326.png",
                                width: 70,
                                height: 80,
                                alignment: Alignment.bottomLeft,
                              ),
                              Text(
                                  "\tOrder Delivered \n\n Your order has been Delivered"),
                            ],
                          )
                        ],
                      ),
                      //color: Colors.amberAccent,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ));
  }
}
