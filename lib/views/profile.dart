import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:load/load.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:swift/views/signin.dart';

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
  var currentuserresponse, responseBody, name, email, excep;
  var oldpassword = TextEditingController();
  var newpassword = TextEditingController();
  bool oObscure = true;
  bool nObscure = true;
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

  changePassword() async {
    final uri = Uri.parse('http://reahaan.pythonanywhere.com/changepassword/');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token ' + widget.value.toString()
    };

    Map<String, dynamic> body = {
      "old_password": oldpassword.text,
      "new_password": newpassword.text,
    };
    var jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    var response, statusCode;

    try {
      response = await http.put(
        uri,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );
      statusCode = response.statusCode;
      excep = jsonDecode(response.body);
    } on Exception catch (e) {
      print(e);
    }
    return excep['status'];
  }

  deleteTokens() async {
    final uri = Uri.parse('http://reahaan.pythonanywhere.com/deletetokens/');
    //final headers = {'Authorization': 'Token ' + widget.value.toString()};
//String jsonBody = json.encode(body);
    //final encoding = Encoding.getByName('utf-8');

    try {
      currentuserresponse = await http.post(
        uri,
        //headers: headers,
        //body: jsonBody,
        //encoding: encoding,
      );
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
      body: SingleChildScrollView(
        child: Column(
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
                          subtitle:
                              Text(email == null ? email = "email" : email),
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
            Container(
              child: Column(
                children: [
                  Center(child: Text("Change Password")),
                  TextField(
                    controller: oldpassword,
                    obscureText: oObscure,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.price_change),
                      //hintText: 'Country',
                      labelText: 'Old Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            oObscure = !oObscure;
                          });
                        },
                        icon: Icon(
                            oObscure ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                  ),
                  TextField(
                    controller: newpassword,
                    obscureText: nObscure,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.price_change),
                      //hintText: 'Country',
                      labelText: 'New Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            nObscure = !nObscure;
                          });
                        },
                        icon: Icon(
                            nObscure ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        final String opassword = oldpassword.text.trim();
                        final String npassword = newpassword.text.trim();
                        if (opassword.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Old password field is empty",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 4,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else if (npassword.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "New Password field is empty",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 4,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          try {
                            changePassword().then((value) {
                              if (value == 'success') {
                                showLoadingDialog();
                                Fluttertoast.showToast(
                                    msg: "Password changed Successfully",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 4,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                hideLoadingDialog();
                                newpassword.text = oldpassword.text = "";
                              } else {
                                Fluttertoast.showToast(
                                    msg: excep.toString(),
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 4,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            });
                          } on Exception catch (e) {
                            Fluttertoast.showToast(
                                msg: "Invalid Credentials",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 4,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        }
                      },
                      child: Text("Submit"))
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  signout().then((_) async {
                    Navigator.pop(context, true);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignIn()),
                    );
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear();
                    deleteTokens();
                    // Navigator.popUntil(context, ModalRoute.withName('/signin'));
                  });
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                  child: Text("Sign Out"),
                )),
          ],
        ),
      ),
    );
  }
}
