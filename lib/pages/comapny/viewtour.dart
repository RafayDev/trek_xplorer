import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  CollectionReference students = FirebaseFirestore.instance.collection('tours');

  Future<void> deleteUser(id) {
    // print("User Deleted $id");
    return students
        .doc(id)
        .delete()
        .then((value) => print('Tour Deleted'))
        .catchError((error) => print('Failed to Delete Tour: $error'));
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
          return ListView(
            children: [
              for (var i = 0; i < storedocs.length; i++) ...[
                Container(
                  height: 550,
                  width: 100,
                  child: Card(
                    color: Color.fromARGB(255, 243, 159, 243),
                    child: Column(
                      children: [
                        Image.network(
                          storedocs[i]['imgUrl'],
                          height: 250,
                        ),
                        Column(
                          children: [
                            Text(
                              storedocs[i]['title'],
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .apply(fontSizeFactor: 2.0),
                            ),
                            Text(
                              "Location",
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .apply(fontSizeFactor: 2.0),
                            ),
                            Text(
                              "Date",
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .apply(fontSizeFactor: 2.0),
                            ),
                            Text(
                              "Duaration",
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .apply(fontSizeFactor: 2.0),
                            ),
                            Text(
                              "Price",
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .apply(fontSizeFactor: 2.0),
                            ),
                            Text(
                              "Description",
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .apply(fontSizeFactor: 2.0),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    onPressed: () {}, child: Text("Update")),
                                ElevatedButton(
                                    onPressed: () {
                                      deleteUser(storedocs[i]['id']);
                                    },
                                    child: Text("Delete")),
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
