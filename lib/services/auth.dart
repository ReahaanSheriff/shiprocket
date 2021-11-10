import 'package:shipping/helperfunctions/sharedpref_helper.dart';
import 'package:shipping/services/database.dart';
import 'package:shipping/views/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return await auth.currentUser;
  }

  Future<String> login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      print("Logging with email");
      print(auth.currentUser);

      return "Logged in";
    } catch (e) {
      print(auth.currentUser);
      print("cannot");
      return e.toString();
    }
  }

  Future<String> signup(
      String email, String password, String confirmPassword) async {
    try {
      // UserCredential result = await auth.createUserWithEmailAndPassword(
      //     email: email, password: password);
      // User? user = result.user;
      // user!.updateProfile(
      //   displayName: username,
      // );
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Signed Up";
    } catch (e) {
      return e.toString();
    }
  }

  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    UserCredential result =
        await _firebaseAuth.signInWithCredential(credential);

    User? userDetails = result.user;

    if (result != null) {
      SharedPreferenceHelper().saveUserEmail(userDetails!.email.toString());
      SharedPreferenceHelper().saveUserId(userDetails.uid);
      SharedPreferenceHelper()
          .saveUserName(userDetails.email!.replaceAll("@gmail.com", ""));
      SharedPreferenceHelper()
          .saveDisplayName(userDetails.displayName.toString());
      SharedPreferenceHelper()
          .saveUserProfileUrl(userDetails.photoURL.toString());

      Map<String, dynamic> userInfoMap = {
        "email": userDetails.email,
        "username": userDetails.email!.replaceAll("@gmail.com", ""),
        "name": userDetails.displayName,
        "imgUrl": userDetails.photoURL,
      };
      DatabaseMethods()
          .addUserInfoToDB(userDetails.uid, userInfoMap)
          .then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      });
    }
  }

  Future signOut() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.clear();
    try {
      await auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
      await auth.signOut();
    }
  }
}
