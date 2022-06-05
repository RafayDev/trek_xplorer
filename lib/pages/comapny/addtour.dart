import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Addtour extends StatefulWidget {
  const Addtour({Key? key}) : super(key: key);

  @override
  State<Addtour> createState() => _AddtourState();
}

class _AddtourState extends State<Addtour> {
  //form key
  final _formKey = GlobalKey<FormState>();
  //variable which stores textfield data
  var date = "";
  var details = "";
  var duration = "";
  final email = FirebaseAuth.instance.currentUser!.email;
  var imgUrl = "";
  var location = "";
  var title = "";
  var price = "";
  var enddate = "";
  //controllers for variables
  final dateController = TextEditingController();
  final detailsController = TextEditingController();
  final durationController = TextEditingController();
  final imgUrlController = TextEditingController();
  final locationController = TextEditingController();
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final enddateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  // child:,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text("Add Tour Here...",
                      style: TextStyle(
                          color: Color.fromARGB(255, 129, 0, 155),
                          fontWeight: FontWeight.bold,
                          fontSize: 25)),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(
                      labelText: 'Title: ',
                      labelStyle: TextStyle(fontSize: 20.0),
                      border: OutlineInputBorder(),
                      errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 15),
                    ),
                    controller: titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Tour tiltle';
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
                      labelText: 'Location: ',
                      labelStyle: TextStyle(fontSize: 20.0),
                      border: OutlineInputBorder(),
                      errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 15),
                    ),
                    controller: locationController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Tour Location';
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
                      labelText: 'Start Date: YYYY-MM-DD',
                      labelStyle: TextStyle(fontSize: 20.0),
                      border: OutlineInputBorder(),
                      errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 15),
                    ),
                    controller: dateController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Date';
                      } else if (!value.contains('-')) {
                        return 'Please Enter Valid Date Format';
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
                      labelText: 'End Date: YYYY-MM-DD',
                      labelStyle: TextStyle(fontSize: 20.0),
                      border: OutlineInputBorder(),
                      errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 15),
                    ),
                    controller: enddateController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter End Date';
                      } else if (!value.contains('-')) {
                        return 'Please Enter Valid Date Format';
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
                      labelText: 'Details: ',
                      labelStyle: TextStyle(fontSize: 20.0),
                      border: OutlineInputBorder(),
                      errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 15),
                    ),
                    controller: detailsController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Tour Details';
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
                      labelText: 'Price: ',
                      labelStyle: TextStyle(fontSize: 20.0),
                      border: OutlineInputBorder(),
                      errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 15),
                    ),
                    controller: priceController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Tour Price';
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
                              title = titleController.text;
                              location = locationController.text;
                              date = dateController.text;
                              enddate = enddateController.text;
                              details = detailsController.text;
                              price = priceController.text;
                            });
                            // registration();
                            // fetchdata();
                            //  registration();
                            //  addUser();
                          }
                        },
                        child: Text(
                          'Add Tour',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
