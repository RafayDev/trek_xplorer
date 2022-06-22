import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trek_xplorer/pages/login.dart';

class Csetting extends StatefulWidget {
  Csetting({Key? key}) : super(key: key);

  @override
  _CsettingState createState() => _CsettingState();
}

class _CsettingState extends State<Csetting> {
  final _formKey = GlobalKey<FormState>();
  void initState() {
    getwhatsapp();
    super.initState();
  }

  var whatsapp = "";
  var newPassword = "";
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  var changeWhatsapp = "";
  final changeWhatsappController = TextEditingController();
  final newPasswordController = TextEditingController();
  Future getwhatsapp() async {
    var collection = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email);
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      //  var name = data['name'];
      //  var phone = data['phone'];
      whatsapp = data['whatsapp'];
    }
    setState(() {
      whatsapp = whatsapp;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    newPasswordController.dispose();
    super.dispose();
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  Future changewhatsapp() {
    var doc = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
    return doc.then((value) {
      for (var doc in value.docs) {
        doc.reference.update({
          'whatsapp': changeWhatsapp,
        });
      }
    });
  }

  changePassword() async {
    try {
      await currentUser!.updatePassword(newPassword);
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            'Your Password has been Changed. Login again !',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: ListView(
          children: [
            Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: TextFormField(
                autofocus: false,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password: ',
                  hintText: 'Enter New Password',
                  labelStyle: TextStyle(fontSize: 20.0),
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15),
                ),
                controller: newPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Password';
                  }
                  return null;
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, otherwise false.
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    newPassword = newPasswordController.text;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.white,
                    content: Center(
                      child: Column(
                        children: [
                          Padding(padding: EdgeInsets.all(200.0)),
                          Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.purple,
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(10.0)),
                          Text(
                            "Please Wait...",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.purple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
                  changePassword();
                }
              },
              child: Text(
                'Change Password',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 100)),
            Row(
              children: [
                Wrap(
                  children: [
                    Icon(Icons.whatsapp),
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Text(
                      whatsapp,
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(left: 50)),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 16,
                                child: Container(
                                  height: 200,
                                  width: 1200,
                                  child: Column(
                                    children: <Widget>[
                                      Icon(Icons.edit,
                                          size: 40, color: Colors.purple),
                                      Text(
                                        "Change Whatsapp Number",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextFormField(
                                        autofocus: false,
                                        keyboardType: TextInputType.phone,
                                        controller: changeWhatsappController,
                                        decoration: InputDecoration(
                                          labelText:
                                              'Whatsapp: e.g. +92********** ',
                                          labelStyle: TextStyle(fontSize: 20.0),
                                          // border: OutlineInputBorder(),
                                          icon: Icon(Icons.whatsapp),
                                          errorStyle: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 10),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Enter Whatsapp No.';
                                          } else if (!value.contains('+')) {
                                            return 'Please Enter Valid No.';
                                          }
                                          return null;
                                        },
                                        //controller: priceController,
                                      ),
                                      ElevatedButton.icon(
                                          onPressed: () async {
                                            if (changeWhatsappController.text ==
                                                "") {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  backgroundColor: Colors.red,
                                                  content: Text(
                                                    'Please Enter Whatsapp !',
                                                    style: TextStyle(
                                                        fontSize: 18.0),
                                                  ),
                                                ),
                                              );
                                            }
                                            if (changeWhatsappController.text !=
                                                "") {
                                              setState(() {
                                                changeWhatsapp =
                                                    changeWhatsappController
                                                        .text;
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                backgroundColor: Colors.white,
                                                content: Center(
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  200.0)),
                                                      Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          backgroundColor:
                                                              Colors.purple,
                                                        ),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10.0)),
                                                      Text(
                                                        "Please Wait...",
                                                        style: TextStyle(
                                                          fontSize: 20.0,
                                                          color: Colors.purple,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ));
                                              await changewhatsapp();
                                              await getwhatsapp();
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  backgroundColor:
                                                      Colors.orangeAccent,
                                                  content: Text(
                                                    'Your Whatsapp Number has been Changed !',
                                                    style: TextStyle(
                                                        fontSize: 18.0),
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          icon: Icon(Icons.edit),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.blue),
                                          label: Text("Change"))
                                    ],
                                  ),
                                ));
                          });
                    },
                    icon: Icon(Icons.edit)),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 150)),
            Wrap(
              children: [
                Padding(padding: EdgeInsets.only(left: 120)),
                ElevatedButton(
                  onPressed: () async => {
                    await FirebaseAuth.instance.signOut(),
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                        (route) => false)
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
