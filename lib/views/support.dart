import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class Support extends StatefulWidget {
  const Support({Key? key}) : super(key: key);

  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
  final _formKey = GlobalKey<FormState>();
  var subjectcontroller = new TextEditingController();
  var bodycontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Support"),
      ),
      body: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: subjectcontroller,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    //hintText: 'Door no and Street Name',
                    labelText: 'Subject',
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: bodycontroller,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    //hintText: 'Door no and Street Name',
                    labelText: 'Share your query',
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: (() async {
                          final Email email = Email(
                            body: bodycontroller.text,
                            subject: subjectcontroller.text,
                            recipients: ['reahaansheriff@gmail.com'],
                            isHTML: false,
                          );
                          await FlutterEmailSender.send(email);
                        }),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text("Send Mail"),
                        )),
                  ),
                ),
              ])),
    );
  }

  @override
  void dispose() {
    super.dispose();
    bodycontroller.dispose();
    subjectcontroller.dispose();
  }
}
