import 'package:flutter/material.dart';
import 'package:shipping/views/payment.dart';

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
              icon: const Icon(Icons.map),
              //hintText: 'State',
              labelText: 'Pincode',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.location_city),
              //hintText: 'Country',
              labelText: 'Country',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.phone),
              //hintText: 'Mobile No',
              labelText: 'Mobile No',
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
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.map),
              //hintText: 'State',
              labelText: 'Pincode',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.phone),
              //hintText: 'Mobile No',
              labelText: 'Mobile No',
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
                    decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  labelText: 'H',
                )),
              ),
            ],
          ),
          new Container(
              padding: const EdgeInsets.only(left: 150.0, top: 20.0),
              child: new ElevatedButton(
                child: const Text('Proceed'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Payment()),
                  );
                },
                //onPressed: null,
              )),
        ],
      ),
    );
  }
}
