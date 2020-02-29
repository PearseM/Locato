import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:integrated_project/main.dart';
import 'package:integrated_project/resources/account.dart';

//Minimum and maximum character count for the username.
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
                    signOut(context);
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
                    handleDeleteButton(context);
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

  void handleDeleteButton(BuildContext context) {
    confirmationDialog(context, "delete yout account").then((bool confirmed) {
      if (confirmed) {
        deleteAccount(context);
      }
    });
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
  String currentUsername = getCurrentUsername();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
            child: Text.rich(
              TextSpan(children: <TextSpan>[
                TextSpan(
                    text: "Current Username\n",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                TextSpan(
                    text: currentUsername, style: TextStyle(fontSize: 20.0)),
              ]),
              textAlign: TextAlign.center,
            ),
          ),
          TextFormField(
              controller: usernameController,
              style: TextStyle(
                fontSize: 20.0,
              ),
              decoration: InputDecoration(
                hintText: "Enter new username",
                suffixIcon: IconButton(
                    onPressed: () => usernameController.clear(),
                    icon: Icon(Icons.clear)),
              ),
              validator: (username) {
                RegExp alphaNumRegEx = RegExp(r'^[a-zA-Z0-9]+$');

                if (!alphaNumRegEx.hasMatch(username) && username.length > 0) {
                  return "You must have only alphanumeric characters in your username";
                }
                if (username.length > userNameMax) {
                  return "Your username is too long, the maximum length is " +
                      userNameMax.toString();
                }
                if (username.length < userNameMin) {
                  return "Your username is too short, the minimum length is " +
                      userNameMin.toString();
                }
                return null;
              }),
          FlatButton(
            onPressed: () {
              if (formKey.currentState.validate()) {
                handleUsernameButton();
                FocusScope.of(context).unfocus();
              }
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
        ]));
  }

  void handleUsernameButton() {
    var newName = usernameController.text;
    confirmationDialog(context, "change your username to \"" + newName + "\"")
        .then((bool confirmed) {
      if (confirmed) {
        setState(() {
          currentUsername = newName;
        });
        usernameController.clear();
        updateUsername(newName);
      }
    });
  }
}

Future<bool> confirmationDialog(BuildContext context, String subject) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Are you sure you want to " + subject + "?"),
          actions: <Widget>[
            new FlatButton(
              child: const Text("YES"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            new FlatButton(
              child: const Text("NO"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      });
}

void deleteAccount(BuildContext context) {
  FirebaseAuth.instance.currentUser().then((user) {
    user.delete();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
        (route) => false);
  });
}

void signOut(BuildContext context) {
  FirebaseAuth.instance.signOut();
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
}

//For updating the username in the database.
void updateUsername(String newName) {
  UserUpdateInfo newInfo = UserUpdateInfo();
  newInfo.displayName = newName;
  FirebaseAuth.instance
      .currentUser()
      .then((user) => user.updateProfile(newInfo));
}

//For getting the username from the database.
String getCurrentUsername() {
  return Account.currentAccount.userName;
}
