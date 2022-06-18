import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trek_xplorer/pages/comapny/update_tour.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

String? email = FirebaseAuth.instance.currentUser!.email;

class _FavoritesState extends State<Favorites> {
  void initState() {
    var email = FirebaseAuth.instance.currentUser!.email;
    super.initState();
  }

  var whatsapp = "";
  final Stream<QuerySnapshot> favoritesStream = FirebaseFirestore.instance
      .collection('favorites')
      .where('email', isEqualTo: "$email")
      .snapshots();

  // For Deleting Tour
  // CollectionReference favorite =
  //     FirebaseFirestore.instance.collection('favorites');
  // addfavorite(
  //     title, imgUrl, location, date, duration, price, details, id) async {
  //   CollectionReference favorite =
  //       await FirebaseFirestore.instance.collection('favorites');
  //   return favorite
  //       .doc(id)
  //       .set({
  //         'title': title,
  //         'location': location,
  //         'date': date,
  //         'duration': duration,
  //         'details': details,
  //         'price': price,
  //         'email': email,
  //         'imgUrl': imgUrl,
  //       })
  //       .then((value) => print('Tour Added'))
  //       .catchError((error) => print('Failed to Add Tour: $error'));
  // }
  // For Deleting Tour
  CollectionReference favorites =
      FirebaseFirestore.instance.collection('favorites');

  Future<void> deletefavorite(id) {
    // print("User Deleted $id");
    return favorites
        .doc(id)
        .delete()
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                "Deleted from Favorite Sucessfully",
                style: TextStyle(fontSize: 20.0),
              ),
            )));

    //  .catchError((error) => print('Failed to Delete Tour: $error'));
  }

  getwhatsapp(company_email) async {
    var collection = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: "$company_email");
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      //  var name = data['name'];
      //  var phone = data['phone'];
      whatsapp = data['whatsapp'];
    }
  }

  openwhatsapp(company_email) async {
    await getwhatsapp(company_email);
    final link = WhatsAppUnilink(
      phoneNumber: whatsapp,
      text: "Hey! I'm inquiring about the tour listing",
    );
    // Convert the WhatsAppUnilink instance to a string.
    // Use either Dart's string interpolation or the toString() method.
    // The "launch" method is part of "url_launcher".
    await launch('$link');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: favoritesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print('Something went Wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List storedocs = [];
          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            storedocs.add(a);
            a['id'] = document.id;
          }).toList();
          if (storedocs.length == 0) {
            return Center(
              child: Text("No Tours Added By You in Favorites"),
            );
          }
          return ListView(
            children: [
              for (var i = 0; i < storedocs.length; i++) ...[
                Container(
                  height: 380,
                  width: 100,
                  child: Card(
                    color: Color.fromARGB(225, 241, 116, 221),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            storedocs[i]['imgUrl'],
                            width: 390,
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                storedocs[i]['title'],
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .apply(fontSizeFactor: 2.0),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(10.0)),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Wrap(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    storedocs[i]['location'],
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .apply(fontSizeFactor: 1.5),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        100.0, 0.0, 0.0, 0.0),
                                  ),
                                  Icon(
                                    Icons.date_range,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    storedocs[i]['date'],
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .apply(fontSizeFactor: 1.5),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Wrap(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                                  ),
                                  Text(
                                    "Duration: " +
                                        storedocs[i]['duration'] +
                                        " Days",
                                    //label: " Days",
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .apply(fontSizeFactor: 1.5),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        20.0, 0.0, 0.0, 0.0),
                                  ),
                                  Icon(
                                    Icons.attach_money,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    storedocs[i]['price'] + " Rs",
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .apply(fontSizeFactor: 1.5),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Wrap(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                                  ),
                                  Text(
                                    storedocs[i]['details'],
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .apply(fontSizeFactor: 1.5),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
                            Row(
                              //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                ),

                                ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0),
                                      ),
                                    ),
                                    icon: Icon(Icons.heart_broken_outlined),
                                    onPressed: () async {
                                      deletefavorite(storedocs[i]['id']);
                                    },
                                    label: Text("Delete Favorite")),
                                Padding(padding: EdgeInsets.all(10.0)),
                                ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0),
                                      ),
                                    ),
                                    icon: Icon(Icons.whatsapp),
                                    onPressed: () {
                                      // deleteUser(storedocs[i]['id']);
                                      openwhatsapp(
                                          storedocs[i]['company_email']);
                                    },
                                    label: Text("Contact")),
                                // child: Text("Delete")),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 10,
                    margin: EdgeInsets.all(10),
                  ),
                ),
              ],
            ],
          );
        });
  }
}
