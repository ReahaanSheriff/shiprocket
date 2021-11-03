import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shipping/services/auth.dart';
import 'package:shipping/views/home.dart';

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
  var emailcontroller = new TextEditingController();
  var passwordcontroller = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
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
            obscureText: true,
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              //hintText: 'Door no and Street Name',
              labelText: 'Password',
            ),
          ),
          ElevatedButton(
              onPressed: () {
                final String email = emailcontroller.text.trim();
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
                    AuthMethods().login(email, password).then((value) async {
                      User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      }
                      Fluttertoast.showToast(
                          msg: "Logged In successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 4,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);
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
          Container(
            child: Center(
                child: InkWell(
              onTap: () {
                AuthMethods().signInWithGoogle(context);
              },
              child: Ink(
                color: Color(0xFF4285F4),
                //color: Colors.lightBlue,
                //color: Color(0xFF397AF3),
                child: Padding(
                  padding: EdgeInsets.all(6),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      //Icon(Icons.android), // <-- Use 'Image.asset(...)' here
                      Image.asset(
                        'images/google.png',
                        height: 48,
                      ),

                      SizedBox(width: 12),
                      Text(
                        'Sign in with Google',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            )

                // child: GestureDetector(
                //   onTap: () {
                //     AuthMethods().signInWithGoogle(context);
                //   },
                //   child: Container(
                //       // decoration: BoxDecoration(
                //       //     borderRadius: BorderRadius.circular(24), color: Colors.red),
                //       // padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                //       child: SignInButton(
                //     Buttons.GoogleDark,
                //     //SizedBox(width: 12),
                //     padding: EdgeInsets.all(6),
                //     onPressed: () {
                //       AuthMethods().signInWithGoogle(context);
                //     },
                //   )),
                //   // child: Text(
                //   //   "Sign In with Google",
                //   //   style: TextStyle(fontSize: 16, color: Colors.white),
                //   // ))
                // ),
                ),
          ),
        ],
      ),
    );
  }
}
