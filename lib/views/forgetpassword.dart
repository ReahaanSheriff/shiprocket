import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shipping/views/login.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  var emailcontroller = new TextEditingController();
  var tokencontroller = new TextEditingController();
  var passwordcontroller = new TextEditingController();
  var resetresponsebody, forgetresponsebody, fstatuscode, rstatuscode;
  forgetpassword() async {
    final uri = Uri.parse('http://reahaan.pythonanywhere.com/password_reset/');
    final headers = {'Content-Type': 'application/json'};

    Map<String, dynamic> body = {
      "email": emailcontroller.text,
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    var response;

    try {
      response = await http.post(
        uri,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );
      fstatuscode = response.statusCode;
      forgetresponsebody = json.decode(response.body);
      print(fstatuscode);
    } on Exception catch (e) {
      print(e);

      Fluttertoast.showToast(
          msg: "Error in forgetpassword function",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return fstatuscode;
  }

  resetpassword() async {
    final uri =
        Uri.parse('http://reahaan.pythonanywhere.com/password_reset/confirm/');
    final headers = {'Content-Type': 'application/json'};

    Map<String, dynamic> body = {
      "password": passwordcontroller.text,
      "token": tokencontroller.text
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    var response;

    try {
      response = await http.post(
        uri,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );
      rstatuscode = response.statusCode;
      resetresponsebody = jsonDecode(response.body);

      print(resetresponsebody);
      print(rstatuscode);
      //print(statusCode);
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: "Error in resetpassword function",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return rstatuscode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forget password"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Forget Password',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: emailcontroller,
                onFieldSubmitted: (String str) {
                  setState(() {});
                },
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                )),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  forgetpassword().then((value) {
                    if (value == 200) {
                      Fluttertoast.showToast(
                          msg: "Mail Send Successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 4,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      emailcontroller.text = "";
                    } else {
                      Fluttertoast.showToast(
                          msg: forgetresponsebody.toString(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 4,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  });
                },
                child: Text("Get Token")),
            SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: tokencontroller,
                onFieldSubmitted: (String str) {
                  setState(() {});
                },
                decoration: const InputDecoration(
                  labelText: 'Token',
                )),
            TextFormField(
                controller: passwordcontroller,
                onFieldSubmitted: (String str) {
                  setState(() {});
                },
                decoration: const InputDecoration(
                  labelText: 'Password',
                )),
            ElevatedButton(
                onPressed: () {
                  resetpassword().then((value) {
                    if (value == 200) {
                      Fluttertoast.showToast(
                          msg: "Reset Password Successful",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 4,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    } else {
                      Fluttertoast.showToast(
                          msg: resetresponsebody.toString(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 6,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  });
                },
                child: Text("Submit")),
          ],
        ),
      ),
    );
  }
}
