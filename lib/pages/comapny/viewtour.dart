import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trek_xplorer/pages/comapny/update_tour.dart';

class Viewtour extends StatefulWidget {
  const Viewtour({Key? key}) : super(key: key);

  @override
  State<Viewtour> createState() => _ViewtourState();
}

String? email = FirebaseAuth.instance.currentUser!.email;

class _ViewtourState extends State<Viewtour> {
  void initState() {
    var email = FirebaseAuth.instance.currentUser!.email;
    super.initState();
  }

  final Stream<QuerySnapshot> tourStream = FirebaseFirestore.instance
      .collection('tours')
      .where('email', isEqualTo: "$email")
      .snapshots();

  // For Deleting Tour
  CollectionReference tours = FirebaseFirestore.instance.collection('tours');

  Future<void> deleteUser(id) {
    // print("User Deleted $id");
    return tours
        .doc(id)
        .delete()
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                "Tour Deleted Sucessfully",
                style: TextStyle(fontSize: 20.0),
              ),
            )));

    //  .catchError((error) => print('Failed to Delete Tour: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: tourStream,
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
              child: Text("No Tours Added By You"),
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
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        primary:
                                            Color.fromARGB(255, 0, 47, 255),
                                        shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0),
                                        ),
                                      ),
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UpdateTour(
                                                id: storedocs[i]['id']),
                                          ),
                                        );
                                      },
                                      label: Text("Update")),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                                ),
                                ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      primary: Color.fromARGB(255, 255, 0, 0),
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0),
                                      ),
                                    ),
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      deleteUser(storedocs[i]['id']);
                                    },
                                    label: Text("Delete")),
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
