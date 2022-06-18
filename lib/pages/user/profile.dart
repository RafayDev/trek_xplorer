import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../login.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final email = FirebaseAuth.instance.currentUser!.email;
  final creationTime = FirebaseAuth.instance.currentUser!.metadata.creationTime;

  User? user = FirebaseAuth.instance.currentUser;

  verifyEmail() async {
    if (user != null && !user!.emailVerified) {
      await user!.sendEmailVerification();
      print('Verification Email has been sent');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            'Verification Email has been sent',
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Verification'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                  (route) => false);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 380,
              width: 380,
              child: Card(
                color: Color.fromARGB(224, 247, 192, 237),
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.all(30)),
                    Icon(
                      FontAwesomeIcons.userXmark,
                      size: 100,
                      color: Color.fromARGB(255, 255, 17, 0),
                    ),
                    // Text(
                    //   '🚫',
                    //   style: TextStyle(fontSize: 100.0),
                    // ),
                    Padding(padding: EdgeInsets.all(10)),
                    Text(
                      'Your Email is not Verfied',
                      style: TextStyle(fontSize: 25.0),
                    ),
                    Text(
                      'Please Verify your Email',
                      style: TextStyle(fontSize: 25.0),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    ElevatedButton.icon(
                      icon: Icon(Icons.verified_user),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      onPressed: () => verifyEmail(),
                      label: Text('Verify Email'),
                    ),
                  ],
                ),
              ),
            ),
            // Padding(padding: EdgeInsets.fromLTRB(0, 100, 0, 0)),
          ],
        ),
      ),
    );
  }
}
