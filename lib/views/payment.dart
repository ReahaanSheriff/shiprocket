import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shipping/views/createshipment.dart';
import 'package:shipping/views/home.dart';
import 'package:shipping/views/viewshipments.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late Razorpay razorpay;
  TextEditingController textEditingController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    razorpay = new Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void openCheckout() {
    var options = {
      "key": "rzp_test_m9PcTlXKqHX4Hy",
      "amount": num.parse(textEditingController.text) * 100,
      "name": "Sample App",
      "description": "Payment for the some random product",
      "prefill": {"contact": "9500777777", "email": "reahaan@gmail.com"},
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewShipments()),
    );
    Fluttertoast.showToast(
        msg: "Payment success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 4,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void handlerErrorFailure() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateShipment()),
    );
    Fluttertoast.showToast(
        msg: "Payment Failure",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 4,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void handlerExternalWallet() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
    Fluttertoast.showToast(
        msg: "handler External Wallet function",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 4,
        backgroundColor: Colors.yellow,
        textColor: Colors.white,
        fontSize: 16.0);
  }

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
              controller: textEditingController,
              decoration: const InputDecoration(
                icon: const Icon(Icons.price_change),
                //hintText: 'Door no and Street Name',
                labelText: 'Charges',
              ),
            ),
          ),
          ElevatedButton(
            child: const Text('Pay Now'),
            onPressed: () {
              openCheckout();
            },
          )
        ],
      ),
    );
  }
}
