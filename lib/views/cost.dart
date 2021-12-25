import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:load/load.dart';
import 'package:vector_math/vector_math.dart' as vec;

class Cost extends StatefulWidget {
  const Cost({Key? key}) : super(key: key);

  @override
  _CostState createState() => _CostState();
}

class _CostState extends State<Cost> {
  String fromAddress = 'search';
  String toAddress = "";
  String toAddressText = "";
  var distance;
  var tolat;
  var tolong;
  var res;
  var weightcontroller = new TextEditingController();
  var amount, estday;
  var kms = 0;
  var destaddresscontroller = new TextEditingController();
  var pickaddresscontroller = new TextEditingController();
  var fromlat, fromlong;

  // Future<Position> _getGeoCostPosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   // Test if Cost services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Cost services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the Cost services.
  //     await Geolocator.openLocationSettings();
  //     return Future.error('Cost services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now.
  //       return Future.error('Cost permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     return Future.error(
  //         'Cost permissions are permanently denied, we cannot request permissions.');
  //   }

  //   // When we reach here, permissions are granted and we can
  //   // continue accessing the position of the device.
  //   return await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  // }

  // Future destinationLatLong() async {
  //   final queryParameters = {
  //     'access_key': '37886c9865633759643c3e4bc7f048a1',
  //     'query': '${addresscontroller.text}',
  //   };

  //   var response = await http
  //       .get(Uri.http("api.positionstack.com", "/v1/forward", queryParameters));
  //   var jsonData = jsonDecode(response.body);

  //   // for (var i in jsonData) {
  //   //   print(i);
  //   //   // print(i["data"][0]["latitude"]);
  //   //   // print(i["data"][0]['longitude']);
  //   // }
  //   tolat = jsonData["data"][0]["latitude"];
  //   tolong = jsonData["data"][0]["lonitude"];
  //   //print(jsonData["data"][0]["latitude"]);
  //   //print(jsonData["data"][0]["longitude"]);
  //   setState(() {
  //     tolat;
  //     tolong;
  //   });
  //   //return ([tolat, tolong]);
  // }
//   Future<void> getCurrentAddress(Position position) async {
//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(position.latitude, position.longitude);
// //print(placemarks);
//     Placemark place = placemarks[1];
//     fromAddress =
//         '${place.thoroughfare}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
//     setState(() {});
//     print(place);

//     print(position.latitude);
//     print(position.longitude);
//     print(tolat);
//     print(tolong);
//   }

  Future<void> getAddressFromLatLong() async {
    final toqueryParameters = {
      'access_key': env["ACCESS_KEY"],
      'query': '${destaddresscontroller.text}',
    };

    final fromqueryParameters = {
      'access_key': env["ACCESS_KEY"],
      'query': '${pickaddresscontroller.text}',
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
      print(lat1);
      //position.latitude;
      var lng1 = fromlong;
      print(lng1);
      //position.longitude;
      var lat2 = tolat;
      print(lat2);
      var lng2 = tolong;
      print(lng2);
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
      if (result != null) {
        if (result.isNaN) {
          return 0;
        } else {
          print(result);
          return result;
        }
      }
      return 0;
    }

    try {
      res = data();
    } on Exception catch (e) {
      print(e);
    }

    print("-----------------------");
    if (res.isNaN) {
      print("double");
    } else {
      print(res);
    }

    print("-----------------------");
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
      return amount;
    }

    kms = price();
    print("----------------------- amount-------");
    print(kms);
    setState(() {
      kms;
    });

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
    // try {
    //   var formatter = new DateFormat('dd-MM-yyyy');

    //   var thirtyDaysFromNow =
    //       formatter.format(DateTime.now().add(new Duration(days: estday)));

    //   print(thirtyDaysFromNow);

    //   // end date
    //   setState(() {});
    // } on Exception catch (e) {
    //   print(e);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculate Price"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Calculate Shipment Price',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),

              //Text('${fromAddress}'),
              // ElevatedButton(
              //     onPressed: () async {
              //       Position position = await _getGeoCostPosition();
              //       Cost =
              //           'Lat: ${position.latitude} , Long: ${position.longitude}';
              //       getCurrentAddress(position);
              //     },
              //     child: Text('Get Address')),
              TextFormField(
                  //initialValue: fromAddress,
                  controller: pickaddresscontroller,
                  onFieldSubmitted: (String str) {
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    labelText: 'Pickup Address with pincode',
                  )),
              TextFormField(
                  //initialValue: fromAddress,
                  controller: destaddresscontroller,
                  onFieldSubmitted: (String str) {
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    labelText: 'Destination Address with pincode',
                  )),
              TextFormField(
                controller: weightcontroller,
                decoration: const InputDecoration(
                  labelText: 'Weight in kg eg (0.5)',
                ),
                keyboardType: TextInputType.numberWithOptions(),
              ),
              //Text('Distance in kms ${res}'),
              SizedBox(
                height: 10,
              ),
              Text('Total expected shipping cost $kms'),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (pickaddresscontroller.text != "" &&
                        pickaddresscontroller.text.contains(RegExp(r'[0-9]')) &&
                        destaddresscontroller.text != "" &&
                        destaddresscontroller.text.contains(RegExp(r'[0-9]')) &&
                        weightcontroller.text != "") {
                      showLoadingDialog();
                      Timer(Duration(seconds: 1), () {
                        hideLoadingDialog();
                      });

                      getAddressFromLatLong();
                    } else {
                      Fluttertoast.showToast(
                          msg: "Fields cannot be empty or recheck your address",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 4,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                    //Position position = await _getGeoCostPosition();
                  },
                  child: Text("Get Price"))
            ],
          ),
        ),
      ),
    );
  }
}
