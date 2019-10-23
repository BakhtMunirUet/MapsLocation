import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirestore/check_screen.dart';
import 'package:flutterfirestore/mainSection/main_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  SharedPreferences prefs;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  //bool isLoading = false;
  String userToken;
  FirebaseUser currentUser;

  Future<void> _gSignin() async {
    // this.setState((){
    //   isLoading = true;
    // });

    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final FirebaseUser firebaseUser =
        await _auth.signInWithCredential(credential);

    prefs = await SharedPreferences.getInstance();

    if (firebaseUser != null) {
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;

      if (documents.length == 0) {
        Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .setData({
          'userName': firebaseUser.displayName,
          'photoUrl': firebaseUser.photoUrl,
          'userId': firebaseUser.uid,
          'userToken': userToken
        });

        currentUser = firebaseUser;
        await prefs.setString('userId', currentUser.uid);
        await prefs.setString('userName', currentUser.displayName);
        await prefs.setString('photoUrl', currentUser.photoUrl);
      } else {
        await prefs.setString('userId', documents[0]['userId']);
        await prefs.setString('userName', documents[0]['userName']);
        await prefs.setString('photoUrl', documents[0]['photoUrl']);
      }

      // this.setState((){
      //   isLoading = false;
      // });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CheckScreen()),
      );
    }

    return firebaseUser;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  userMobileToken() {
    _firebaseMessaging.getToken().then((token) {
      print(token);

      setState(() {
        userToken = token;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.lightGreen,
      body: ListView(
        children: <Widget>[
          SizedBox(height: 30.0),
          Container(
            alignment: Alignment.center,
            height: 20.0,
            child: Text(
              "Mobile Tracker",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontFamily: "free-scpt"),
            ),
          ),
          SizedBox(height: 30.0),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: FlatButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                child: Text(
                  'SIGN IN WITH GOOGLE',
                  style: TextStyle(fontSize: 16.0),
                ),
                color: Color(0xffdd4b39),
                highlightColor: Color(0xffff7f7f),
                splashColor: Colors.transparent,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
                onPressed: () => _gSignin(),
              ),
            ),
          ),

          // Positioned(
          //   child: isLoading ? Container(
          //     child: Center(
          //       child: CircularProgressIndicator(
          //         valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
          //       ),
          //     ),

          //     color: Colors.white.withOpacity(0.8),
          //   )
          //   : Container()
          // )
        ],
      ),
    );
  }
}
