//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:integrated_project/screens/comment_tile.dart';
import 'package:integrated_project/resources/review.dart';
import 'package:integrated_project/resources/account.dart';

class UserCommentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Your Reviews'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            semanticLabel: "Back",
          ),
          onPressed: () => Navigator.pop(context, false),
        ),
        actions: <Widget>[
          PopupMenuButton(
            tooltip: "Help",
            icon: Icon(
              Icons.help,
              color: Colors.white,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                child: Text(
                    "\nHere is a list of all the reviews you have made.\n"
                    "\nYou can click on each one to go to the pin it was written about.\n"),
              ),
            ],
          )
        ],
      ),
      body: BodyLayout(),
    );
  }
}

class BodyLayout extends StatefulWidget {
  @override
  _BodyLayoutState createState() => _BodyLayoutState();
}

class _BodyLayoutState extends State<BodyLayout> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Review>>(
      stream: Account.getReviewsForUser(context),
      builder: (context, snapshot) {
        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return (snapshot.data.length > 0)
              ? ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.black,
                  ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    Review review = snapshot.data.elementAt(index);
                    return YourReviewsListItem(
                      name: review.pin.name,
                      date: review.timestamp,
                      comment: review.body,
                      location: review.pin.location,
                      url: review.pin.imageUrl,
                    );
                  },
                )
              : Center(
                  child: Text("No reviews available."),
                );
        }
      },
    );
  }
}
