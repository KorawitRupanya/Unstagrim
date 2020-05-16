import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class MySignUpPage extends StatefulWidget {
  MySignUpPage({Key key}) : super(key: key);

  @override
  _MySignUpPageState createState() => _MySignUpPageState();
}

class _MySignUpPageState extends State<MySignUpPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text("SIGN UP"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [const Color(0xFFE0E300), const Color(0xFFFD8A5E)]),
            ),
          ),
        ),
        body: Container(
            color: Colors.black,
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Image(
                      image: AssetImage('assets/images/Logo.png'),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(colors: [
                          const Color(0xFFFD8A5E),
                          const Color(0xFFEEB92C)
                        ])),
                    margin: EdgeInsets.all(32),
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buildTextFieldEmail(),
                        buildTextFieldPassword(),
                        buildTextFieldPasswordConfirm(),
                        buildButtonSignUp(context),
                      ],
                    ),
                  ),
                ],
              ),
            )));
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

  Container buildTextFieldPasswordConfirm() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: TextField(
        controller: confirmController,
        obscureText: true,
        decoration: InputDecoration.collapsed(hintText: "Re-password"),
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget buildButtonSignUp(BuildContext context) {
    return InkWell(
      child: Container(
          constraints: BoxConstraints.expand(height: 50),
          child: Text("SIGN UP",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment(0.8, 0.0),
                  colors: [const Color(0xFFE0E300), const Color(0xFF00BFAF)]),
              borderRadius: BorderRadius.circular(16),
              color: Colors.green[200]),
          margin: EdgeInsets.only(top: 16),
          padding: EdgeInsets.all(12)),
      onTap: () => signUp(),
    );
  }

  signUp() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmController.text.trim();
    if (password == confirmPassword) {
      _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) {
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          title: "YEAH!!!",
          message: "Sign up user successful. Please go back to login",
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        )..show(context);
        print("Sign up user successful.");
        saveUserInfoToFireStore();
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
    } else {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Error",
        message: "Password and Confirm-password is not match.",
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      )..show(context);
    }
  }

  saveUserInfoToFireStore() async {}
}
