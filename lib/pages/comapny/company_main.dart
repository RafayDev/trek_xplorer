import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trek_xplorer/pages/comapny/addtour.dart';
import 'package:trek_xplorer/pages/comapny/cdashboard.dart';
import 'package:trek_xplorer/pages/comapny/setting.dart';
import 'package:trek_xplorer/pages/comapny/viewtour.dart';
import 'package:trek_xplorer/pages/login.dart';

class CompanyMain extends StatefulWidget {
  CompanyMain({Key? key}) : super(key: key);

  @override
  _CompanyMainState createState() => _CompanyMainState();
}

class _CompanyMainState extends State<CompanyMain> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Cdashboard(),
    Addtour(),
    Viewtour(),
    Csetting()
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    //  initState()
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Welcome to TrekXplorer"),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      //  backgroundColor: Colors.purple,
      bottomNavigationBar: BottomNavigationBar(
        //   backgroundColor: Colors.purple,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            backgroundColor: Colors.purple,
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_to_photos),
            backgroundColor: Colors.purple,
            label: 'Add Tour',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            backgroundColor: Colors.purple,
            label: 'View Tour',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            backgroundColor: Colors.purple,
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,

        //  backgroundColor: Color.fromARGB(0, 132, 0, 255),
        onTap: _onItemTapped,
      ),
    );
  }
}
