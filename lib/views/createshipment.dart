import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:load/load.dart';

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
  final String value;
  const CreateShipment({
    Key? key,
    required this.value,
  }) : super(key: key);

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
              Container(child: PickupAddress(value: widget.value)),
            ],
          ),
        ));
  }
}

class PickupAddress extends StatefulWidget {
  final String value;
  const PickupAddress({
    Key? key,
    required this.value,
  }) : super(key: key);
  @override
  _PickupAddressState createState() => _PickupAddressState();
}

class _PickupAddressState extends State<PickupAddress>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  bool _isEnable = true;
  bool showAni = true;
  var fname = new TextEditingController();
  var fmobile = new TextEditingController();
  var tname = new TextEditingController();
  var tmobile = new TextEditingController();
  var prodname = new TextEditingController();
  var prodval = new TextEditingController();
  var weightcontroller = new TextEditingController();
  var prodlen = new TextEditingController();
  var prodwidth = new TextEditingController();
  var prodheight = new TextEditingController();
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
  var responseBody;
  var fromAddress = "",
      tolat,
      tolong,
      fromlat,
      fromlong,
      res,
      amount,
      estday,
      kms,
      cost,
      city,
      state,
      country,
      fcity,
      fstate,
      fcountry,
      thirtyDaysFromNow,
      distance,
      currentuserResponse,
      uid;

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
      pick.text =
          '${place.thoroughfare} ${place.subLocality} ${place.locality} ${place.administrativeArea} ${place.country}';
      // fromstate.text = fromcity.text = "";
      fromPinController.text = place.postalCode!;
      // fromcountry.text = "";
      getFromPincodeData();
      setState(() {});
      print(place.thoroughfare);
      // print(place);

      // print(position.latitude);
      // print(position.longitude);
      // print(tolat);
      // print(tolong);
    } on Exception catch (e) {
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
          msg: "hey",
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
  }

  // createShipmentApi() async {
  //   try {
  //     var response =
  //         await http.post(Uri.parse("http://192.168.225.107:8000/"), headers: {
  //       "Accept": "application/json",
  //       "Content-Type": "application/x-www-form-urlencoded"
  //     }, body: {
  //       "orderId": "ord12345679",
  //       // "created": "2021-11-06T07:18:08.940754Z",
  //       "pname": "reahaan",
  //       "pmobile": "9868724896",
  //       "paddress": "86, Vrindavan Garden, (Near Janakpuri Park),Sahibabad",
  //       "ppincode": "201005",
  //       "pcity": "Ghaziabad",
  //       "pstate": "Uttar Pradesh",
  //       "pcountry": "India",
  //       "dname": "sheriff",
  //       "dmobile": "9620957490",
  //       "daddress":
  //           "Mulencheriparambil house, Valavanangadi, padiyoor P O, Thrissur, kerala,680688",
  //       "dcity": "Thrissur",
  //       "dstate": "Kerala",
  //       "dpincode": "680688",
  //       "dcountry": "India",
  //       "productName": "books",
  //       "productValue": "500",
  //       "weight": "0.5",
  //       "length": "22",
  //       "width": "14",
  //       "height": "3",
  //       "shippingPrice": "56",
  //       "estimateDate": "20/11/2021"
  //     });
  //     print("created");
  //     print(response.body);
  //   } catch (e) {
  //     print("Error in create shipment");
  //     print(e);
  //   }
  // }

// End create shipment api

//Razor pay config

  late Razorpay razorpay;
  TextEditingController textEditingController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    currentUser();
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
    makePostRequest();
    //makePostRequestTracking();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewShipments(value: widget.value)));

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
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) =>  Home(value: widget.value)),
    // );
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
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => Home(value: token)),
    // );
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

  Future<void> getAddressFromLatLong(Position position) async {
    //showAni = true;
    final toqueryParameters = {
      'access_key': env["ACCESS_KEY"],
      'query': '${drop.text} ${toPinController.text}',
    };

    final fromqueryParameters = {
      'access_key': env["ACCESS_KEY"],
      'query': '${pick.text} ${fromPinController.text}',
    };

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
    } on Exception catch (e) {
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
        Fluttertoast.showToast(
            msg: "Weight cannot be in deciaml",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 4,
            backgroundColor: Colors.yellow,
            textColor: Colors.black,
            fontSize: 16.0);
      }
      return amount;
    }

    kms = price();
    print(kms);

    // Date
    try {
      var formatter = new DateFormat('dd-MM-yyyy');
      if (estday != null) {
        thirtyDaysFromNow =
            formatter.format(DateTime.now().add(new Duration(days: estday)));

        print(thirtyDaysFromNow);

        // end date
        setState(() {
          thirtyDaysFromNow;
        });
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: "error on date func",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
          fontSize: 16.0);
      print(e);
    }
  }

