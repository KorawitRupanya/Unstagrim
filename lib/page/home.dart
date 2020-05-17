import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gradient_bottom_navigation_bar/gradient_bottom_navigation_bar.dart';
import 'package:wangpawa/model/user.dart';
import 'package:wangpawa/page/notifications_page.dart';
import 'package:wangpawa/page/profile_page.dart';
import 'package:wangpawa/page/search_page.dart';
import 'package:wangpawa/page/time_line_page.dart';
import 'package:wangpawa/page/upload_page.dart';

import 'login_page.dart';

class MyHomePage extends StatefulWidget {
  final User currentUser;
  final StorageReference storageReference;

  const MyHomePage({Key key, this.currentUser, this.storageReference})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _page = 0;
  PageController _c;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  initState() {
    _c = new PageController(
      initialPage: _page,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black12,
      bottomNavigationBar: GradientBottomNavigationBar(
        backgroundColorStart: const Color(0xFFE0E300),
        backgroundColorEnd: const Color(0xFFFD8A5E),
        type: BottomNavigationBarType.fixed,
        currentIndex: _page,
        onTap: (index) {
          this._c.animateToPage(index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut);
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text("Search")),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt), title: Text("Upload")),
          BottomNavigationBarItem(
              icon: Icon(Icons.people), title: Text("Profile")),
        ],
      ),
      body: PageView(
        controller: _c,
        onPageChanged: (newPage) {
          setState(() {
            this._page = newPage;
          });
        },
        children: <Widget>[
          TimeLinePage(currentUser: currentUser),
          SearchPage(),
          UploadPage(currentUser: currentUser),
          ProfilePage(userProfileId: currentUser.id)
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NotificationsPage()));
          },
          child: Icon(Icons.favorite),
          backgroundColor: Colors.pinkAccent,
          splashColor: Colors.white.withOpacity(0.25)),
    );
  }
}
