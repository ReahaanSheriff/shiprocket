import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:load/load.dart';

import 'package:swift/views/createshipment.dart';
import 'package:swift/views/eachshipment.dart';

import 'package:swift/views/profile.dart';
import 'package:swift/views/signin.dart';
import 'package:swift/views/support.dart';

import 'package:swift/views/viewshipments.dart';
import 'package:swift/views/cost.dart';
import 'package:vector_math/vector_math.dart' as vec;

class Home extends StatefulWidget {
  final String value;
  const Home({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 1), () {
      hideLoadingDialog();
    });
  }

  String myName = "", myProfilePic = "", myUserName = "", myEmail = "";
  var search = TextEditingController();
  var statusCode;

  @override
  Widget build(BuildContext context) {
    return
        // initialRoute: widget.value == null ? "signin" : "/",
        // routes: {
        //   '/': (context) => Home(value: widget.value),
        //   "signin": (context) => SignIn()
        // },

        Scaffold(
            appBar: AppBar(
              title: Text(
                "Swift",
                style: TextStyle(fontFamily: 'Pacifico'),
              ),
              automaticallyImplyLeading: false,
              actions: [
                InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Profile(
                                  value: widget.value,
                                )),
                      );
                    },
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Column(children: [
                          Row(children: [
                            Icon(
                              Icons.account_circle,
                              size: 25,
                            )
                          ])
                        ])))
              ],
            ),
            body: Column(
              children: [
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 12)),
                    Container(
                        height: 50,
                        width: 300,
                        child: TextField(
                          controller: search,
                          onSubmitted: (String str) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EachShipment(
                                      token: widget.value.toString(),
                                      value: search.text.toString())),
                            );

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => EachShipment(
                            //           token: widget.value.toString(),
                            //           value: search.text.toString())),
                            // );
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Tracking ID',
                            //hintText: 'Enter Name Here',
                          ),
                          autofocus: false,
                        )),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: ElevatedButton(
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 12),
                            child: Icon(Icons.search)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EachShipment(
                                    token: widget.value.toString(),
                                    value: search.text.toString())),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                    child: Image.asset(
                  'images/dashboard.jpg',
                  width: 350,
                  height: 200,
                  fit: BoxFit.cover,
                )),
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
                                  showLoadingDialog();
                                  Timer(Duration(seconds: 1), () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CreateShipment(
                                              value: widget.value.toString())),
                                    );
                                    // Navigator.pushReplacement(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) => CreateShipment(
                                    //           value: widget.value.toString())),
                                    // );
                                    hideLoadingDialog();
                                  });
                                },
                                title: Text("Create New Shipment"),
                                subtitle: Text(
                                    "Add a new shipment in just a few steps"),
                                leading: Icon(
                                  Icons.add_business_rounded,
                                  size: 40,
                                ),
                                trailing:
                                    Icon(Icons.arrow_forward_ios_outlined))),
                      ),
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
                                        builder: (context) =>
                                            ViewShipments(value: widget.value)),
                                  );
                                },
                                title: Text("View Shipments"),
                                subtitle: Text("View shipments by status."),
                                leading: Icon(
                                  Icons.assignment_rounded,
                                  size: 40,
                                ),
                                trailing:
                                    Icon(Icons.arrow_forward_ios_outlined))),
                      ),
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
                                        builder: (context) => Cost()),
                                  );
                                },
                                title: Text("Calculate Price"),
                                subtitle:
                                    Text("Calculate price for your shipment."),
                                leading: Icon(
                                  Icons.account_balance_wallet,
                                  size: 40,
                                ),
                                trailing:
                                    Icon(Icons.arrow_forward_ios_outlined))),
                      ),
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
                                        builder: (context) => Support()),
                                  );
                                },
                                // onTap: () {
                                //   Fluttertoast.showToast(
                                //       msg: "Account Settings",
                                //       toastLength: Toast.LENGTH_SHORT,
                                //       gravity: ToastGravity.CENTER,
                                //       timeInSecForIosWeb: 1,
                                //       backgroundColor: Colors.red,
                                //       textColor: Colors.white,
                                //       fontSize: 16.0);
                                // },
                                title: Text("Support"),
                                subtitle:
                                    Text("Share your shiprocket queries."),
                                leading: Icon(
                                  Icons.mail,
                                  size: 40,
                                ),
                                trailing:
                                    Icon(Icons.arrow_forward_ios_outlined))),
                      )
                    ],
                  ),
                )
              ],
            ));
  }
}
