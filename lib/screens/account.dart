import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Settings"),
        centerTitle: true,
      ),
      body: Center(
        child: FlatButton.icon(
          onPressed: () {
            return Alert(
                context: context,
                title: "WARNING: DELETE ACCOUNT",
                desc: "This cannot be undone. Would you still like to continue?",
                buttons: [
                  DialogButton(
                      child: Text(
                          "Delete",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      color: Colors.red[800],
                      onPressed: () {
                        //PUT CODE FOR DELETING ACCOUNT HERE
                      },
                  ),
                  DialogButton(
                    child: Text(
                        "Cancel",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ]
            ).show();
          },
          icon: Icon(
          Icons.delete_forever,
          size: 70.0,
          color: Colors.red[800],
          ),
          color: Colors.lightBlue,
          label: Text(
              "DELETE ACCOUNT",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              //color: Colors.red[800],
            ),
          ),
        ),
      ),
    );
  }
}