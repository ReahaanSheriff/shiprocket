import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:load/load.dart';

import 'package:swift/views/forgetpassword.dart';
import 'package:swift/views/home.dart';
import 'package:swift/views/sharedpref.dart';
import 'package:swift/views/signin.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var usernamecontroller = new TextEditingController();
  var passwordcontroller = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  var responsebody;
  var token, statusCode;
  bool _isObscure = true;

  login() async {
    final uri = Uri.parse('http://reahaan.pythonanywhere.com/login/');
    final headers = {'Content-Type': 'application/json'};
    // final headers = {
    //   'Authorization':
    //       'Token 1aaa6956c65f9a2c28453ccd20cf78f9857cb14a3acaf2cb6307e0c0b827f886'
    // };

    Map<String, dynamic> body = {
      "username": usernamecontroller.text,
      "password": passwordcontroller.text,
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
      statusCode = response.statusCode;
      responsebody = jsonDecode(response.body);

      print(responsebody);
      SharedPreferenceHelper().saveToken(responsebody["token"]);
      token = responsebody["token"];
      setState(() {});
      print(token);
      //print(statusCode);
    } on Exception catch (e) {
      print("error on login function $e");
    }
    return statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.orange[200],
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 250.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Login",
                  style: TextStyle(fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: usernamecontroller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: const Icon(Icons.person),
                      //hintText: 'Door no and Street Name',
                      labelText: 'Username',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: passwordcontroller,
                    onFieldSubmitted: (String str) {
                      final String email = usernamecontroller.text.trim();
                      final String password = passwordcontroller.text.trim();
                      if (email.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Username field is empty",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 4,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        print('Email field is empty');
                      } else if (password.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Password field is empty",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 4,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        print("Password field is empty");
                      } else {
                        try {
                          login().then((value) {
                            if (value == 201) {
                              showLoadingDialog();
                              //Navigator.pop(context, true);
                              Fluttertoast.showToast(
                                  msg: "Logged in Successfully",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 4,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Home(value: token)));
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Invalid Credentials",
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
                              msg: "Invalid Credentialsc $e",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 4,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      }
                    },
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      icon: const Icon(Icons.password),
                      //hintText: 'Door no and Street Name',
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: Icon(_isObscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      final String email = usernamecontroller.text.trim();
                      final String password = passwordcontroller.text.trim();
                      if (email.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Username field is empty",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 4,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        print('Email field is empty');
                      } else if (password.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Password field is empty",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 4,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        print("Password field is empty");
                      } else {
                        try {
                          login().then((value) {
                            if (value == 201) {
                              showLoadingDialog();
                              // Navigator.pop(context, true);
                              Fluttertoast.showToast(
                                  msg: "Logged in Successfully",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 4,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Home(value: token)));
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Invalid Credentials",
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
                              msg: "Invalid Credentials $e",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 4,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      }
                    },
                    child: Text("LOGIN")),
                Container(
                    child: Center(
                        child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgetPassword()));
                  },
                  child: Text("Forget Password?"),
                ))),
                Container(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => SignIn()));
                      },
                      child: Text("Don't Have an account? Signin")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
