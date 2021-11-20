import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:load/load.dart';
import 'package:shipping/helperfunctions/sharedpref_helper.dart';
import 'package:shipping/services/auth.dart';
import 'package:shipping/views/createshipment.dart';
import 'package:shipping/views/eachshipment.dart';

import 'package:shipping/views/profile.dart';

import 'package:shipping/views/signin.dart';
import 'package:shipping/views/viewshipments.dart';
import 'package:shipping/views/cost.dart';
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
    // TODO: implement initState
    //showLoadingDialog();
    print(widget.value);
    super.initState();

    Timer(Duration(seconds: 1), () {
      hideLoadingDialog();
    });
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  String myName = "", myProfilePic = "", myUserName = "", myEmail = "";
  var search = TextEditingController();
  var statusCode;
  getCurrentUser() async {
    setState(() {
      myName = auth.currentUser!.displayName.toString();
    });
    return await auth.currentUser;
  }

  // getMyInfoFromSharedPreference() async {
  //   myName = await SharedPreferenceHelper().getDisplayName() as String;
  //   //myName = (await SharedPreferenceHelper().getDisplayName())!;
  //   myProfilePic = await SharedPreferenceHelper().getUserProfileUrl() as String;
  //   myUserName = (await SharedPreferenceHelper().getUserName())!;
  //   myEmail = await SharedPreferenceHelper().getUserEmail() as String;
  // }

  @override
  Widget build(BuildContext context) {
    getCurrentUser();
    return Scaffold(
        appBar: AppBar(
          title: Text("Shipping"),
          automaticallyImplyLeading: false,
          // actions: [
          //   InkWell(
          //       onTap: () {
          //         AuthMethods().signOut().then((s) {
          //           Navigator.pushReplacement(context,
          //               MaterialPageRoute(builder: (context) => SignIn()));
          //         });
          //       },
          //       child: Container(
          //           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          //           child: Column(children: [
          //             Row(children: [
          //               Text(myName),
          //               Icon(
          //                 Icons.exit_to_app,
          //                 size: 25,
          //               )
          //             ])
          //           ])))
          // ],
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EachShipment(
                                  token: widget.value.toString(),
                                  value: search.text.toString())),
                        );
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Tracking ID',
                        //hintText: 'Enter Name Here',
                      ),
                      autofocus: false,
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                                hideLoadingDialog();
                              });
                            },
                            title: Text("Create New Shipment"),
                            subtitle:
                                Text("Add a new shipment in just a few steps"),
                            leading: Icon(
                              Icons.add_business_rounded,
                              size: 40,
                            ),
                            trailing: Icon(Icons.arrow_forward_ios_outlined))),
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
                            trailing: Icon(Icons.arrow_forward_ios_outlined))),
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
                                MaterialPageRoute(builder: (context) => Cost()),
                              );
                            },
                            title: Text("Calculate Price"),
                            subtitle:
                                Text("Calculate price for your shipment."),
                            leading: Icon(
                              Icons.account_balance_wallet,
                              size: 40,
                            ),
                            trailing: Icon(Icons.arrow_forward_ios_outlined))),
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
                                        Profile(value: widget.value)),
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
                            title: Text("Profile"),
                            subtitle: Text("Manage your shiprocket account."),
                            leading: Icon(
                              Icons.account_box_rounded,
                              size: 40,
                            ),
                            trailing: Icon(Icons.arrow_forward_ios_outlined))),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
