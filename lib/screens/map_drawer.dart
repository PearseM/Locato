import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:integrated_project/screens/account.dart';
import 'package:integrated_project/screens/user_comments.dart';
import 'package:integrated_project/screens/flagged_comments.dart';
import 'package:integrated_project/sign_in.dart';

class MapDrawer extends StatefulWidget {
  @override
  _MapDrawerState createState() => _MapDrawerState();
}

class _MapDrawerState extends State<MapDrawer> {
  FirebaseUser _user;

  @override
  void initState() {
    SignIn.auth.currentUser().then((user) {
      setState(() {
        _user = user;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: (_user == null || _user.photoUrl == null)
                ? CircleAvatar(
                    child: Text(
                      (_user == null) ? "X" : _user.displayName.substring(0, 1),
                    ),
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage(_user.photoUrl),
                  ),
            accountName: Text(
              (_user == null) ? "Username" : _user.displayName,
            ),
            accountEmail: Text(
              (_user == null) ? "Email" : _user.email,
            ),
          ),
          //TODO Add visited and reviews counts
          ListTile(
            title: Text("Your reviews"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserCommentsPage()));
            },
          ),
          ListTile(
            title: Text("Account"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AccountPage()));
            },
          ),
          ListTile(
            title: Text("Flagged Reviews"),
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => FlaggedCommentsPage()));
            },
          ),
        ],
      ),
    );
  }
}
