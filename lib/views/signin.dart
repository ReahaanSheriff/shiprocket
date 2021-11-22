import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shipping/views/login.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shipping"),
        automaticallyImplyLeading: false,
      ),
      body: SigninForm(),
    );
  }
}

class SigninForm extends StatefulWidget {
  const SigninForm({Key? key}) : super(key: key);

  @override
  _SigninFormState createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  var confirmcontroller = new TextEditingController();
  var usernamecontroller = new TextEditingController();
  var emailcontroller = new TextEditingController();
  bool _isObscure = true;
  bool _isConObscure = true;
  var passwordcontroller = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var statuscode, responseBody, res;
  signin() async {
    final uri = Uri.parse('http://reahaan.pythonanywhere.com/register/');
    final headers = {'Content-Type': 'application/json'};
    // final headers = {
    //   'Authorization':
    //       'Token 1aaa6956c65f9a2c28453ccd20cf78f9857cb14a3acaf2cb6307e0c0b827f886'
    // };

    Map<String, dynamic> body = {
      "username": usernamecontroller.text,
      "email": emailcontroller.text,
      "password": passwordcontroller.text
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
      statuscode = response.statusCode;
      responseBody = jsonDecode(response.body);

      print(responseBody);
      print(statuscode);
    } on Exception catch (e) {
      print(e);
    }
    return statuscode;
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
            controller: emailcontroller,
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              //hintText: 'Door no and Street Name',
              labelText: 'Email',
            ),
          ),
          TextFormField(
            controller: passwordcontroller,
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
          TextFormField(
            onFieldSubmitted: (String str) {
              final String confirmPassword = confirmcontroller.text.trim();
              final String username = usernamecontroller.text.trim();
              final String email = emailcontroller.text.trim();
              final String password = passwordcontroller.text.toString().trim();
              if (email.isEmpty) {
                Fluttertoast.showToast(
                    msg: "Email field is empty",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 4,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);

                //print('Email field is empty');
              } else if (!email.contains('@')) {
                Fluttertoast.showToast(
                    msg: "Email is not valid",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 4,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else if (password.isEmpty) {
                Fluttertoast.showToast(
                    msg: "Password field is empty",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 4,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
                print("Password field is empty");
              } else if (username.isEmpty) {
                Fluttertoast.showToast(
                    msg: "Username field is empty",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 4,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
                print("Username field is empty");
              } else if (password != confirmPassword) {
                Fluttertoast.showToast(
                    msg: "Password does not match",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 4,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                try {
                  signin().then((value) {
                    if (value == 201) {
                      Fluttertoast.showToast(
                          msg: "Registered Successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 4,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    } else {
                      Fluttertoast.showToast(
                          msg: responseBody.toString(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 4,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  });
                } catch (e) {
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
            controller: confirmcontroller,
            obscureText: _isConObscure,
            decoration: InputDecoration(
              icon: const Icon(Icons.person),
              //hintText: 'Door no and Street Name',
              labelText: 'Confirm Pasword',
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isConObscure = !_isConObscure;
                  });
                },
                icon: Icon(
                    _isConObscure ? Icons.visibility : Icons.visibility_off),
              ),
            ),
          ),

          ElevatedButton(
              onPressed: () {
                final String confirmPassword = confirmcontroller.text.trim();
                final String username = usernamecontroller.text.trim();
                final String email = emailcontroller.text.trim();
                final String password =
                    passwordcontroller.text.toString().trim();
                if (email.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Email field is empty",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 4,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);

                  //print('Email field is empty');
                } else if (password.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Password field is empty",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 4,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  print("Password field is empty");
                } else if (username.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Username field is empty",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 4,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  print("Username field is empty");
                } else if (password != confirmPassword) {
                  Fluttertoast.showToast(
                      msg: "Password does not match",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 4,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  try {
                    signin().then((value) {
                      if (value == 201) {
                        Fluttertoast.showToast(
                            msg: "Registered Successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 4,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      } else {
                        Fluttertoast.showToast(
                            msg: responseBody.toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 4,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    });
                    // start Firebase end
                    // AuthMethods()
                    //     .signup(email, password, confirmPassword)
                    //     .then((value) async {
                    //   if (value == "Signed Up") {
                    //     Navigator.pushReplacement(context,
                    //         MaterialPageRoute(builder: (context) => Home()));
                    //     Fluttertoast.showToast(
                    //         msg: "Signed In successfully",
                    //         toastLength: Toast.LENGTH_SHORT,
                    //         gravity: ToastGravity.CENTER,
                    //         timeInSecForIosWeb: 4,
                    //         backgroundColor: Colors.green,
                    //         textColor: Colors.white,
                    //         fontSize: 16.0);
                    //   }
                    // }).then((value) async {
                    //   User? user = FirebaseAuth.instance.currentUser;
                    //   await FirebaseFirestore.instance
                    //       .collection("users")
                    //       .doc(user!.uid)
                    //       .set({
                    //     'uid': user.uid,
                    //     'email': email,
                    //     'password': password,
                    //   });
                    // });
                    // end firebase auth
                  } catch (e) {
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
              child: Text("SIGNUP")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
              child: Text("Already Have an account? Login")),
          // Container(
          //   child: Center(
          //       child: InkWell(
          //     onTap: () {
          //       AuthMethods().signInWithGoogle(context);
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

          //       // child: GestureDetector(
          //       //   onTap: () {
          //       //     AuthMethods().signInWithGoogle(context);
          //       //   },
          //       //   child: Container(
          //       //       // decoration: BoxDecoration(
          //       //       //     borderRadius: BorderRadius.circular(24), color: Colors.red),
          //       //       // padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
          //       //       child: SignInButton(
          //       //     Buttons.GoogleDark,
          //       //     //SizedBox(width: 12),
          //       //     padding: EdgeInsets.all(6),
          //       //     onPressed: () {
          //       //       AuthMethods().signInWithGoogle(context);
          //       //     },
          //       //   )),
          //       //   // child: Text(
          //       //   //   "Sign In with Google",
          //       //   //   style: TextStyle(fontSize: 16, color: Colors.white),
          //       //   // ))
          //       // ),
          //       ),
          // ),
        ],
      ),
    );
  }
}
