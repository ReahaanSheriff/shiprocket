import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:load/load.dart';
import 'package:swift/views/eachshipment.dart';

class UpdateShipment extends StatefulWidget {
  final String data;
  final String token;
  const UpdateShipment({Key? key, required this.token, required this.data})
      : super(key: key);

  @override
  _UpdateShipmentState createState() => _UpdateShipmentState();
}

class _UpdateShipmentState extends State<UpdateShipment> {
  final _formKey = GlobalKey<FormState>();
  var response, gjsonData, statusCode;

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
      uid,
      responseBody;
  var submitCode;
  var orderid = new TextEditingController();

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

  getShipmentForUpdate() async {
    final uri = Uri.parse(
        'http://reahaan.pythonanywhere.com/getshipment/${widget.data}');

    final headers = {'Authorization': 'Token ' + widget.token.toString()};
    try {
      response = await http.get(
        uri,
        headers: headers,
      );
      statusCode = response.statusCode;
      gjsonData = jsonDecode(response.body);

      print(statusCode);
      print(gjsonData['orderId']);
      setState(() {
        orderid.text = widget.data;
        fname.text = gjsonData['pname'].toString();
        fmobile.text = gjsonData['pmobile'].toString();
        pick.text = gjsonData['paddress'].toString();
        fromPinController.text = gjsonData['ppincode'].toString();
        fromcity.text = gjsonData['pcity'].toString();
        fromstate.text = gjsonData['pstate'].toString();
        fromcountry.text = gjsonData['pcountry'].toString();
        tname.text = gjsonData['dname'].toString();
        tmobile.text = gjsonData['dmobile'].toString();
        drop.text = gjsonData['daddress'].toString();
        toPinController.text = gjsonData['dpincode'].toString();
        tocity.text = gjsonData['dcity'].toString();
        tostate.text = gjsonData['dstate'].toString();
        tocountry.text = gjsonData['dcountry'].toString();
        prodname.text = gjsonData['productName'].toString();
        prodheight.text = gjsonData['height'].toString();
        prodlen.text = gjsonData['length'].toString();
        prodval.text = gjsonData['productValue'].toString();
        prodwidth.text = gjsonData['width'].toString();
        weightcontroller.text = gjsonData['weight'].toString();
      });
    } on Exception catch (e) {
      print("error on GetShipmentForUpdate function");
    }
  }

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
  }

  updateShipmentSubmit() async {
    final uri = Uri.parse(
        'http://reahaan.pythonanywhere.com/updateShipment/${widget.data}');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token ' + widget.token.toString()
    };
    Map<String, dynamic> body = {
      "orderId": orderid.text,
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
      "shippingPrice": gjsonData['shippingPrice'],
      "estimateDate": gjsonData['estimateDate']
    };
    String jsonBody = json.encode(body);
    var response;

    String responseBody;
    try {
      response = await http.put(
        uri,
        headers: headers,
        body: jsonBody,
      );
      submitCode = response.statusCode;
      responseBody = response.body;

      print(responseBody);

      //print(statusCode);
    } on Exception catch (e) {
      print("error on updateShipmentSubmit function");
    }
    return submitCode;
  }

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

  currentUser() async {
    final uri = Uri.parse('http://reahaan.pythonanywhere.com/currentuser/');
    final headers = {'Authorization': 'Token ' + widget.token.toString()};
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

  @override
  void initState() {
    super.initState();
    showLoadingDialog();
    currentUser();
    getShipmentForUpdate();
    Timer(Duration(seconds: 1), () {
      hideLoadingDialog();
    });
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    updateShipmentSubmit().then((value) {
      if (value == 200) {
        Fluttertoast.showToast(
            msg: "Updated Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 4,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    EachShipment(value: widget.data, token: widget.token)));
      } else {
        Fluttertoast.showToast(
            msg: "Error Updating",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 4,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update ${widget.data}"),
      ),
      body: Container(
        child: SingleChildScrollView(
            child: Form(
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
                controller: orderid,
                enabled: false,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  //hintText: 'Door no and Street Name',
                  labelText: 'Order Id',
                ),
              ),

              //Text('${fromAddress}'),

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
                  return value!.length < 10
                      ? 'Mobile must be of length 10'
                      : null;
                },
                decoration: const InputDecoration(
                  icon: const Icon(Icons.phone),
                  //hintText: 'Mobile No',
                  labelText: 'Mobile No',
                ),
              ),
              TextFormField(
                controller: pick,
                enabled: false,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  //hintText: 'Door no and Street Name',

                  labelText: 'Address',
                ),
              ),

              TextFormField(
                controller: fromPinController,
                enabled: false,
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
                  return value!.length < 6
                      ? 'Pincode must be of length 6'
                      : null;
                },
                decoration: const InputDecoration(
                  icon: const Icon(Icons.map),
                  //hintText: 'State',
                  labelText: 'Pincode',
                ),
              ),
              TextFormField(
                enabled: false,
                controller: fromcity,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.location_city),
                  // hintText: 'City',
                  labelText: 'City',
                ),
              ),
              TextFormField(
                enabled: false,
                controller: fromstate,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.map),
                  //hintText: 'State',
                  labelText: 'State',
                ),
              ),

              TextFormField(
                enabled: false,
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
                  return value!.length < 10
                      ? 'Mobile must be of length 10'
                      : null;
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
                enabled: false,
                controller: drop,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  //hintText: 'Door no and Street Name',
                  labelText: 'Address',
                ),
              ),

              TextFormField(
                enabled: false,
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
                  return value!.length < 6
                      ? 'Pincode must be of length 6'
                      : null;
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
                enabled: false,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.location_city),
                  // hintText: 'City',
                  labelText: 'City',
                ),
              ),
              TextFormField(
                controller: tostate,
                enabled: false,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.map),
                  //hintText: 'State',
                  labelText: 'State',
                ),
              ),
              TextFormField(
                controller: tocountry,
                enabled: false,
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
                enabled: false,
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
                enabled: false,
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
                enabled: false,
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
                      enabled: false,
                      controller: prodlen,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
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
                      enabled: false,
                      controller: prodwidth,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
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
                      enabled: false,
                      controller: prodheight,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
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
              //            enabled: false,
              //           controller: txt,
              //           //controller: textEditingController,
              //           decoration: InputDecoration(
              //             icon: const Icon(Icons.attach_money),
              //             contentPadding: EdgeInsets.all(10),
              //             labelText: 'swift cost',
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
        )),
      ),
    );
  }
}
