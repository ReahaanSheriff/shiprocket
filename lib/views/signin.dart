import 'package:flutter/material.dart';
import 'package:shipping/services/auth.dart';
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
      ),
      body: Center(
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
    );
  }
}
