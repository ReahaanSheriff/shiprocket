import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void data() {
    var lat1 = 12.97999;
    var lng1 = 80.126018;
    var lat2 = 13.002586;
    var lng2 = 80.189364;
    var result;
    result = 6371 *
        acos(cos(radians(lat1)) *
                cos(radians(lat2)) *
                cos(radians(lng1) - radians(lng2)) +
            sin(radians(lat1)) * sin(radians(lat2)));
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Container(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Card(
              child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 150.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(10),
                onTap: () {
                  data();
                },
                title: Text("Name"),
                subtitle: Text("Email"),
                // leading: Icon(
                //   Icons.add_business_rounded,
                //   size: 40,
                // ),
                // trailing: Icon(Icons.arrow_forward_ios_outlined)
              ),
            ),
          )),
        ),
      ),
    );
  }
}
