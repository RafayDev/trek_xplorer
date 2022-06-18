import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../../api/firebase_api.dart';

class UpdateTour extends StatefulWidget {
  final String id;
  const UpdateTour({Key? key, required this.id}) : super(key: key);

  @override
  State<UpdateTour> createState() => _UpdateTourState();
}

class _UpdateTourState extends State<UpdateTour> {
  File? _image;
  var imgUrl = "";
  bool isimg = false;
  final _formKey = GlobalKey<FormState>();

  // Updaing Tour Details
  CollectionReference tours = FirebaseFirestore.instance.collection('tours');
  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    // final path = image.files.single.path!;
    final imageTemporary = File(image.path);
    setState(() {
      this._image = imageTemporary;
      isimg = true;
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
    //update_tour();
  }

  Future<void> update_tour(
      id, title, price, date, duration, details, location, img) async {
    //uploadPic(context);
    return tours
        .doc(id)
        .update({
          'title': title,
          'price': price,
          'date': date,
          'duration': duration,
          'details': details,
          'location': location,
          'imgUrl': img
        })
        .then((value) => print('Tour Updated'))
        .catchError((error) => print("Failed to update tour: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Tour"),
      ),
      body: Form(
        key: _formKey,
        // Getting Specific Data by ID
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('tours')
                .doc(widget.id)
                .get(),
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                print('Something Went Wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              var data = snapshot.data!.data();
              var title = data!['title'];
              var price = data['price'];
              var date = data['date'];
              var duration = data['duration'];
              var details = data['details'];
              var location = data['location'];
              var imgUrl2 = data['imgUrl'];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      // child:,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text("Update Tour Here...",
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
                                              "$imgUrl2",
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
                        initialValue: title,
                        autofocus: false,
                        onChanged: (value) => title = value,
                        decoration: InputDecoration(
                          labelText: 'Title: ',
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
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
                        initialValue: location,
                        autofocus: false,
                        onChanged: (value) => location = value,
                        decoration: InputDecoration(
                          labelText: 'Location: ',
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
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
                        onChanged: (value) => date = value,
                        decoration: InputDecoration(
                          labelText: 'Date: YYYY-MM-DD',
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                        // onTap: () async {
                        //   DateTime? pickedDate = await showDatePicker(
                        //       context: context,
                        //       initialDate: DateTime.now(),
                        //       firstDate: DateTime(
                        //           2000), //DateTime.now() - not to allow to choose before today.
                        //       lastDate: DateTime(2101));

                        //   if (pickedDate != null) {
                        //     print(
                        //         pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        //     String formattedDate =
                        //         DateFormat('yyyy-MM-dd').format(pickedDate);
                        //     print(
                        //         formattedDate); //formatted date output using intl package =>  2021-03-16
                        //     //you can implement different kind of Date Format here according to your requirement

                        //     setState(() {
                        //       date = formattedDate;
                        //       context = pickedDate as BuildContext;
                        //     });
                        //   } else {
                        //     print("Date is not selected");
                        //   }
                        // },
                        initialValue: date,
                        //  readOnly: true,
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
                        initialValue: duration,
                        autofocus: false,
                        onChanged: (value) => duration = value,
                        decoration: InputDecoration(
                          labelText: 'Duration: ',
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
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
                        initialValue: details,
                        autofocus: false,
                        onChanged: (value) => details = value,
                        decoration: InputDecoration(
                          labelText: 'Details: ',
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
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
                        initialValue: price,
                        autofocus: false,
                        onChanged: (value) => price = value,
                        decoration: InputDecoration(
                          labelText: 'Price: ',
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
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
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // registration();
                                // fetchdata();
                                //  registration();
                                //  addUser();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
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
                                if (isimg == true) {
                                  await uploadPic(context);

                                  await update_tour(
                                      widget.id,
                                      title,
                                      price,
                                      date,
                                      duration,
                                      details,
                                      location,
                                      imgUrl);
                                } else {
                                  await update_tour(
                                      widget.id,
                                      title,
                                      price,
                                      date,
                                      duration,
                                      details,
                                      location,
                                      imgUrl2);
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                      "Tour Updated Sucessfully",
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                  ),
                                );
                                Navigator.pop(context);
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
                              'Update Tour',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
