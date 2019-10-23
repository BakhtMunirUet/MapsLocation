import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirestore/check_screen.dart';
import 'package:flutterfirestore/login/login_page.dart';



class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future getUserinfo() async {
  }

  startTime() async {
    var _duration = new Duration(seconds: 4);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    _auth.currentUser().then((user) {
      if (user != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => CheckScreen()),
            (Route<dynamic> route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();

    getUserinfo();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(top: 100),
            child: new FadeTransition(
                opacity: animation,
                child: new Text(
                  'Mobile Tracker',
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                )),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 50),
            child: new Center(
              child: new CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
