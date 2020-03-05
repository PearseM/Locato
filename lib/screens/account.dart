import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:integrated_project/main.dart';
import 'package:integrated_project/sign_in.dart';
import 'package:integrated_project/resources/account.dart';

//Minimum and maximum character count for the username.
const int userNameMin = 1;
const int userNameMax = 100;

class AccountPage extends StatelessWidget {
  final GlobalKey<DisplayNameFormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Account Settings")),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => formKey.currentState?.formFocus?.unfocus(),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(16.0),
                child: FutureBuilder(
                  future: SignIn.auth.currentUser(),
                  builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                    if (snapshot.hasData) {
                      return CircleAvatar(
                        backgroundImage: NetworkImage(snapshot.data.photoUrl),
                        radius: 64,
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
              DisplayNameForm(key: formKey),
              SizedBox(height: 32.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(children: [
                      Text("16", textScaleFactor: 2.0),
                      Text("Pins visited"),
                    ]),
                    Column(children: [
                      Text("4", textScaleFactor: 2.0),
                      Text("Reviews written"),
                    ]),
                  ]),
              Spacer(),
              OutlineButton(
                onPressed: () => signOut(context),
                borderSide: BorderSide(color: Colors.grey),
                child: Text("Sign out"),
              ),
              RaisedButton(
                onPressed: () => handleDeleteButton(context),
                textColor: Theme.of(context).colorScheme.onError,
                color: Theme.of(context).errorColor,
                child: Text("Delete account"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleDeleteButton(BuildContext context) async {
    bool confirmed = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Are you sure?"),
        content: Text("All data associated with your account will be deleted."),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Cancel"),
          ),
          FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            textColor: Theme.of(context).errorColor,
            child: Text("Delete"),
          )
        ],
      ),
    );

    if (confirmed) {
      deleteAccount(context);
    }
  }
}

class DisplayNameForm extends StatefulWidget {
  DisplayNameForm({Key key}) : super(key: key);

  @override
  State<DisplayNameForm> createState() => DisplayNameFormState();
}

class DisplayNameFormState extends State<DisplayNameForm> {
  FocusNode formFocus = FocusNode();

  TextEditingController controller;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        controller = TextEditingController(text: user.displayName);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: formFocus,
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        labelText: "Display Name",
        hintText: "How would you like to be known?",
      ),
      onFieldSubmitted: (value) async {
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        String oldDisplayName = user.displayName;
        Account.updateUserName(value);

        SnackBar snackbar = SnackBar(
          content: Text("Your display name was changed."),
          action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              Account.updateUserName(oldDisplayName);
              setState(() {
                controller.text = oldDisplayName;
              });
            },
          ),
        );
        Scaffold.of(context).showSnackBar(snackbar);

        formFocus.unfocus();
      },
      validator: validateDisplayName,
    );
  }

  String validateDisplayName(String value) {
    RegExp alphaNumRegEx = RegExp(r'^[a-zA-Z0-9]+$');

    if (!alphaNumRegEx.hasMatch(value) && value.length > 0) {
      return "Your display name may only contain alphanumeric characters.";
    }
    if (value.length > userNameMax) {
      return "Your display name is too long, the maximum length is " +
          userNameMax.toString();
    }
    if (value.length < userNameMin) {
      return "Your display name is too short, the minimum length is " +
          userNameMin.toString();
    }
    return null;
  }
}

void deleteAccount(BuildContext context) {
  FirebaseAuth.instance.currentUser().then((user) {
    user.delete();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
  });
}

void signOut(BuildContext context) {
  FirebaseAuth.instance.signOut();
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
}
