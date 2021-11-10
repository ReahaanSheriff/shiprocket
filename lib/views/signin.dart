import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shipping/helperfunctions/sharedpref_helper.dart';
import 'package:shipping/services/auth.dart';
import 'package:shipping/services/database.dart';
import 'package:shipping/views/home.dart';
import 'package:shipping/views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_signin_button/flutter_signin_button.dart';

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
          TextFormField(
            controller: confirmcontroller,
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              //hintText: 'Door no and Street Name',
              labelText: 'Confirm Pasword',
            ),
          ),
          // ElevatedButton(
          //     onPressed: () {
          //       final String email = emailcontroller.text.trim();
          //       final String password = passwordcontroller.text.trim();
          //       final String username = usernamecontroller.text.trim();
          //       if (email.isEmpty) {
          //         print('Email field is empty');
          //       } else if (password.isEmpty) {
          //         print("Password field is empty");
          //       } else if (username.isEmpty) {
          //         print("Username field is empty");
          //       }
          //       else {
          //         AuthMethods().login(username,email, password).then((value) async {
          //           User? user = FirebaseAuth.instance.currentUser;
          //           if (user != null) {
          //             Navigator.pushReplacement(context,
          //                 MaterialPageRoute(builder: (context) => Home()));
          //           }
          //         });
          //       }

          //       //.then((value) async {
          //       //   User? result = FirebaseAuth.instance.currentUser;
          //       //   print(result);
          //       //   if (result != null) {
          //       //     Navigator.pushReplacement(context,
          //       //         MaterialPageRoute(builder: (context) => Home()));
          //       //   }
          //       // });
          //     },
          //     child: Text("LOGIN")),
          ElevatedButton(
              onPressed: () {
                final String confirmPassword = confirmcontroller.text.trim();
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
                    AuthMethods()
                        .signup(email, password, confirmPassword)
                        .then((value) async {
                      if (value == "Signed Up") {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Home()));
                        Fluttertoast.showToast(
                            msg: "Signed In successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 4,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    }).then((value) async {
                      User? user = FirebaseAuth.instance.currentUser;
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(user!.uid)
                          .set({
                        'uid': user.uid,
                        'email': email,
                        'password': password,
                      });
                    });
                    // AuthMethods()
                    //     .signup(username, mobile, email, password)
                    //     .then((value) async {
                    //   User? user = FirebaseAuth.instance.currentUser;

                    //   await FirebaseFirestore.instance
                    //       .collection("users")
                    //       .doc(user!.uid)
                    //       .set({
                    //     'uid': user.uid,
                    //     'username': username,
                    //     'phoneNumber': mobile,
                    //     'displayName': username,
                    //     'email': email,
                    //     'password': password,
                    //     'photoURL':
                    //         "'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRh-UGFLqpsC_pSdrqB07CZ6x7XRlV9LjYjJEZ3QfQ2ZcdXedG1D-m2DMRB2ZgSekb98S8&usqp=CAU'",
                    //   });
                    //   user.updateProfile(
                    //     displayName: username,
                    //     photoURL:
                    //         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRh-UGFLqpsC_pSdrqB07CZ6x7XRlV9LjYjJEZ3QfQ2ZcdXedG1D-m2DMRB2ZgSekb98S8&usqp=CAU',
                    //   );

                    //   if (user != null && value == "Signed Up") {
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
                    //   print("signed up successfully");
                    // });
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
              child: Text("Already Have an account or Google signIn")),
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
