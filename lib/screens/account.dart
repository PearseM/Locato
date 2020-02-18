import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

const int userNameMin = 1;
const int userNameMax = 100;

class AccountPage extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
            MyUsernameForm(),
            Wrap(
              alignment: WrapAlignment.center,
              runSpacing: 15.0,
              children: <Widget>[
                FlatButton.icon(
                  onPressed: () {
                    //PUT CODE FOR SIGNING OUT HERE


                  },
                  icon: Icon(
                    Icons.account_box,
                    size: 50.0,
                    color: Colors.blue[800],
                  ),
                  color: Colors.grey,
                  label: Text(
                    "Switch Account",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
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
          ],
        ),
      ),
    );
  }
}

class MyUsernameForm extends StatefulWidget {
  @override
  MyUsernameFormState createState() {
    return MyUsernameFormState();
  }
}


class MyUsernameFormState extends State<MyUsernameForm> {
  final TextEditingController usernameController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  var currentUsername = "Steve";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
            child: Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(text: "Current Username\n", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                  TextSpan(text: currentUsername, style: TextStyle(fontSize: 20.0)),
                ]
              ),
              textAlign: TextAlign.center,
            ),
          ),
          TextFormField(
            controller: usernameController,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
            ),
            decoration: InputDecoration(
              hintText: "Enter New Username",
            ),
            validator: (username) {
              RegExp alphaNumRegEx = RegExp(r'^[a-zA-Z0-9]+$');

              if (!alphaNumRegEx.hasMatch(username) && username.length > 0) {
                return "You must have only alphanumeric characters in your username";
              } if (username.length > userNameMax) {
                return "Your username is too long, the maximum length is " + userNameMax.toString();
              } if (username.length < userNameMin) {
                return "Your username is too short, the minimum length is " + userNameMin.toString();
              }
              return null;
            }
          ),
          FlatButton(
              onPressed: () {
                if (formKey.currentState.validate()) {
                  var username = usernameController.text;
                  FocusScope.of(context).unfocus();

                  return Alert(
                      context: context,
                      title: "WARNING: CHANGE USERNAME",
                      desc: "Are you sure you want to change your username to \"" + username + "\"?",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "Change",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          color: Colors.red[800],
                          onPressed: () {
                            //PUT CODE FOR CHANGING USERNAME HERE

                            setState(() {
                              currentUsername = username;
                            });
                            usernameController.clear();
                            Navigator.pop(context);
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
                }
                return null;
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
        ]
      )
    );
  }
}