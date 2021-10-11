import 'package:flutter/material.dart';

class CreateShipment extends StatefulWidget {
  const CreateShipment({Key? key}) : super(key: key);

  @override
  _CreateShipmentState createState() => _CreateShipmentState();
}

class _CreateShipmentState extends State<CreateShipment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Second Route"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
