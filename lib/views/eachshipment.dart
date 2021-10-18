import 'package:flutter/material.dart';

class EachShipment extends StatefulWidget {
  const EachShipment({Key? key}) : super(key: key);

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
              title: const Text('Order Id' + '123456789'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  goBack(context);
                },
              )),
          body: const TabBarView(
            children: [
              OrderDetails(),
              Tracking(),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderDetails extends StatefulWidget {
  const OrderDetails({Key? key}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Expanded(
          child: ListView(padding: const EdgeInsets.all(12), children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 10)),
        Container(
            height: 100,
            child: Card(
                child: ListTile(
              contentPadding: EdgeInsets.all(10),
              onTap: () {},
              title: Text("Dispatched - In Transit"),
              subtitle: Container(
                child: Text("Estimated delivery 1/11/21"),
                padding: EdgeInsets.only(top: 15),
              ),
              leading: Icon(
                Icons.airport_shuttle,
                size: 40,
              ),
            ))),
        Container(
          height: 300,
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
                        child: Text('Reahaan Sheriff'),
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
                        child: Text('9999999999'),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('Address'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('Java5897875687jk75thg5t478fgui7'),
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
                        child: Text('India'),
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
                        child: Text('Chennai'),
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
                        child: Text('600011'),
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
                        child: Text('Books'),
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
                        child: Text('0.500 kg'),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('Dimensions'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('22 X 20 X 3'),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('Value'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('Rs. 500'),
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
          height: 250,
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
                            'qwe1223123847r93yrfjceu4rgvt345c45r4c5hg5v6trt'),
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
                        child: Text('20/10/21 10.00 am'),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text('Shipping charges'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text('Rs. 35'),
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
      ])),
    ]));
  }
}

class Tracking extends StatefulWidget {
  const Tracking({Key? key}) : super(key: key);

  @override
  _TrackingState createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Tracking"),
    );
  }
}
