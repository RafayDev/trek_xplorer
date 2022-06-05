import 'package:flutter/material.dart';

class Viewtour extends StatefulWidget {
  const Viewtour({Key? key}) : super(key: key);

  @override
  State<Viewtour> createState() => _ViewtourState();
}

class _ViewtourState extends State<Viewtour> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          child: Text(
        'View tours',
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      )),
    );
  }
}
