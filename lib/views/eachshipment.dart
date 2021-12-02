import 'dart:async';

import 'package:flutter/services.dart';
import 'package:Swift/views/label.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:convert';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:load/load.dart';
import 'package:Swift/views/update.dart';
import 'package:Swift/views/viewshipments.dart';
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
  bool undelivered = false;
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
        undelivered = tjsonData['undelivered'];
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
    } else if (undelivered == true) {
      status = "UnDelivered";
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

  Future<void> _createPDF() async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();
    PdfGraphicsState state = page.graphics.save();
    page.graphics.drawImage(PdfBitmap(await _readImageData('delivery.jpg')),
        Rect.fromLTWH(100, 300, 300, 300));

    page.graphics.drawLine(
        PdfPen(PdfColor(0, 0, 0), width: 1), Offset(5, 200), Offset(500, 200));

    PdfBorders border = PdfBorders(
        left: PdfPen(PdfColor(255, 255, 255), width: 1),
        top: PdfPen(PdfColor(255, 255, 255), width: 1),
        bottom: PdfPen(PdfColor(255, 255, 255), width: 1),
        right: PdfPen(PdfColor(255, 255, 255), width: 1));

    PdfGridCellStyle lcellStyle = PdfGridCellStyle(
      borders: border,
      cellPadding: PdfPaddings(left: 20, right: 0, top: 0, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 12),
    );

    PdfGridCellStyle rcellStyle = PdfGridCellStyle(
      borders: border,
      cellPadding: PdfPaddings(left: 60, right: 150, top: 0, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 12),
    );

    PdfGridCellStyle lheadStyle = PdfGridCellStyle(
      borders: border,
      cellPadding: PdfPaddings(left: 20, right: 0, top: 0, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 15),
    );

    PdfGridCellStyle rheadStyle = PdfGridCellStyle(
      borders: border,
      cellPadding: PdfPaddings(left: 60, right: 150, top: 0, bottom: 0),
      font: PdfStandardFont(PdfFontFamily.helvetica, 15),
    );

//Create a grid style
    PdfGridStyle gridStyle = PdfGridStyle(
      font: PdfStandardFont(PdfFontFamily.helvetica, 12),
    );

    PdfGrid grid = PdfGrid();
    grid.rows.applyStyle(gridStyle);

    grid.columns.add(count: 2);
    grid.headers.add(1);
    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Pickup location';
    header.cells[1].value = 'Drop Location';

    PdfGridRow row4 = grid.rows.add();
    row4.cells[0].value = '';
    row4.cells[1].value = '';

    PdfGridRow row1 = grid.rows.add();
    row1.cells[0].value = '${vjsonData['pname']}';
    row1.cells[1].value = '${vjsonData['dname']}';

    PdfGridRow row2 = grid.rows.add();
    row2.cells[0].value = '${vjsonData['paddress']}';
    row2.cells[1].value = '${vjsonData['daddress']}';

    PdfGridRow row3 = grid.rows.add();
    row3.cells[0].value = '${vjsonData['pcity']}\t${vjsonData['ppincode']}';
    row3.cells[1].value = '${vjsonData['dcity']}\t${vjsonData['dpincode']}';

    PdfGridRow row5 = grid.rows.add();
    row5.cells[0].value = '${vjsonData['pstate']}\t${vjsonData['pcountry']}';
    row5.cells[1].value = '${vjsonData['dstate']}\t${vjsonData['dcountry']}';

    PdfGridRow row6 = grid.rows.add();
    row6.cells[0].value = 'Mobile: ${vjsonData['pmobile']}';
    row6.cells[1].value = 'Mobile: ${vjsonData['dmobile']}';

    header.cells[0].style = lheadStyle;
    header.cells[1].style = rheadStyle;
    row1.cells[0].style = lcellStyle;
    row1.cells[1].style = rcellStyle;
    row2.cells[0].style = lcellStyle;
    row2.cells[1].style = rcellStyle;
    row3.cells[0].style = lcellStyle;
    row3.cells[1].style = rcellStyle;
    row4.cells[0].style = lcellStyle;
    row4.cells[1].style = rcellStyle;
    row5.cells[0].style = lcellStyle;
    row5.cells[1].style = rcellStyle;
    row6.cells[0].style = lcellStyle;
    row6.cells[1].style = rcellStyle;

    // grid.draw(page: page, bounds: const Rect.fromLTWH(0, 25, 0, 0));
    grid.draw(page: page, bounds: const Rect.fromLTWH(20, 35, 400, 300));

    page.graphics.drawString('\t\t\t\t\t\t\t\tORDER ID: ${widget.data} \n\n',
        PdfStandardFont(PdfFontFamily.helvetica, 18),
        bounds: const Rect.fromLTWH(0, 0, 0, 0));

    page.graphics.drawString('SHIPMENT WEIGHT: ${vjsonData['weight']}',
        PdfStandardFont(PdfFontFamily.helvetica, 15),
        bounds: const Rect.fromLTWH(20, 220, 400, 300));

    page.graphics.drawString(
        'DIMENSIONS: ${vjsonData['length']} X ${vjsonData['width']} X ${vjsonData['height']}',
        PdfStandardFont(PdfFontFamily.helvetica, 15),
        bounds: const Rect.fromLTWH(20, 250, 400, 300));

    page.graphics.drawString('Product Name: ${vjsonData['productName']}',
        PdfStandardFont(PdfFontFamily.helvetica, 15),
        bounds: const Rect.fromLTWH(320, 220, 400, 300));

    page.graphics.drawString('Product Value: Rs. ${vjsonData['productValue']}',
        PdfStandardFont(PdfFontFamily.helvetica, 15),
        bounds: const Rect.fromLTWH(320, 250, 400, 300));

    page.graphics.drawString(
        'TERMS AND CONDITIONS', PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: const Rect.fromLTWH(20, 650, 0, 0));
    PdfGraphics graphics = page.graphics;
    graphics.drawRectangle(
        pen: PdfPen(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(
            0, 0, page.getClientSize().width, page.getClientSize().height));
    page.graphics.drawString(
        "1.If delivery executive couldn't reach the destination after 3 attempts it will be returned to the pickup destination\n2.Illegal items should not be shipped, If found any suspicious item then llegal action will be taken",
        PdfStandardFont(PdfFontFamily.helvetica, 10),
        bounds: const Rect.fromLTWH(20, 680, 0, 0));

    page.graphics.drawString(
        'This is an auto generated label and does not required signature',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: const Rect.fromLTWH(20, 730, 0, 0));
    page.graphics.restore(state);
    List<int> bytes = document.save();
    document.dispose();

    saveAndLaunchFile(bytes, 'Label_${widget.data}.pdf');
  }

  Future<Uint8List> _readImageData(String name) async {
    final data = await rootBundle.load('images/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
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
          Text("Download and paste the label on your shipment"),
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
                          child: Text('Swift charges'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text('Rs. ${vjsonData["SwiftPrice"]}'),
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
              child: Text("View Label"),
              onPressed: () {
                _createPDF();
              },
            ),
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
  bool undelivered = false;

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
        undelivered = jsonData['undelivered'];
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
              if (undelivered == true)
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
                                  "\tOrder Undelivered \n\nAfter 3 attempts your order\n cannot be delivered"),
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
