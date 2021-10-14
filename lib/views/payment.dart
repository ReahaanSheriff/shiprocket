import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
      ),
      body: Column(
        children: [
          Container(
            child: TextFormField(
              decoration: const InputDecoration(
                icon: const Icon(Icons.price_change),
                //hintText: 'Door no and Street Name',
                labelText: 'Charges',
              ),
            ),
          ),
          ElevatedButton(
            child: const Text('Pay'),
            onPressed: () {},
            //onPressed: null,
          )
        ],
      ),
    );
  }
}
