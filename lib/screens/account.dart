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
      appBar: AppBar(title: Text("Account Settings")),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: DisplayNameForm(),
            ),
            Spacer(),
            FlatButton(
              onPressed: () => signOut(context),
              child: Text("Sign out"),
            ),
            FlatButton(
              onPressed: () => handleDeleteButton(context),
              textColor: Theme.of(context).errorColor,
              child: Text("Delete account"),
            ),
          ],
        ),
      ),
    );
  }

  void handleDeleteButton(BuildContext context) async {
    bool confirmed = await confirmationDialog(context, "delete your account");
    if (confirmed) {
      deleteAccount(context);
    }
  }
}

class DisplayNameForm extends StatefulWidget {
  @override
  State<DisplayNameForm> createState() => DisplayNameFormState();
}

class DisplayNameFormState extends State<DisplayNameForm> {
  FocusNode formFocus = FocusNode();
  GlobalKey<FormFieldState> formKey = GlobalKey();

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
      key: formKey,
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
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
  });
}

void signOut(BuildContext context) {
  FirebaseAuth.instance.signOut();
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
}
