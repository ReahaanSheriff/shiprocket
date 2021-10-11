import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shipping/services/auth.dart';
import 'package:shipping/views/home.dart';
import 'package:shipping/views/signin.dart';

void main() async {
  //To initialize firebase core
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: AuthMethods().getCurrentUser(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Home();
          } else {
            return SignIn();
          }
        },
      ),
    );
  }
}
