import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trek_xplorer/pages/login.dart';

import 'package:trek_xplorer/pages/user/change_password.dart';
import 'package:trek_xplorer/pages/user/dashboard.dart';
import 'package:trek_xplorer/pages/user/favorites.dart';
import 'package:trek_xplorer/pages/user/filter.dart';
import 'package:trek_xplorer/pages/user/profile.dart';

class UserMain extends StatefulWidget {
  UserMain({Key? key}) : super(key: key);

  @override
  _UserMainState createState() => _UserMainState();
}

class _UserMainState extends State<UserMain> {
  int _selectedIndex = 0;
  var durationfilter = "";
  var pricefilter = "";
  var locationfilter = "";
  var wantfilter = "";
  //controllers
  final durationfilterController = TextEditingController();
  final pricefilterController = TextEditingController();
  final locationfilterController = TextEditingController();
  static List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    Favorites(),
    ChangePassword(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Welcome to TrekXplorer"),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            backgroundColor: Colors.purple,
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            backgroundColor: Colors.purple,
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            backgroundColor: Colors.purple,
            label: 'Change Password',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
        backgroundColor: Colors.purple,
      ),
    );
  }
}