// end of calculation of price and date
  var ordid = generateOrderId();

// Create Tracking shipment Api
  Future<void> makePostRequestTracking() async {
    final uri =
        Uri.parse('http://reahaan.pythonanywhere.com/trackAllShipment/');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token ' + widget.value.toString()
    };
    Map<String, dynamic> body = {
      "shipment": ordid,
    };
    String jsonBody = json.encode(body);
    //final encoding = Encoding.getByName('utf-8');
    var response;
    int statusCode;
    String responseBody;
    try {
      response = await http.post(
        uri,
        headers: headers,
        body: jsonBody,
        //encoding: encoding,
      );
      statusCode = response.statusCode;
      responseBody = response.body;
      print(responseBody);
      print(statusCode);
    } on Exception catch (e) {
      print("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu");
      print("error on post request tracking");
      print("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu");
      Fluttertoast.showToast(
          msg: "error on post request tracking",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }

// End of tracking all shipment api

// Get Current User

  currentUser() async {
    final uri = Uri.parse('http://reahaan.pythonanywhere.com/currentuser/');
    final headers = {'Authorization': 'Token ' + widget.value.toString()};
//String jsonBody = json.encode(body);
    //final encoding = Encoding.getByName('utf-8');

    try {
      currentuserResponse = await http.get(
        uri,
        headers: headers,
        //body: jsonBody,
        //encoding: encoding,
      );

      responseBody = jsonDecode(currentuserResponse.body);
      print(responseBody['id']);
      print(responseBody);
      setState(() {
        uid = responseBody['id'];
      });
      //print(responseBody['id']);
    } on Exception catch (e) {
      print(e);
    }
    return responseBody['id'];
  }

// End of current user
// Create shipment Api

  makePostRequest() async {
    final uri = Uri.parse('http://reahaan.pythonanywhere.com/');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token ' + widget.value.toString()
    };

    Map<String, dynamic> body = {
      "orderId": ordid,
      "user_id_id": uid,
      "pname": fname.text,
      "pmobile": fmobile.text,
      "paddress": pick.text,
      "ppincode": fromPinController.text,
      "pcity": fromcity.text,
      "pstate": fromstate.text,
      "pcountry": fromcountry.text,
      "dname": tname.text,
      "dmobile": tmobile.text,
      "daddress": drop.text,
      "dcity": tocity.text,
      "dstate": tostate.text,
      "dpincode": toPinController.text,
      "dcountry": tocountry.text,
      "productName": prodname.text,
      "productValue": prodval.text,
      "weight": weightcontroller.text,
      "length": prodlen.text,
      "width": prodwidth.text,
      "height": prodheight.text,
      "shippingPrice": amount,
      "estimateDate": thirtyDaysFromNow
    };
    var jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    var response;
    var statusCode;
    var responseBody;
    try {
      response = await http.post(
        uri,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );
      statusCode = response.statusCode;
      responseBody = jsonDecode(response.body);
      //print("rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      //print('userid ' + '$uid');
      makePostRequestTracking();
      print(responseBody);
      print(statusCode);
    } on Exception catch (e) {
      print("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu");
      print("error on post request");
      print("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu");
      Fluttertoast.showToast(
          msg: "error on post request",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
          fontSize: 16.0);
      print(e);
    }
  }

  // end Create shipment Api

  // form validation
