import 'package:flutter/material.dart';
import 'package:wangpawa/page/post_screen_page.dart';
import 'package:wangpawa/widget/post_widget.dart';

class PostTile extends StatelessWidget {
  final Post post;

  PostTile(this.post);

  displayPost(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PostScreenPage(postId: post.postId, userId: post.ownerId)));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => displayPost(context),
      child: Image.network(post.url),
    );
  }
}
