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
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
            ],
          ),
        ),
      ),
    );
  }
}
