import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trek_xplorer/pages/login.dart';
import 'package:trek_xplorer/pages/user/dashboard.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  void initState() {
    getname();
    super.initState();
  }

  var newPassword = "";
  var name = "";
  // Create a text controller and use it to retrieve the current value
  // of the TextField.

  final newPasswordController = TextEditingController();
  var changeName = "";
  final changeNameController = TextEditingController();

  Future getname() async {
    var collection = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email);
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      //  var name = data['name'];
      //  var phone = data['phone'];
      name = data['name'];
    }
    setState(() {
      name = name;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    newPasswordController.dispose();
    super.dispose();
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  Future changename() {
    var doc = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: "$email")
        .get();
    return doc.then((value) {
      for (var doc in value.docs) {
        doc.reference.update({
          'name': changeName,
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
            Padding(padding: EdgeInsets.only(top: 50)),
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
                Text(
                  name,
                  style: TextStyle(fontSize: 25.0),
                ),
                Padding(padding: EdgeInsets.only(left: 100)),
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
                                        "Change Name",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextFormField(
                                        autofocus: false,
                                        // keyboardType: TextInputType.number,
                                        controller: changeNameController,
                                        decoration: InputDecoration(
                                          labelText: 'Name: ',
                                          labelStyle: TextStyle(fontSize: 20.0),
                                          // border: OutlineInputBorder(),
                                          icon: Icon(Icons.person),
                                          errorStyle: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 10),
                                        ),
                                        //controller: priceController,
                                      ),
                                      ElevatedButton.icon(
                                          onPressed: () async {
                                            setState(() {
                                              changeName =
                                                  changeNameController.text;
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              backgroundColor: Colors.white,
                                              content: Center(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                        padding: EdgeInsets.all(
                                                            200.0)),
                                                    Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        backgroundColor:
                                                            Colors.purple,
                                                      ),
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.all(
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
                                            await changename();
                                            await getname();
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor:
                                                    Colors.orangeAccent,
                                                content: Text(
                                                  'Your Name has been Changed !',
                                                  style:
                                                      TextStyle(fontSize: 18.0),
                                                ),
                                              ),
                                            );
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
            Padding(padding: EdgeInsets.only(top: 180)),
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
            ),
          ],
        ),
      ),
    );
  }
}
