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
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
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
