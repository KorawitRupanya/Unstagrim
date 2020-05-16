import 'package:flutter/material.dart';
import 'package:wangpawa/widget/header.dart';

import '../firebase_config/mobile_storage.dart';

Widget mainPage(BuildContext context) {
  List items = getDummyList();
  return Scaffold(
    appBar: header(context, title: "WangPawa", notShowBackButton: true),
    backgroundColor: Colors.black,
    body: SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: MediaQuery.of(context).size.width * 0.6,
                        child: Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          margin: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 8,
                          child: Container(
                            child: FutureBuilder(
                              future: _getImage(context, "Image1.png"),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done)
                                  return Container(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    child: snapshot.data,
                                  );

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting)
                                  return Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      child: CircularProgressIndicator());

                                return Container();
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<Widget> _getImage(BuildContext context, String image) async {
  Image m;
  await FireStorageService.loadImage(context, image).then((downloadUrl) {
    m = Image.network(
      downloadUrl.toString(),
      fit: BoxFit.fill,
    );
  });
  return m;
}

List getDummyList() {
  List list = List.generate(2, (i) {
    return "Item ${i + 1}";
  });
  return list;
}
