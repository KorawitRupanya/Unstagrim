import 'package:flutter/material.dart';
import 'package:wangpawa/page/login_page.dart';
import 'package:wangpawa/widget/header.dart';
import 'package:wangpawa/widget/post_widget.dart';

class PostScreenPage extends StatelessWidget {
  final String postId;
  final String userId;

  PostScreenPage({this.userId, this.postId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: postReferences
            .document(userId)
            .collection("usersPosts")
            .document(postId)
            .get(),
        builder: (context, dataSnapshot) {
          if (!dataSnapshot.hasData) {
            return CircularProgressIndicator();
          }
          Post post = Post.fromDocument(dataSnapshot.data);
          return Center(
            child: Scaffold(
              backgroundColor: Colors.black,
              appBar: header(context, title: post.description),
              body: ListView(
                children: <Widget>[
                  Container(
                    child: post,
                  )
                ],
              ),
            ),
          );
        });
  }
}
