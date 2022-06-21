import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trek_xplorer/pages/login.dart';

class Csignup extends StatefulWidget {
  const Csignup({Key? key}) : super(key: key);

  @override
  State<Csignup> createState() => _CsignupState();
}

class _CsignupState extends State<Csignup> {
  final _formKey = GlobalKey<FormState>();

  var email = "";
  var password = "";
  var confirmPassword = "";
  var companyname = "";
  var dtsnumber = "";
  var website = "";
  var whatsapp = "";
  var insta = "";
  var isOrg = "Yes";
  late bool api;
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final companynameController = TextEditingController();
  final dtsnumberController = TextEditingController();
  final websiteController = TextEditingController();
  final whatsappController = TextEditingController();
  final instaController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    companynameController.dispose();
    dtsnumberController.dispose();
    websiteController.dispose();
    whatsappController.dispose();
    instaController.dispose();
    super.dispose();
  }

  fetchdata() async {
    final response = await http.get(Uri.parse(
        'https://tousirmapi.herokuapp.com/getcompany/$companyname/$dtsnumber'));
    bool data = jsonDecode(response.body);
    // print(data);
    api = data;
    //  print(api);
    if (api == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            "Company Not Registered in Nadra",
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
        ),
      );
    }
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  addUser() async {
    if (api == true) {
      return users
          .add({
            'name': companyname,
            'email': email,
            'DtsNo': dtsnumber,
            'instaUsername': insta,
            'isOrg': isOrg,
            'whatsapp': whatsapp,
            'website': website
          })
          .then((value) => print('User Added'))
          .catchError((error) => print('Failed to Add user: $error'));
    }
  }

  registration() async {
    if (password == confirmPassword && api == true) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        print(userCredential);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Registered Successfully. Please Login..",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
        );
        // ignore: nullable_type_in_catch_clause
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print("Password Provided is too Weak");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Password Provided is too Weak",
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              ),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          print("Account Already exists");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Account Already exists",
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              ),
            ),
          );
        }
      }
    } else {
      print("Password and Confirm Password doesn't match");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            "Password and Confirm Password doesn't match",
            style: TextStyle(fontSize: 16.0, color: Colors.black),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Company Signup"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: 'Company Name: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: companynameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Company Name';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: 'DTS Number: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: dtsnumberController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter DTS Number';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: 'Email: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Email';
                    } else if (!value.contains('@')) {
                      return 'Please Enter Valid Email';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: 'Webiste Url: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: websiteController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Website Url';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: 'Instagram Username: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: instaController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Instagram Username';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: 'Whatsapp No.: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: whatsappController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Whatsapp No.';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Password';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Password';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, otherwise false.
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            email = emailController.text;
                            password = passwordController.text;
                            confirmPassword = confirmPasswordController.text;
                            companyname = companynameController.text;
                            dtsnumber = dtsnumberController.text;
                            website = websiteController.text;
                            insta = instaController.text;
                            whatsapp = whatsappController.text;
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
                          // registration();
                          fetchdata();
                          registration();
                          addUser();
                        }
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an Account? "),
                    TextButton(
                        onPressed: () => {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          Login(),
                                  transitionDuration: Duration(seconds: 0),
                                ),
                              )
                            },
                        child: Text('Login Here...'))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
