import 'package:flutter/material.dart';
import 'package:integrated_project/screens/account.dart';
import 'package:integrated_project/screens/user_comments.dart';

class MapDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Username"),
            accountEmail: Text("Email"),
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
        ],
      ),
    );
  }
}
