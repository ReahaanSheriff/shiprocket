import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:load/load.dart';
import 'package:shipping/views/update.dart';
import 'package:shipping/views/viewshipments.dart';
import 'package:timeline_tile/timeline_tile.dart';

class EachShipment extends StatefulWidget {
  final String value;
  final String token;

  const EachShipment({
    Key? key,
    required this.value,
    required this.token,
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
              OrderDetails(data: widget.value, token: widget.token),
              Tracking(data: widget.value, token: widget.token),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderDetails extends StatefulWidget {
  final String data;
  final String token;
  const OrderDetails({Key? key, required this.data, required this.token})
      : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  var tjsonData;
  var tresponse;
  var vresponse, vjsonData;

  viewOneShipment() async {
    final uri = Uri.parse(
        'http://reahaan.pythonanywhere.com/getshipment/${widget.data}');

    final headers = {'Authorization': 'Token ' + widget.token.toString()};
    try {
      vresponse = await http.get(
        uri,
        headers: headers,
      );
      //statusCode = vresponse.statusCode;
      vjsonData = jsonDecode(vresponse.body);

      print(vjsonData);
      setState(() {
        vresponse;
        vjsonData;
      });
      //print(statusCode);
    } on Exception catch (e) {
      print("error on login function");
    }
  }

  bool scheduled = true;
  bool outforpickup = false;
  bool cancelled = false;
  bool pickedup = false;
  bool transit = false;
  bool outfordelivery = false;
  bool delivered = false;
  var status;

  updateCancelTracking() async {
    final uri = Uri.parse(
        'http://reahaan.pythonanywhere.com/updateTracking/${widget.data}');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token ' + widget.token.toString()
    };
    Map<String, dynamic> body = {
      "shipment": widget.data.toString(),
      "cancelled": "true",
    };
    String jsonBody = json.encode(body);
    var response;

    String responseBody;
    try {
      response = await http.put(
        uri,
        headers: headers,
        body: jsonBody,
      );

      responseBody = response.body;

      print(responseBody);

      //print(statusCode);
    } on Exception catch (e) {
      print("error on cancel function");
    }
  }

  updateCancelDetails() async {
    final uri = Uri.parse(
        'http://reahaan.pythonanywhere.com/updateShipment/${widget.data}');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token ' + widget.token.toString()
    };
    Map<String, dynamic> body = {
      "shipment": widget.data.toString(),
      "cancelled": "true",
    };
    String jsonBody = json.encode(body);
    var response;

    String responseBody;
    try {
      response = await http.put(
        uri,
        headers: headers,
        body: jsonBody,
      );

      responseBody = response.body;

      print(responseBody);

      //print(statusCode);
    } on Exception catch (e) {
      print("error on cancel function");
    }
  }

  trackOneShipment() async {
    final uri = Uri.parse(
        'http://reahaan.pythonanywhere.com/trackOneShipment/${widget.data}');

    final headers = {'Authorization': 'Token ' + widget.token.toString()};
    try {
      tresponse = await http.get(
        uri,
        headers: headers,
      );
      //statusCode = response.statusCode;
      tjsonData = jsonDecode(tresponse.body);
      print("This is tracking");
      print(tjsonData);
      print(tjsonData['outForPickup']);
      setState(() {
        tresponse;
        tjsonData;
        scheduled = tjsonData['pickScheduled'];
        cancelled = tjsonData['cancelled'];
        outforpickup = tjsonData['outForPickup'];
        pickedup = tjsonData['pickedUp'];
        transit = tjsonData['transit'];
        outfordelivery = tjsonData['outForDelivery'];
        delivered = tjsonData['delivered'];
      });
      print(outforpickup);
      //print(statusCode);
    } on Exception catch (e) {
      print("error on login function");
    }
  }

  getStatus() {
    if (cancelled == true) {
      status = "Cancelled";
    } else if (delivered == true) {
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
    trackOneShipment();
    viewOneShipment();

    showLoadingDialog();
    Timer(Duration(seconds: 1), () {
      hideLoadingDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      if (vjsonData == null)
        Center(
          child: Image.network(
              "https://img.freepik.com/free-vector/no-data-illustration-concept_108061-573.jpg?size=338&ext=jpg"),
        ),
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
                              '${vjsonData["pname"]},\n${vjsonData["pmobile"]}\n${vjsonData["paddress"]}, ${vjsonData["pcity"]}, ${vjsonData["pstate"]}, ${vjsonData["pcountry"]}'),
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
          if (cancelled == false && outforpickup == false)
            new Container(
              child: ElevatedButton(
                child: Text("Update Shipment"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateShipment(
                              token: widget.token, data: widget.data)));
                },
              ),
            ),
          if (cancelled == false && outforpickup == false)
            new Container(
              child: ElevatedButton(
                child: Text("Cancel Shipment"),
                onPressed: () {
                  updateCancelTracking().then((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ViewShipments(value: widget.token)),
                    );
                  });
                },
              ),
            ),
        ])),
    ]));
  }
}

class Tracking extends StatefulWidget {
  final String data;
  final String token;
  const Tracking({
    Key? key,
    required this.data,
    required this.token,
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
  bool cancelled = false;

  var vresponse, vjsonData, est;
  viewOneShipment() async {
    final uri = Uri.parse(
        'http://reahaan.pythonanywhere.com/getshipment/${widget.data}');

    final headers = {'Authorization': 'Token ' + widget.token.toString()};
    try {
      vresponse = await http.get(
        uri,
        headers: headers,
      );
      //statusCode = response.statusCode;
      vjsonData = jsonDecode(vresponse.body);

      print(vjsonData);
      setState(() {
        vresponse;
        vjsonData;
        est = vjsonData["estimateDate"];
      });
      //print(statusCode);
    } on Exception catch (e) {
      print(e);
    }
  }

  trackOneShipment() async {
    final uri = Uri.parse(
        'http://reahaan.pythonanywhere.com/trackOneShipment/${widget.data}');

    final headers = {'Authorization': 'Token ' + widget.token.toString()};
    try {
      response = await http.get(
        uri,
        headers: headers,
      );
      //statusCode = response.statusCode;
      jsonData = jsonDecode(response.body);

      print(jsonData);
      setState(() {
        response;
        jsonData;
        scheduled = jsonData['pickScheduled'];
        cancelled = jsonData['cancelled'];
        outforpickup = jsonData['outForPickup'];
        pickedup = jsonData['pickedUp'];
        transit = jsonData['transit'];
        outfordelivery = jsonData['outForDelivery'];
        delivered = jsonData['delivered'];
      });
      //print(statusCode);
    } on Exception catch (e) {
      print("error on login function");
    }
  }

  @override
  void initState() {
    trackOneShipment();
    viewOneShipment();
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
              if (est != null) Text("Estimated Delivery ${est}"),
              SizedBox(
                height: 20,
              ),
              if (scheduled == true && est != null)
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
              if (outforpickup == true && cancelled == false)
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
              if (pickedup == true && cancelled == false)
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
              if (transit == true && cancelled == false)
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
              if (outfordelivery == true && cancelled == false)
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
              if (delivered == true && cancelled == false)
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
              if (cancelled == true)
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
                                "https://img.lovepik.com/element/45007/0498.png_860.png",
                                width: 70,
                                height: 80,
                                alignment: Alignment.bottomLeft,
                              ),
                              Text(
                                  "\tOrder Cancelled \n\n Your order has been Cancelled"),
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
