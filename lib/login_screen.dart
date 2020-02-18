import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:integrated_project/screens/map.dart';

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
              padding: EdgeInsets.symmetric(vertical: 100.0,),
              child: new Image(
                  image:NetworkImage('https://img.pixers.pics/pho_wat(s3:700/FO/46/67/81/42/700_FO46678142_6f739fe2238316c0650ebfab20c11f7b.jpg,250,250,cms:2018/10/5bd1b6b8d04b8_220x50-watermark.png,over,480,650,jpg)/wall-murals-camera-photo-lens-with-earth-globe-inside-vector.jpg.jpg')
              ),
            ),

          new Container(
            padding: EdgeInsets.symmetric(vertical: 5.0,),
            child: new RaisedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPageState()),
                );
              },
              icon: Icon(
                Icons.assignment,
              ),
              label: Text('Register'),
               color: Colors.blue,
              ),
            ),

          new Container(
            padding: EdgeInsets.symmetric(vertical: 5.0,),
            child: new RaisedButton.icon(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPageState()),
              );
            },
             icon: Icon(
               Icons.account_circle,
           ),
            label: Text('Login'),
            color: Colors.blue,
           ),
          ),

          ],
        )
    )
    );
  }
}

class LoginPageState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
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
                padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 50.0),

                child: new RaisedButton.icon(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapPage()),
                    );
                  },
                  icon: Icon(
                    Icons.account_circle,
                  ),
                  label: Text('Login'),
                  color: Colors.blue,
              ),
            ),
          ],
        ),
      )
    );
  }
}

class RegisterPageState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Registration Page"),
        ),
        body: Center(
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
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
                padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 25.0),
                child: new TextField(
                  enabled: true,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText:'Confirm Password',
                  ),
                ),
              ),

              new Container(
                padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 25.0),
                child: new TextField(
                  enabled: true,
                  decoration: InputDecoration(
                    hintText:'E-mail',
                  ),
                ),
              ),

              new Container(
                padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 25.0),
                child: new TextField(
                  enabled: true,
                  decoration: InputDecoration(
                    hintText:'Confirm E-Mail',
                  ),
                ),
              ),

              new Container(
                padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 50.0),

                child: new RaisedButton.icon(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapPage()),
                    );
                  },
                  icon: Icon(
                    Icons.assignment,
                  ),
                  label: Text('Register'),
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        )
    );
  }
}