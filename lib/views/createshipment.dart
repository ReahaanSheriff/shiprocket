import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shipping/views/home.dart';
import 'package:shipping/views/viewshipments.dart';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:vector_math/vector_math.dart' as vec;

String generateOrderId() {
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
  bool _isEnable = true;
  var weightcontroller = new TextEditingController();
  var tocity = new TextEditingController();
  var tostate = new TextEditingController();
  var tocountry = new TextEditingController();
  var fromcity = new TextEditingController();
  var fromstate = new TextEditingController();
  var fromcountry = new TextEditingController();
  var txt = new TextEditingController();
  var toPinController = new TextEditingController();
  var fromPinController = new TextEditingController();
  var pick = new TextEditingController();
  var drop = new TextEditingController();
  var fromAddress = "",
      tolat,
      tolong,
      fromlat,
      fromlong,
      res,
      amount,
      estday,
      kms,
      Cost,
      city,
      state,
      country,
      fcity,
      fstate,
      fcountry,
      thirtyDaysFromNow;
  // double count = 0;

  // double getPrice() {
  //   setState(() {
  //     count++;
  //   });
  //   return count;
  // }

  Future<Position> _getGeoCostPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if Cost services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Cost services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the Cost services.
      await Geolocator.openLocationSettings();
      return Future.error('Cost services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Cost permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Cost permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> getCurrentAddress(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      //print(placemarks);
      Placemark place = placemarks[1];
      fromAddress =
          '${place.thoroughfare}, \n ${place.subLocality},\n ${place.locality},${place.administrativeArea}, \n ${place.country}, ${place.postalCode}';
      _isEnable = false;
      pick.text = fromstate.text =
          fromcity.text = fromPinController.text = fromcountry.text = "";

      setState(() {});
      print(place);

      print(position.latitude);
      print(position.longitude);
      print(tolat);
      print(tolong);
    } on Exception catch (e) {
      // TODO
      Fluttertoast.showToast(
          msg: "Unable to get current location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

// Pincode API
  Future getToPincodeData() async {
    try {
      var response = await http.get(Uri.https(
          'api.postalpincode.in', '/pincode/${toPinController.text}'));
      var jsonData = jsonDecode(response.body);
      if (jsonData[0]["PostOffice"] == null) {
        Fluttertoast.showToast(
            msg: "Pincode invalid or not serviceable",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 4,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          tocity.text = "";
          tostate.text = "";
          tocountry.text = "";
        });
      } else {
        city = jsonData[0]["PostOffice"][0]["District"];
        state = jsonData[0]["PostOffice"][0]["State"];
        country = jsonData[0]["PostOffice"][0]["Country"];
        setState(() {
          tocity.text = city;
          tostate.text = state;
          tocountry.text = country;
        });
      }
    } on Exception catch (e) {
      // TODO
      Fluttertoast.showToast(
          msg: "Pincode invalid or not serviceable",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future getFromPincodeData() async {
    try {
      var fresponse = await http.get(Uri.https(
          'api.postalpincode.in', '/pincode/${fromPinController.text}'));
      var fjsonData = jsonDecode(fresponse.body);
      if (fjsonData[0]["PostOffice"] == null) {
        Fluttertoast.showToast(
            msg: "Pincode invalid or not serviceable",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 4,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          fromcity.text = "";
          fromstate.text = "";
          fromcountry.text = "";
        });
      } else {
        fcity = fjsonData[0]["PostOffice"][0]["District"];
        fstate = fjsonData[0]["PostOffice"][0]["State"];
        fcountry = fjsonData[0]["PostOffice"][0]["Country"];
        setState(() {
          fromcity.text = fcity;
          fromstate.text = fstate;
          fromcountry.text = fcountry;
        });
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: "Pincode invalid or not serviceable",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    // for (var i in jsonData) {
    //   print(i["PostOffice"][0]["District"]);
    //   print(i["PostOffice"][0]['State']);
    //   print(i["PostOffice"][0]['Country']);
    // }
    //print(jsonData[0]["PostOffice"][0]);

    // TODO
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
      "key": env['RAZOR_PAY_KEY'],
      "amount": num.parse(amount.toString()) * 100,
      "name": "Shipping",
      "description": "Complete your payment to create shipment",
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

// Calculating Sphpping price and estimated delivery date

  Future<void> GetAddressFromLatLong(Position position) async {
    final toqueryParameters = {
      'access_key': env["ACCESS_KEY"],
      'query': '${drop.text}',
    };
    final fromqueryParameters;
    if (pick.text != "") {
      fromqueryParameters = {
        'access_key': env["ACCESS_KEY"],
        'query': '${pick.text}',
      };
    } else {
      fromqueryParameters = {
        'access_key': env["ACCESS_KEY"],
        'query': fromAddress,
      };
    }

    var response = await http.get(
        Uri.http("api.positionstack.com", "/v1/forward", toqueryParameters));
    var jsonData = jsonDecode(response.body);

    var fromresponse = await http.get(
        Uri.http("api.positionstack.com", "/v1/forward", fromqueryParameters));
    var fromjsonData = jsonDecode(fromresponse.body);
    // for (var i in jsonData) {
    //   print(i);
    //   // print(i["data"][0]["latitude"]);
    //   // print(i["data"][0]['longitude']);
    // }
    try {
      tolat = jsonData["data"][0]["latitude"];
      tolong = jsonData["data"][0]["longitude"];
      fromlat = fromjsonData["data"][0]["latitude"];
      fromlong = fromjsonData["data"][0]["longitude"];
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Invalid address or Not serviceable",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print('Invalid address ');
      print(e);
    }

    //print(jsonData["data"][0]["latitude"]);
    //print(jsonData["data"][0]["longitude"]);

    //------------

    //var tl = destinationLatLong();

    //print(tl);

    double data() {
      var lat1 = fromlat;
      //position.latitude;
      var lng1 = fromlong;
      //position.longitude;
      var lat2 = tolat;
      var lng2 = tolong;
      var result;
      try {
        result = 6371 *
            acos(cos(vec.radians(lat1)) *
                    cos(vec.radians(lat2)) *
                    cos(vec.radians(lng1) - vec.radians(lng2)) +
                sin(vec.radians(lat1)) * sin(vec.radians(lat2)));
      } catch (e) {
        print(e);
      }
      //print(result);
      return result;
    }

    res = data();
    print(res);
    int price() {
      try {
        if (num.parse(weightcontroller.text) <= 0.500) {
          if (res <= 50) {
            amount = 25;
            estday = 2;
          } else if (res >= 51 && res <= 200) {
            amount = 59;
            estday = 3;
          } else if (res >= 201 && res <= 1000) {
            amount = 71;
            estday = 4;
          } else if (res >= 1001 && res <= 2000) {
            amount = 94;
            estday = 5;
          } else if (res >= 2001) {
            amount = 106;
            estday = 6;
          }
        } else if (num.parse(weightcontroller.text) >= 0.501 &&
            num.parse(weightcontroller.text) <= 1.000) {
          if (res <= 50) {
            amount = 35;
            estday = 2;
          } else if (res >= 51 && res <= 200) {
            amount = 77;
            estday = 3;
          } else if (res >= 201 && res <= 1000) {
            amount = 106;
            estday = 4;
          } else if (res >= 1001 && res <= 2000) {
            amount = 142;
            estday = 5;
          } else if (res >= 2001) {
            amount = 165;
            estday = 6;
          }
        } else if (num.parse(weightcontroller.text) >= 1.001 &&
            num.parse(weightcontroller.text) <= 1.5) {
          if (res <= 50) {
            amount = 45;
            estday = 2;
          } else if (res >= 51 && res <= 200) {
            amount = 94;
            estday = 3;
          } else if (res >= 201 && res <= 1000) {
            amount = 142;
            estday = 4;
          } else if (res >= 1001 && res <= 2000) {
            amount = 189;
            estday = 5;
          } else if (res >= 2001) {
            amount = 224;
            estday = 6;
          }
        } else if (num.parse(weightcontroller.text) >= 1.501 &&
            num.parse(weightcontroller.text) <= 2.0) {
          if (res <= 50) {
            amount = 55;
            estday = 2;
          } else if (res >= 51 && res <= 200) {
            amount = 112;
            estday = 3;
          } else if (res >= 201 && res <= 1000) {
            amount = 177;
            estday = 4;
          } else if (res >= 1001 && res <= 2000) {
            amount = 236;
            estday = 5;
          } else if (res >= 2001) {
            amount = 283;
            estday = 6;
          }
        } else if (num.parse(weightcontroller.text) >= 2.001 &&
            num.parse(weightcontroller.text) <= 2.5) {
          if (res <= 50) {
            amount = 65;
            estday = 2;
          } else if (res >= 51 && res <= 200) {
            amount = 130;
            estday = 3;
          } else if (res >= 201 && res <= 1000) {
            amount = 212;
            estday = 4;
          } else if (res >= 1001 && res <= 2000) {
            amount = 283;
            estday = 5;
          } else if (res >= 2001) {
            amount = 342;
            estday = 6;
          }
        } else if (num.parse(weightcontroller.text) >= 2.501 &&
            num.parse(weightcontroller.text) <= 3.0) {
          if (res <= 50) {
            amount = 75;
            estday = 2;
          } else if (res >= 51 && res <= 200) {
            amount = 148;
            estday = 3;
          } else if (res >= 201 && res <= 1000) {
            amount = 248;
            estday = 4;
          } else if (res >= 1001 && res <= 2000) {
            amount = 330;
            estday = 5;
          } else if (res >= 2001) {
            amount = 401;
            estday = 6;
          }
        } else if (num.parse(weightcontroller.text) >= 3.001 &&
            num.parse(weightcontroller.text) <= 3.5) {
          if (res <= 50) {
            amount = 85;
            estday = 2;
          } else if (res >= 51 && res <= 200) {
            amount = 165;
            estday = 3;
          } else if (res >= 201 && res <= 1000) {
            amount = 283;
            estday = 4;
          } else if (res >= 1001 && res <= 2000) {
            amount = 378;
            estday = 5;
          } else if (res >= 2001) {
            amount = 460;
            estday = 6;
          }
        } else if (num.parse(weightcontroller.text) >= 3.501 &&
            num.parse(weightcontroller.text) <= 4.0) {
          if (res <= 50) {
            amount = 95;
            estday = 2;
          } else if (res >= 51 && res <= 200) {
            amount = 183;
            estday = 3;
          } else if (res >= 201 && res <= 1000) {
            amount = 319;
            estday = 4;
          } else if (res >= 1001 && res <= 2000) {
            amount = 425;
            estday = 5;
          } else if (res >= 2001) {
            amount = 519;
            estday = 6;
          }
        } else if (num.parse(weightcontroller.text) >= 4.001 &&
            num.parse(weightcontroller.text) <= 4.5) {
          if (res <= 50) {
            amount = 105;
            estday = 2;
          } else if (res >= 51 && res <= 200) {
            amount = 201;
            estday = 3;
          } else if (res >= 201 && res <= 1000) {
            amount = 354;
            estday = 4;
          } else if (res >= 1001 && res <= 2000) {
            amount = 472;
            estday = 5;
          } else if (res >= 2001) {
            amount = 578;
            estday = 6;
          }
        } else if (num.parse(weightcontroller.text) >= 4.501 &&
            num.parse(weightcontroller.text) <= 5.0) {
          if (res <= 50) {
            amount = 115;
            estday = 2;
          } else if (res >= 51 && res <= 200) {
            amount = 218;
            estday = 3;
          } else if (res >= 201 && res <= 1000) {
            amount = 389;
            estday = 4;
          } else if (res >= 1001 && res <= 2000) {
            amount = 519;
            estday = 5;
          } else if (res >= 2001) {
            amount = 637;
            estday = 6;
          }
        } else {
          amount = 0;
          estday = 0;
          Fluttertoast.showToast(
              msg: "Weight cannot be more than 5kgs",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 4,
              backgroundColor: Colors.yellow,
              textColor: Colors.black,
              fontSize: 16.0);
          print("Weight cannot be more than 5kgs");
        }
      } on Exception catch (e) {
        print(e);
      }
      setState(() {});
      return amount;
    }

    kms = price();
    print(kms);
    // try {
    //   distance = await Geolocator.distanceBetween(
    //       position.latitude, position.longitude, tolat, tolong);
    //   // distance = await Geolocator.distanceBetween(
    //   //     13.126958, 80.2315072, 13.092798, 80.269044);
    //   print(distance / 1000);
    // } catch (e) {
    //   print(e);
    // }

    // print(distance);

    // Date
    try {
      var formatter = new DateFormat('dd-MM-yyyy');
      if (estday != null) {
        thirtyDaysFromNow =
            formatter.format(DateTime.now().add(new Duration(days: estday)));

        print(thirtyDaysFromNow);

        // end date
        setState(() {});
      }
    } on Exception catch (e) {
      // TODO
      print(e);
    }
  }

// end of calculation of price and date
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              "Pickup Address",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          TextFormField(
            initialValue: generateOrderId(),
            readOnly: true,
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              //hintText: 'Door no and Street Name',
              labelText: 'Order Id',
            ),
          ),

          Text('${fromAddress}'),

          Row(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    Position position = await _getGeoCostPosition();
                    Cost =
                        'Lat: ${position.latitude} , Long: ${position.longitude}';
                    getCurrentAddress(position);
                  },
                  child: Text('Get current location')),
              Padding(padding: EdgeInsets.symmetric(horizontal: 35)),
              ElevatedButton(
                  onPressed: () {
                    fromAddress = "";
                    _isEnable = true;
                    setState(() {});
                  },
                  child: Text("Clear")),
            ],
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
            controller: pick,
            enabled: _isEnable,
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              //hintText: 'Door no and Street Name',

              labelText: 'Address',
            ),
          ),

          TextFormField(
            controller: fromPinController,
            enabled: _isEnable,
            onFieldSubmitted: (String str) {
              setState(() {
                getFromPincodeData();
              });
            },
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
            readOnly: true,
            controller: fromcity,
            enabled: _isEnable,
            decoration: const InputDecoration(
              icon: const Icon(Icons.location_city),
              // hintText: 'City',
              labelText: 'City',
            ),
          ),
          TextFormField(
            readOnly: true,
            enabled: _isEnable,
            controller: fromstate,
            decoration: const InputDecoration(
              icon: const Icon(Icons.map),
              //hintText: 'State',
              labelText: 'State',
            ),
          ),

          TextFormField(
            readOnly: true,
            enabled: _isEnable,
            controller: fromcountry,
            decoration: const InputDecoration(
              icon: const Icon(Icons.location_city),
              //hintText: 'Country',
              labelText: 'Country',
            ),
          ),
          SizedBox(
            height: 10,
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
            controller: drop,
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              //hintText: 'Door no and Street Name',
              labelText: 'Address',
            ),
          ),

          TextFormField(
            controller: toPinController,
            onFieldSubmitted: (String str) {
              setState(() {
                getToPincodeData();
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
            controller: tocity,
            readOnly: true,
            decoration: const InputDecoration(
              icon: const Icon(Icons.location_city),
              // hintText: 'City',
              labelText: 'City',
            ),
          ),
          TextFormField(
            controller: tostate,
            readOnly: true,
            decoration: const InputDecoration(
              icon: const Icon(Icons.map),
              //hintText: 'State',
              labelText: 'State',
            ),
          ),
          TextFormField(
            controller: tocountry,
            readOnly: true,
            decoration: const InputDecoration(
              icon: const Icon(Icons.location_city),
              //hintText: 'Country',
              labelText: 'Country',
            ),
          ),
          SizedBox(
            height: 10,
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
            controller: weightcontroller,
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
          // new Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: <Widget>[
          //     new Flexible(
          //       child: new TextFormField(
          //           readOnly: true,
          //           controller: txt,
          //           //controller: textEditingController,
          //           decoration: InputDecoration(
          //             icon: const Icon(Icons.attach_money),
          //             contentPadding: EdgeInsets.all(10),
          //             labelText: 'Shipping cost',
          //           )),
          //     ),

          //     // SizedBox(
          //     //   width: 40.0,
          //     // ),
          //     new Flexible(
          //         child: Padding(
          //       padding: const EdgeInsets.only(right: 15.0, top: 20),
          //       child: ElevatedButton(
          //           onPressed: () {
          //             txt.text = getPrice().toString();
          //           },
          //           child: Padding(
          //             padding: const EdgeInsets.only(
          //                 left: 25.0, right: 25, top: 10, bottom: 10),
          //             child: Text("Get Cost"),
          //           )),
          //     ))
          //   ],
          // ),
          new Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 150.0),
              child: ElevatedButton(
                onPressed: () async {
                  Position position = await _getGeoCostPosition();
                  GetAddressFromLatLong(position);

                  if (await amount != null) {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text('Estimated delivery and cost'),
                              content: Text(
                                  'Rs $amount' + '\n' + '$thirtyDaysFromNow'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Back'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    try {
                                      openCheckout();
                                    } catch (e) {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Something went wrong, Please try later",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 4,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }

                                    Navigator.pop(context, 'OK');
                                  },
                                  child: const Text('Create shipment'),
                                ),
                              ],
                            ));
                  }
                },
                child: const Text('Proceed'),
              ),
            ),
          ),
          // new Container(
          //     padding: const EdgeInsets.only(left: 150.0, top: 20.0),
          //     child: new ElevatedButton(
          //       child: const Text('Proceed'),
          //       onPressed: () {
          //         // Navigator.push(
          //         //   context,
          //         //   MaterialPageRoute(builder: (context) => Payment()),
          //         // );
          //         openCheckout();
          //       },
          //       //onPressed: null,
          //     )),
        ],
      ),
    );
  }
}
