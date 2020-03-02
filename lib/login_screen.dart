import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:integrated_project/screens/map.dart';
import 'package:integrated_project/sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PhotoScout"),
      ),
      body: Center(
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            new Container(
              padding: EdgeInsets.symmetric(vertical: 50.0,),
              child: new Image(
                  image:NetworkImage('https://img.pixers.pics/pho_wat(s3:700/FO/46/67/81/42/700_FO46678142_6f739fe2238316c0650ebfab20c11f7b.jpg,150,150,cms:2018/10/5bd1b6b8d04b8_220x50-watermark.png,over,480,650,jpg)/wall-murals-camera-photo-lens-with-earth-globe-inside-vector.jpg.jpg')
              ),
            ),

            new Container(
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 25.0),
              child: new TextField(
                enabled: true,
                maxLength: 20,
                maxLengthEnforced: true,
                decoration: InputDecoration(
                  hintText:'Username',
                ),
              ),
            ),

            new Container(
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 25.0),
              child: new TextField(
                enabled: true,
                obscureText: true,
                decoration: InputDecoration(
                  hintText:'Password',
                ),
              ),
            ),

          new Container(
            padding: EdgeInsets.symmetric(vertical: 5.0,),
            child: new RaisedButton.icon(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapPage()),//LoginPageState()),
              );
            },
             icon: Icon(
               Icons.account_circle,
           ),
            label: Text('Login'),
            color: Colors.blue,
           ),
          ),

          new Container(
            child: Center(
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  // signInButton(context),
            ],
            ),
          ),
          ),

            new OutlineButton(
              splashColor: Colors.grey,
              onPressed: () {
                SignIn().signInWithGoogle().then((user) {
                  if (user != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MapPage()
                        )
                    );
                  }
                });
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              highlightElevation: 0,
              borderSide: BorderSide(color: Colors.black),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(image: NetworkImage('https://images.theconversation.com/files/93616/original/image-20150902-6700-t2axrz.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1000&fit=clip'), height: 35.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
        ],
      ),
    ));
  }
}

