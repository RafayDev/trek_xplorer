//import 'dart:html';
//import 'dart: io' as i;
//import 'dart:html';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:io';

import '../../api/firebase_api.dart';

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
  var img = "";
  File? _image;
  //controllers for variables
  final dateController = TextEditingController();
  final detailsController = TextEditingController();
  final durationController = TextEditingController();
  final imgUrlController = TextEditingController();
  final locationController = TextEditingController();
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final enddateController = TextEditingController();
  void clear() {
    dateController.clear();
    detailsController.clear();
    durationController.clear();
    imgUrlController.clear();
    locationController.clear();
    titleController.clear();
    priceController.clear();
    enddateController.clear();
  }

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    // final path = image.files.single.path!;
    final imageTemporary = File(image.path);
    setState(() {
      this._image = imageTemporary;
    });

    // setState(() {
    //   _image = image as File?;
    //   img = image.toString();
    //   print('Image Path $image');
    // });
  }

  Future uploadPic(BuildContext context) async {
    if (_image == null) return;

    final fileName = basename(_image!.path);
    final destination = '$fileName';

    var task = FirebaseApi.uploadFile(destination, _image!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    setState(() {
      imgUrl = urlDownload;
    });

    //imgUrl = urlDownload;
    print('Download-Link: $imgUrl');
    addTour();
    clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.greenAccent,
        content: Text(
          "Tour Added Sucessfully",
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }

  CollectionReference tours = FirebaseFirestore.instance.collection('tours');

  addTour() async {
    return tours
        .add({
          'title': title,
          'location': location,
          'date': date,
          'duration': duration,
          'details': details,
          'price': price,
          'email': email,
          'imgUrl': imgUrl,
        })
        .then((value) => print('Tour Added'))
        .catchError((error) => print('Failed to Add Tour: $error'));
  }

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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: 100,
                              backgroundColor: Color(0xff476cfb),
                              child: ClipOval(
                                child: new SizedBox(
                                  width: 180.0,
                                  height: 180.0,
                                  child: (_image != null)
                                      ? Image.file(
                                          _image!,
                                          fit: BoxFit.fill,
                                        )
                                      : Image.network(
                                          "https://firebasestorage.googleapis.com/v0/b/trek-xplorer.appspot.com/o/no%20image.png?alt=media&token=d8f6a74b-8b34-466b-a2e8-4447824b389c",
                                          fit: BoxFit.fill,
                                        ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 60.0),
                            child: IconButton(
                              icon: Icon(
                                FontAwesomeIcons.camera,
                                size: 30.0,
                              ),
                              onPressed: () {
                                getImage();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
                      labelText: 'Date: YYYY-MM-DD',
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
                      labelText: 'Duration: ',
                      labelStyle: TextStyle(fontSize: 20.0),
                      border: OutlineInputBorder(),
                      errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 15),
                    ),
                    controller: durationController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Duration';
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
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              title = titleController.text;
                              location = locationController.text;
                              date = dateController.text;
                              duration = durationController.text;
                              details = detailsController.text;
                              price = priceController.text;
                            });
                            // registration();
                            // fetchdata();
                            //  registration();
                            //  addUser();

                            uploadPic(context);
                            // if (imgUrl != "") {
                            //   addTour();
                            // }
                            // addTour();
                            // if (imgUrl != "") {
                            //   addTour();
                            // }
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
