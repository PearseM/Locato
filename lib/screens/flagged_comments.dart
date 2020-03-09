import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integrated_project/resources/database.dart';
import 'package:integrated_project/screens/comment_tile.dart';
import 'package:integrated_project/resources/pin.dart';
import 'package:integrated_project/resources/review.dart';
import 'package:integrated_project/resources/account.dart';

class FlaggedCommentsPage extends StatelessWidget {
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

class BodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }
}

Widget _myListView(BuildContext context) {
  Account account = Account(null);
  var location = new LatLng(52.518611, 13.408056);
  for (int i = 0; i < 25; i++) {
    Review review =
        Review(i.toString(), account, "Comment 1", DateTime.now(), 0);
    Pin pin = Pin(
      i.toString(),
      location,
      account,
      "Pin 1",
      context,
      review: review,
    );
    account.addReview(review);
  }

  return StreamBuilder<List<Review>>(
    stream: Database.flaggedReviews(context),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator(),);
      }
      else {
        if (snapshot.data.length > 0) {
          return ListView.separated(
            separatorBuilder: (context, index) =>
                Divider(
                  color: Colors.black,
                ),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              Review review = snapshot.data[index];

              return FlaggedReviewsListItem(
                name: review.pin.name,
                date: review.timestamp,
                comment: review.body,
              );
            },
          );
        }
        else {
          return Center(child: Text("There are no flagged reviews."),);
        }
      }
    }
  );
}
