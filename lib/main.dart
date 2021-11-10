import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shipping/services/auth.dart';
import 'package:shipping/views/home.dart';
import 'package:shipping/views/signin.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:load/load.dart';
import 'dart:io';

void main() async {
  //To initialize firebase core
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DotEnv.load(fileName: ".env");
  try {
    final result = await InternetAddress.lookup('example.com');

    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      runApp(
        LoadingProvider(
          themeData:
              LoadingThemeData(animDuration: Duration(milliseconds: 800)),
          child: MyApp(),
        ),
      );
    }
  } on SocketException catch (_) {
    Fluttertoast.showToast(
        msg: "Internet required",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    runApp(Internet());
    print("no internet");
  }
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

class Internet extends StatelessWidget {
  const Internet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: Text("Internet Required")),
      ),
    );
  }
}
