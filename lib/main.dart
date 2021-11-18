import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shipping/views/signin.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:load/load.dart';
import 'package:http/http.dart' as http;

void main() async {
  //To initialize firebase core
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DotEnv.load(fileName: ".env");

  runApp(LoadingProvider(
      themeData: LoadingThemeData(animDuration: Duration(milliseconds: 800)),
      child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SignIn());
  }
}
