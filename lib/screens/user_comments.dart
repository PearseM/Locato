import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integrated_project/screens/comment_tile.dart';
import 'package:integrated_project/resources/pin.dart';
import 'package:integrated_project/resources/review.dart';
import 'package:integrated_project/resources/account.dart';

class UserCommentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your Reviews',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text('Your Reviews'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
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
    Review review = Review(null, account, "Comment 1", DateTime.now());
    Pin pin = Pin(null, location, account, "Pin 1", review);
    account.addReview(review);
  }

  return ListView.separated(
    separatorBuilder: (context, index) => Divider(
      color: Colors.black,
    ),
    itemCount: 14,
    itemBuilder: (context, index) {
      Review review = account.reviews[index];

      return YourReviewsListItem(
        name: review.pin.name,
        date: review.timestamp,
        comment: review.body,
      );
    },
  );
}

//title: Text(user.getReview(index).pin.name),
//subtitle: Text(user.getReview(index).date.day.toString() + "/" + user.getReview(index).date.month.toString() +
//"/"+ user.getReview(index).date.year.toString() + " \n " + user.getReview(index).content),
