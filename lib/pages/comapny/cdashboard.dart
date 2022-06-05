import 'package:flutter/material.dart';

class Cdashboard extends StatefulWidget {
  const Cdashboard({Key? key}) : super(key: key);

  @override
  State<Cdashboard> createState() => _CdashboardState();
}

class _CdashboardState extends State<Cdashboard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          child: Text(
        'Company Dashboard',
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      )),
    );
  }
}
