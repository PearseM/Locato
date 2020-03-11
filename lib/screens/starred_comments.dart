import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integrated_project/screens/comment_tile.dart';
import 'package:integrated_project/resources/pin.dart';
import 'package:integrated_project/resources/review.dart';
import 'package:integrated_project/resources/account.dart';

class StarredCommentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your Favourite Reviews',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text('Your Favourite Reviews'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              //onPressed: () => Navigator.pop(context, false),
              onPressed: () {
                Account.getABC(context);
              },
            )),
        body: BodyLayout(),
      ),
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
    Review review = Review(i.toString(), account, "Comment 1", DateTime.now(), 0);
    Pin pin = Pin(i.toString(), location, account, "Pin 1", null, review, context); //null where imageUrl would be
    account.addReview(review);
  }



  return ListView.separated(
    separatorBuilder: (context, index) => Divider(
      color: Colors.black,
    ),
    itemCount: 14,
    itemBuilder: (context, index) {
      Review review = account.reviews[index];

      return StarredReviewsListItem(
        name: review.pin.name,
        date: review.timestamp,
        comment: review.body,
      );
    },
  );
}