// ignore: unused_element
  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    Position position = await _getGeoCostPosition();
    getAddressFromLatLong(position);

    _formKey.currentState!.save();
    showLoadingDialog();

    Timer(Duration(seconds: 3), () {
      if (amount != null && thirtyDaysFromNow != null) hideLoadingDialog();
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Estimated delivery and cost'),
                content: Text('Rs $amount' + '\n' + '$thirtyDaysFromNow'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'Cancel');
                    },
                    child: const Text('Back'),
                  ),
                  TextButton(
                    onPressed: () {
                      try {
                        openCheckout();
                      } catch (e) {
                        Fluttertoast.showToast(
                            msg: "Something went wrong, Please try later",
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
    });
  }

  // end form validation

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
            initialValue: ordid,
            //controller: order.text,
            readOnly: true,
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              //hintText: 'Door no and Street Name',
              labelText: 'Order Id',
            ),
          ),

          //Text('${fromAddress}'),

          Row(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    showLoadingDialog();
                    Position position = await _getGeoCostPosition();
                    cost =
                        'Lat: ${position.latitude} , Long: ${position.longitude}';
                    getCurrentAddress(position);
                    Timer(Duration(seconds: 3), () {
                      hideLoadingDialog();
                    });
                  },
                  child: Text('Get current location')),
              Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
              ElevatedButton(
                  onPressed: () {
                    //fromAddress = "";
                    pick.text = fromPinController.text =
                        fromcity.text = fromstate.text = fromcountry.text = "";
                    _isEnable = true;
                    setState(() {});
                  },
                  child: Text("Clear pickup Address")),
            ],
          ),

          TextFormField(
            controller: fname,
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              //hintText: 'Door no and Street Name',
              labelText: 'Name',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Name should not be empty!';
              }
              return null;
            },
          ),
          TextFormField(
            controller: fmobile,
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
              showLoadingDialog();
              setState(() {
                getFromPincodeData();
              });
              Timer(Duration(seconds: 3), () {
                hideLoadingDialog();
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
            controller: tname,
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              //hintText: 'Door no and Street Name',
              labelText: 'Name',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Name should not be empty!';
              }
              return null;
            },
          ),
          TextFormField(
            controller: tmobile,
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
              showLoadingDialog();
              setState(() {
                getToPincodeData();
              });
              Timer(Duration(seconds: 3), () {
                hideLoadingDialog();
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
            controller: prodname,
            decoration: const InputDecoration(
              icon: const Icon(Icons.topic),
              //hintText: 'Country',
              labelText: 'Product Name',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Product name should not be empty!';
              }
              return null;
            },
          ),
          TextFormField(
            controller: prodval,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              icon: const Icon(Icons.price_change),
              //hintText: 'Country',
              labelText: 'Value of Product',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Product value should not be empty!';
              }
              return null;
            },
          ),
          TextFormField(
            controller: weightcontroller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              icon: const Icon(Icons.monitor_weight),
              //hintText: 'Mobile No',
              labelText: 'Weight (Kg)',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Product weight should not be empty!';
              } else if (num.parse(value) > 5) {
                return 'Product weight should not be greater than 5';
              }
              return null;
            },
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Flexible(
                child: new TextFormField(
                  controller: prodlen,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    icon: const Icon(Icons.add_chart),
                    contentPadding: EdgeInsets.all(10),
                    labelText: 'L (cm)',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Length should not be empty!';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              new Flexible(
                child: new TextFormField(
                  controller: prodwidth,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    labelText: 'W (cm)',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Width should not be empty!';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              new Flexible(
                child: new TextFormField(
                  controller: prodheight,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    labelText: 'H (cm)',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Height should not be empty!';
                    }
                    return null;
                  },
                ),
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
          //  Navigator.push(
          //             context,
          //             MaterialPageRoute(builder: (context) => Payment()))

          new Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 150.0),
              child: ElevatedButton(
                onPressed: () async {
                  _submit();
                  // Position position = await _getGeoCostPosition();
                  // getAddressFromLatLong(position);

                  //   showLoadingDialog();

                  //   if (amount != null) {
                  //     hideLoadingDialog();
                  //     showDialog<String>(
                  //         context: context,
                  //         builder: (BuildContext context) => AlertDialog(
                  //               title: const Text('Estimated delivery and cost'),
                  //               content: Text(
                  //                   'Rs $amount' + '\n' + '$thirtyDaysFromNow'),
                  //               actions: <Widget>[
                  //                 TextButton(
                  //                   onPressed: () {
                  //                     showAni = false;
                  //                     print(showAni);
                  //                     setState(() {});
                  //                     Navigator.pop(context, 'Cancel');
                  //                   },
                  //                   child: const Text('Back'),
                  //                 ),
                  //                 TextButton(
                  //                   onPressed: () {
                  //                     try {
                  //                       openCheckout();
                  //                     } catch (e) {
                  //                       Fluttertoast.showToast(
                  //                           msg:
                  //                               "Something went wrong, Please try later",
                  //                           toastLength: Toast.LENGTH_SHORT,
                  //                           gravity: ToastGravity.CENTER,
                  //                           timeInSecForIosWeb: 4,
                  //                           backgroundColor: Colors.red,
                  //                           textColor: Colors.white,
                  //                           fontSize: 16.0);
                  //                     }

                  //                     Navigator.pop(context, 'OK');
                  //                   },
                  //                   child: const Text('Create shipment'),
                  //                 ),
                  //               ],
                  //             ));
                  //  }
                },
                child: const Text('Proceed'),
              ),
            ),
          ),

          // new Container(
          //   child: ElevatedButton(
          //     child: Text("current user"),
          //     onPressed: () {
          //       currentUser();
          //     },
          //   ),
          // ),

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
