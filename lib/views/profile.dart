import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:load/load.dart';
import 'package:shipping/services/auth.dart';
import 'package:shipping/views/signin.dart';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  final String value;
  const Profile({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // final FirebaseAuth auth = FirebaseAuth.instance;
  // String myProfilePic = FirebaseAuth.instance.currentUser!.photoURL.toString();
  // String myName = FirebaseAuth.instance.currentUser!.displayName.toString();
  // String myEmail = FirebaseAuth.instance.currentUser!.email.toString();
  // String newName = FirebaseAuth.instance.currentUser!.email
  //     .toString()
  //     .replaceAll("@gmail.com", "");
  var currentuserresponse, responseBody, name, email;
  currentUser() async {
    final uri = Uri.parse('http://reahaan.pythonanywhere.com/currentuser/');
    final headers = {'Authorization': 'Token ' + widget.value.toString()};
//String jsonBody = json.encode(body);
    //final encoding = Encoding.getByName('utf-8');

    try {
      currentuserresponse = await http.get(
        uri,
        headers: headers,
        //body: jsonBody,
        //encoding: encoding,
      );

      responseBody = jsonDecode(currentuserresponse.body);

      setState(() {
        name = responseBody["username"];
        email = responseBody["email"];
      });
      print(responseBody);

      //print(responseBody['id']);
    } on Exception catch (e) {
      print(e);
    }
  }

  signout() async {
    final uri = Uri.parse('http://reahaan.pythonanywhere.com/logout/');
    final headers = {'Authorization': 'Token ' + widget.value.toString()};
//String jsonBody = json.encode(body);
    //final encoding = Encoding.getByName('utf-8');

    try {
      currentuserresponse = await http.post(
        uri,
        headers: headers,
        //body: jsonBody,
        //encoding: encoding,
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print(widget.value);

    showLoadingDialog();
    currentUser();
    Timer(Duration(seconds: 1), () {
      hideLoadingDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                  child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundImage: NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRh-UGFLqpsC_pSdrqB07CZ6x7XRlV9LjYjJEZ3QfQ2ZcdXedG1D-m2DMRB2ZgSekb98S8&usqp=CAU'),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 100.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        onTap: () {},
                        // ignore: unnecessary_null_comparison
                        title: Text(name == null ? name = "name" : name),
                        subtitle: Text(email == null ? email = "email" : email),
                        // leading: Icon(
                        //   Icons.add_business_rounded,
                        //   size: 40,
                        // ),
                        // trailing: Icon(Icons.arrow_forward_ios_outlined)
                      ),
                    ),
                  ],
                ),
              )),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                signout().then((_) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignIn()));
                });
                // AuthMethods().signOut().then((s) {
                //   Navigator.pushReplacement(context,
                //       MaterialPageRoute(builder: (context) => SignIn()));
                // });
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                child: Text("Sign Out"),
              )),
        ],
      ),
    );
  }
}
