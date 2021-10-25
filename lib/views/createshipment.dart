import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shipping/views/home.dart';
import 'package:shipping/views/viewshipments.dart';

import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;

String GenerateOrderId() {
  var rnd = new Random();
  var next = rnd.nextDouble() * 1000000;
  while (next < 100000) {
    next *= 10;
  }
  return ('ord' + next.toInt().toString());
}

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
          title: const Text("Create Shipment"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(child: PickupAddress()),
            ],
          ),
        ));
  }
}

class PickupAddress extends StatefulWidget {
  const PickupAddress({Key? key}) : super(key: key);
  @override
  _PickupAddressState createState() => _PickupAddressState();
}

class _PickupAddressState extends State<PickupAddress> {
  final _formKey = GlobalKey<FormState>();
  var txt = new TextEditingController();
  var pincontroller = new TextEditingController();

  double count = 0;
  double getPrice() {
    setState(() {
      count = 40.5;
    });
    return count;
  }

// Pincode API

  Future getPincodeData() async {
    var response = await http.get(
        Uri.https('api.postalpincode.in', '/pincode/${pincontroller.text}'));
    var jsonData = jsonDecode(response.body);

    // for (var i in jsonData) {
    //   print(i["PostOffice"][0]["District"]);
    //   print(i["PostOffice"][0]['State']);
    //   print(i["PostOffice"][0]['Country']);
    // }
    print(jsonData[0]["PostOffice"][0]);
  }

//Razor pay config

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
      "amount": num.parse(count.toString()) * 100,
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

// End of razor pay config
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Text(
              "Pickup Address",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          TextFormField(
            initialValue: GenerateOrderId(),
            readOnly: true,
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              //hintText: 'Door no and Street Name',
              labelText: 'Order Id',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              //hintText: 'Door no and Street Name',
              labelText: 'Name',
            ),
          ),
          TextFormField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
            ],
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              return value!.length < 10 ? 'Mobile must be of length 10' : null;
            },
            decoration: const InputDecoration(
              icon: const Icon(Icons.phone),
              //hintText: 'Mobile No',
              labelText: 'Mobile No',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              //hintText: 'Door no and Street Name',
              labelText: 'Door no and Street Name',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.map),
              //hintText: 'Area',
              labelText: 'Area',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.location_city),
              //hintText: 'Landmark',
              labelText: 'Landmark',
            ),
          ),
          TextFormField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(6),
            ],
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              return value!.length < 6 ? 'Pincode must be of length 6' : null;
            },
            decoration: const InputDecoration(
              icon: const Icon(Icons.map),
              //hintText: 'State',
              labelText: 'Pincode',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.location_city),
              // hintText: 'City',
              labelText: 'City',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.map),
              //hintText: 'State',
              labelText: 'State',
            ),
          ),

          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.location_city),
              //hintText: 'Country',
              labelText: 'Country',
            ),
          ),

          Center(
            child: Text(
              "Drop Address",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              //hintText: 'Door no and Street Name',
              labelText: 'Name',
            ),
          ),
          TextFormField(
            validator: (value) {
              return value!.length < 10 ? 'Mobile must be of length 10' : null;
            },
            keyboardType: TextInputType.numberWithOptions(),
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: const InputDecoration(
              icon: const Icon(Icons.phone),
              //hintText: 'Mobile No',
              labelText: 'Mobile No',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              //hintText: 'Door no and Street Name',
              labelText: 'Door no and Street Name',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.map),
              //hintText: 'Area',
              labelText: 'Area',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.location_city),
              //hintText: 'Landmark',
              labelText: 'Landmark',
            ),
          ),
          TextFormField(
            controller: pincontroller,
            onFieldSubmitted: (String str) {
              setState(() {
                getPincodeData();
              });
            },
            validator: (value) {
              return value!.length < 6 ? 'Pincode must be of length 6' : null;
            },
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              LengthLimitingTextInputFormatter(6),
            ],
            decoration: const InputDecoration(
              icon: const Icon(Icons.map),
              //hintText: 'State',
              labelText: 'Pincode',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.location_city),
              // hintText: 'City',
              labelText: 'City',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.map),
              //hintText: 'State',
              labelText: 'State',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.location_city),
              //hintText: 'Country',
              labelText: 'Country',
            ),
          ),

          Center(
            child: Text("Product Detail", style: TextStyle(fontSize: 20.0)),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.topic),
              //hintText: 'Country',
              labelText: 'Product Name',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.price_change),
              //hintText: 'Country',
              labelText: 'Value of Product',
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              icon: const Icon(Icons.monitor_weight),
              //hintText: 'Mobile No',
              labelText: 'Weight (Kg)',
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Flexible(
                child: new TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    icon: const Icon(Icons.add_chart),
                    contentPadding: EdgeInsets.all(10),
                    labelText: 'L',
                  ),
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              new Flexible(
                child: new TextFormField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      labelText: 'W',
                    )),
              ),
              SizedBox(
                width: 20.0,
              ),
              new Flexible(
                child: new TextFormField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      labelText: 'Height',
                    )),
              ),
            ],
          ),
          //Text("$count"),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Flexible(
                child: new TextFormField(
                    //readOnly: true,
                    controller: txt,
                    //controller: textEditingController,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.attach_money),
                      contentPadding: EdgeInsets.all(10),
                      labelText: 'Shipping cost',
                    )),
              ),

              // SizedBox(
              //   width: 40.0,
              // ),
              new Flexible(
                  child: Padding(
                padding: const EdgeInsets.only(right: 15.0, top: 20),
                child: ElevatedButton(
                    onPressed: () {
                      // ignore: unnecessary_statements
                      txt.text = getPrice().toString();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, right: 25, top: 10, bottom: 10),
                      child: Text("Get Cost"),
                    )),
              ))
            ],
          ),
          new Container(
              padding: const EdgeInsets.only(left: 150.0, top: 20.0),
              child: new ElevatedButton(
                child: const Text('Proceed'),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => Payment()),
                  // );
                  openCheckout();
                },
                //onPressed: null,
              )),
        ],
      ),
    );
  }
}
