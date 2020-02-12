import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AccountPage extends StatelessWidget {
  @override

  final TextEditingController fieldController = new TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Settings"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextField(
                    controller: fieldController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter New Username",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: FlatButton(
                      onPressed: () {
                        //PUT CODE HERE FOR CHANGING USERNAME
                        fieldController.clear();
                      },
                      child: Text(
                        "Change Username",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            FlatButton.icon(
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
                size: 50.0,
                color: Colors.red[800],
              ),
              color: Colors.grey,
              label: Text(
                "Delete Account",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}