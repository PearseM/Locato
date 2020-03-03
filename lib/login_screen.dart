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
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(0.0, -0.6),
            child: Text(
              "locato",
              style: GoogleFonts.merriweather().copyWith(color: Colors.white),
              textScaleFactor: 5.0,
            ),
          ),
          Align(
            child: Card(
              shape: StadiumBorder(),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(Icons.beach_access, size: 250.0),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.0, 0.75),
            child: GoogleSignInButton(
              onPressed: () {
                SignIn().signInWithGoogle().then((user) {
                  if (user != null) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MapPage()));
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
