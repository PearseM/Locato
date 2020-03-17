import 'package:flutter/material.dart';
import 'package:integrated_project/resources/database.dart';
import 'package:integrated_project/screens/comment_tile.dart';
import 'package:integrated_project/resources/review.dart';

class FlaggedCommentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('Flagged Reviews'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: BodyLayout(),
    );
  }
}

class BodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Review>>(
      stream: Database.flaggedReviews(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasData && snapshot.data.length > 0) {
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Colors.black,
              ),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                Review review = snapshot.data[index];
                return FlaggedReviewsListItem(review);
              },
            );
          } else {
            return Center(
              child: Text("There are no flagged reviews."),
            );
          }
        }
      },
    );
  }
}
