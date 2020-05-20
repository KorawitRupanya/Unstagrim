import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:wangpawa/model/user.dart';
import 'package:wangpawa/page/home.dart';

import 'create_profile_page.dart';
import 'reset_password.dart';
import 'sign_up.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final userReferences = Firestore.instance.collection("user");
final StorageReference storageReference =
    FirebaseStorage.instance.ref().child("Post Pictures");
final postReferences = Firestore.instance.collection("post");
final activityFeedReference = Firestore.instance.collection("feed");
final commentsReference = Firestore.instance.collection("comments");
final followersReference = Firestore.instance.collection("follower");
final followingReference = Firestore.instance.collection("following");
final timelineReference = Firestore.instance.collection("timeline");

final DateTime time = DateTime.now();

User currentUser;

class MyLoginPage extends StatefulWidget {
  MyLoginPage({Key key}) : super(key: key);

  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  static User currentUserForUploadPage;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.white, Colors.black],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 800.0, 700.0));
  @override
  void initState() {
    super.initState();
    checkAuth(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  "Unstagrim",
                  style: TextStyle(
                      fontFamily: 'Sportsquake',
                      fontSize: 60.0,
                      foreground: Paint()..shader = linearGradient),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Image(
                    image: AssetImage('assets/images/Logo.png'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      buildTextFieldEmail(),
                      buildTextFieldPassword(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          buildButtonLogIn(),
                          buildButtonRegister(),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "OR",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      buildButtonFacebook(context),
                      buildButtonForgotPassword(context)
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Image(
                            image: AssetImage('assets/images/footer.png'),
                          ))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildTextFieldEmail() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: TextField(
        controller: emailController,
        decoration: InputDecoration.collapsed(hintText: "Email"),
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Container buildTextFieldPassword() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: TextField(
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration.collapsed(hintText: "Password"),
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget buildButtonLogIn() {
    return InkWell(
      child: Container(
          child: Text("LOGIN",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40),
              color: Colors.black38),
          margin: EdgeInsets.only(top: 16),
          padding: EdgeInsets.all(12)),
      onTap: () {
        signIn();
      },
    );
  }

  Widget buildButtonRegister() {
    return InkWell(
        child: Container(
            child: Text("REGISTER",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment(0.8, 0.0),
                    colors: [const Color(0xFFE0E300), const Color(0xFF00BFAF)]),
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(40),
                color: Colors.white),
            margin: EdgeInsets.only(top: 16),
            padding: EdgeInsets.all(12)),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MySignUpPage()));
        });
  }

  buildButtonForgotPassword(BuildContext context) {
    return InkWell(
        child: Container(
            constraints: BoxConstraints.expand(height: 50),
            child: Text("Forgot password",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.red[300]),
            margin: EdgeInsets.only(top: 12),
            padding: EdgeInsets.all(12)),
        onTap: () => navigateToResetPasswordPage(context));
  }

  buildButtonFacebook(BuildContext context) {
    return InkWell(
        child: Container(
            constraints: BoxConstraints.expand(height: 50),
            child: Text("Login with Facebook ",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.blue[400]),
            margin: EdgeInsets.only(top: 12),
            padding: EdgeInsets.all(12)),
        onTap: () => loginWithFacebook(context));
  }

  navigateToResetPasswordPage(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MyResetPasswordPage()));
  }

  Future signIn() async {
    await _auth
        .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        .then((user) {
      print("signed in ${user.additionalUserInfo.isNewUser}");
      checkAuth(context);
    }).catchError((error) {
      print(error.message);
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Error",
        message: error.message,
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      )..show(context);
    });
  }

  Future loginWithFacebook(BuildContext context) async {
    FacebookLogin facebookLogin = FacebookLogin();
    FacebookLoginResult result =
        await facebookLogin.logIn(['email', "public_profile"]);

    String token = result.accessToken.token;
    print("Access token = $token");
    await _auth.signInWithCredential(FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token));
    checkAuth(context).catchError((error) {
      print(error.message);
    });
  }

  Future checkAuth(BuildContext context) async {
    FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      configureRealTimePushNotification();
      print("Already singed-in with");
      await saveUserInfoToFireStore();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    currentUser: currentUser,
                    storageReference: storageReference,
                  )));
    }
  }

  configureRealTimePushNotification() async {
    final FirebaseUser user = await _auth.currentUser();
    if (Platform.isIOS) {
      getIOSPermissions();
    }
    _firebaseMessaging.getToken().then((token) {
      userReferences
          .document(user.uid)
          .updateData({"androidNotificationToken": token});
    });
    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> msg) async {
      final String recipientId = msg["data"]["recipient"];
      final String body = msg["notification"]["body"];
      if (recipientId == user.uid) {
        SnackBar snackBar = SnackBar(
          backgroundColor: Colors.grey,
          content: Text(
            body,
            style: TextStyle(color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    });
  }

  getIOSPermissions() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(alert: true, badge: true, sound: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((settings) => {print("Setting Registered: $settings")});
  }

  saveUserInfoToFireStore() async {
    FirebaseUser user = await _auth.currentUser();
    DocumentSnapshot documentSnapshot =
        await userReferences.document(user.uid).get();
    if (!documentSnapshot.exists) {
      final username = await Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => CreateProfilePage()));
      userReferences.document(user.uid).setData({
        "id": user.uid,
        "profileName": user.displayName,
        "username": username,
        "url": user.photoUrl,
        "email": user.email,
        "bio": "",
        "timestamp": time
      });
      await followersReference
          .document(currentUser.id)
          .collection("userFollowers")
          .document(currentUser.id)
          .setData({});
      documentSnapshot = await userReferences.document(user.uid).get();
    }
    currentUser = User.fromDocument(documentSnapshot);
    currentUserForUploadPage = currentUser;
  }
}

var alertStyle = AlertStyle(
  animationType: AnimationType.fromTop,
  isCloseButton: false,
  isOverlayTapDismiss: false,
  descStyle: TextStyle(fontWeight: FontWeight.bold),
  animationDuration: Duration(milliseconds: 400),
  alertBorder: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(0.0),
    side: BorderSide(
      color: Colors.grey,
    ),
  ),
  titleStyle: TextStyle(
    color: Colors.red,
  ),
);
