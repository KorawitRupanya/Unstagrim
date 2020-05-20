import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wangpawa/page/login_page.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

Widget header(context,
    {bool appTitle = false, String title, notShowBackButton = false}) {
  return AppBar(
    title: Text(
      appTitle ? "WangPaWa" : title,
      style: TextStyle(
          fontFamily: 'Sportsquake', fontSize: 35.0, color: Colors.white),
    ),
    automaticallyImplyLeading: notShowBackButton ? false : true,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[const Color(0xFFE0E300), const Color(0xFFFD8A5E)],
        ),
      ),
    ),
    actions: <Widget>[
      IconButton(
          icon: Icon(Icons.exit_to_app),
          color: Colors.white,
          onPressed: () {
            signOut(context);
          })
    ],
  );
}

void signOut(BuildContext context) {
  _auth.signOut();
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MyLoginPage()),
      ModalRoute.withName('/'));
}
