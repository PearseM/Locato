import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:integrated_project/screens/map.dart';
import 'package:integrated_project/sign_in.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SizedBox.expand(
        child: Card(
          margin: MediaQuery.of(context).padding +
              EdgeInsets.symmetric(vertical: 128.0, horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                "Locato",
                style: GoogleFonts.playfairDisplay(),
                textScaleFactor: 5.0,
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Image.asset("assets/logo.jpeg"),
              ),
              GoogleSignInButton(
                onPressed: () async {
                  FirebaseUser user = await SignIn().signInWithGoogle();
                  if (user != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => MapPage()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
