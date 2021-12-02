import 'dart:convert';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:load/load.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shipping/views/forgetpassword.dart';
import 'package:shipping/views/home.dart';
import 'package:shipping/views/sharedpref.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shipping"),
      ),
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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
      print("error on login function");
    }
    return statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: usernamecontroller,
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              //hintText: 'Door no and Street Name',
              labelText: 'Username',
            ),
          ),

          TextFormField(
            controller: passwordcontroller,
            onFieldSubmitted: (String str) {
              final String email = usernamecontroller.text.trim();
              final String password = passwordcontroller.text.trim();
              if (email.isEmpty) {
                Fluttertoast.showToast(
                    msg: "Email field is empty",
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
                      Navigator.pop(context, true);
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
                              builder: (context) => Home(value: token)));
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
            obscureText: _isObscure,
            decoration: InputDecoration(
              icon: const Icon(Icons.person),
              //hintText: 'Door no and Street Name',
              labelText: 'Password',
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
                icon:
                    Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
              ),
            ),
          ),

          ElevatedButton(
              onPressed: () {
                final String email = usernamecontroller.text.trim();
                final String password = passwordcontroller.text.trim();
                if (email.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Email field is empty",
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
                        Future.delayed(const Duration(milliseconds: 500), () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Home(value: token)));
                        });
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

                    // start Firebase auth
                    // AuthMethods().login(email, password).then((value) async {
                    //   User? user = FirebaseAuth.instance.currentUser;

                    //   if (user != null && value == "Logged in") {
                    //     Navigator.pushReplacement(context,
                    //         MaterialPageRoute(builder: (context) => Home()));
                    //     Fluttertoast.showToast(
                    //         msg: "Logged In successfully",
                    //         toastLength: Toast.LENGTH_SHORT,
                    //         gravity: ToastGravity.CENTER,
                    //         timeInSecForIosWeb: 4,
                    //         backgroundColor: Colors.green,
                    //         textColor: Colors.white,
                    //         fontSize: 16.0);
                    //   } else {
                    //     Fluttertoast.showToast(
                    //         msg: "Invalid Credentials",
                    //         toastLength: Toast.LENGTH_SHORT,
                    //         gravity: ToastGravity.CENTER,
                    //         timeInSecForIosWeb: 4,
                    //         backgroundColor: Colors.red,
                    //         textColor: Colors.white,
                    //         fontSize: 16.0);
                    //   }
                    // });
                    // end Firebase auth
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

                //.then((value) async {
                //   User? result = FirebaseAuth.instance.currentUser;
                //   print(result);
                //   if (result != null) {
                //     Navigator.pushReplacement(context,
                //         MaterialPageRoute(builder: (context) => Home()));
                //   }
                // });
              },
              child: Text("LOGIN")),
          Container(
              child: Center(
                  child: TextButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ForgetPassword()));
            },
            child: Text("Forget Password?"),
          )))
          // ElevatedButton(
          //     onPressed: () {
          //       final String email = emailcontroller.text.trim();
          //       final String password = passwordcontroller.text.trim();
          //       if (email.isEmpty) {
          //         print('Email field is empty');
          //       } else if (password.isEmpty) {
          //         print("Password field is empty");
          //       } else {
          //         AuthMethods().signup(email, password).then((value) async {
          //           User? user = FirebaseAuth.instance.currentUser;
          //           await FirebaseFirestore.instance
          //               .collection("users")
          //               .doc(user!.uid)
          //               .set({
          //             'uid': user.uid,
          //             'email': email,
          //             'password': password,
          //           });
          //         });
          //       }
          //     },
          //     child: Text("SIGNUP")),
          // Container(
          //   child: Center(
          //       child: InkWell(
          //     onTap: () {
          //       // showLoadingDialog();
          //       // AuthMethods().signInWithGoogle(context);
          //     },
          //     child: Ink(
          //       color: Color(0xFF4285F4),
          //       //color: Colors.lightBlue,
          //       //color: Color(0xFF397AF3),
          //       child: Padding(
          //         padding: EdgeInsets.all(6),
          //         child: Wrap(
          //           crossAxisAlignment: WrapCrossAlignment.center,
          //           children: [
          //             //Icon(Icons.android), // <-- Use 'Image.asset(...)' here
          //             Image.asset(
          //               'images/google.png',
          //               height: 48,
          //             ),

          //             SizedBox(width: 12),
          //             Text(
          //               'Sign in with Google',
          //               style: TextStyle(color: Colors.white),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   )

          //       ),
          // ),
        ],
      ),
    );
  }
}
