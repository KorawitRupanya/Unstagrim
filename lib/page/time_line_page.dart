import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wangpawa/model/user.dart';
import 'package:wangpawa/page/login_page.dart';
import 'package:wangpawa/widget/header.dart';
import 'package:wangpawa/widget/post_widget.dart';

class TimeLinePage extends StatefulWidget {
  final User currentUser;
  TimeLinePage({this.currentUser});

  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  List<Post> posts;
  List<String> followingsList = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  retrieveTimeline() async {
    QuerySnapshot querySnapshot = await timelineReference
        .document(widget.currentUser.id)
        .collection("timelinePosts")
        .orderBy('timestamp', descending: true)
        .getDocuments();

    List<Post> allPost = querySnapshot.documents
        .map((document) => Post.fromDocument(document))
        .toList();

    setState(() {
      this.posts = allPost;
      print(allPost.length);
    });
  }

  retrieveFollowings() async {
    QuerySnapshot querySnapshot = await followingReference
        .document(currentUser.id)
        .collection("userFollowing")
        .getDocuments();
    setState(() {
      followingsList = querySnapshot.documents
          .map((document) => document.documentID)
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    retrieveTimeline();
    retrieveFollowings();
  }

  createUserTimeLine() {
    if (posts == null) {
      return CircularProgressIndicator();
    } else {
      return ListView(
        children: posts,
      );
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      appBar: header(context, appTitle: true),
      body: RefreshIndicator(
        child: createUserTimeLine(),
        onRefresh: () => retrieveTimeline(),
      ),
    );
  }
}
