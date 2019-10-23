import 'package:flutter/material.dart';
import 'package:flutterfirestore/mainSection/main_screen.dart';

class CheckScreen extends StatefulWidget {
  @override
  _CheckScreenState createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          },
          color: Colors.blue,
          child: Text("Main Screen"),
        ),
      ),
    );
  }
}
