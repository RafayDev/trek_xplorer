import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'viewtour.dart';

class Cdashboard extends StatefulWidget {
  const Cdashboard({Key? key}) : super(key: key);
  @override
  State<Cdashboard> createState() => _CdashboardState();
}

// email = "";
var name = "";
int count = 0;
var dts = "";

class _CdashboardState extends State<Cdashboard> {
  void initState() {
    var email = FirebaseAuth.instance.currentUser!.email;
    getname();
    getcount();
    //tours();
    super.initState();
  }

  Future getcount() async {
    var collection = FirebaseFirestore.instance
        .collection('tours')
        .where('email', isEqualTo: "$email");
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      //  var name = data['name'];
      //  var phone = data['phone'];
      // name = data['name'];
      // setState(() {
      //   count = count + 1;
      //   print(count);
      // });

      //  count = count + 1;
    }
  }

  Future getname() async {
    var collection = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: "$email");
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      //  var name = data['name'];
      //  var phone = data['phone'];
      name = data['name'];
      dts = data['DtsNo'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 231, 170, 241),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 50)),
          Wrap(
            children: [
              // Padding(padding: EdgeInsets.fromLTRB(0, 100, 0, 0)),
              Padding(padding: EdgeInsets.all(15)),
              Column(
                children: [
                  Container(
                      height: 100,
                      width: 300,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Color.fromARGB(255, 231, 170, 241),
                        child: Column(
                          children: [
                            Wrap(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Wrap(
                                    children: [
                                      Padding(padding: EdgeInsets.all(10)),
                                      Text(
                                        'Welcome,',
                                        style: TextStyle(
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                // Icon(Icons.back_hand_sharp),
                              ],
                            ),
                            Text(
                              name,
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),
                  Container(
                      height: 100,
                      width: 300,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Color.fromARGB(255, 231, 170, 241),
                        child: Column(
                          children: [
                            Wrap(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Wrap(
                                    children: [
                                      Padding(padding: EdgeInsets.all(10)),
                                      Text(
                                        'DTS No.',
                                        style: TextStyle(
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                // Icon(Icons.back_hand_sharp),
                              ],
                            ),
                            Text(
                              "$dts",
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
