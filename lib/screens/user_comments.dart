import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integrated_project/screens/comment_tile.dart';
import 'package:integrated_project/resources/pin.dart';
import 'package:integrated_project/resources/review.dart';
import 'package:integrated_project/resources/account.dart';
import 'package:integrated_project/resources/database.dart';
import 'package:integrated_project/screens/map.dart';

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
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Your reviews"),
//      ),
//    );
  }
}

class BodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }
}
class ReviewListView extends StatefulWidget {
  @override
  _ReviewListViewState createState() => _ReviewListViewState();
}

class _ReviewListViewState extends State<ReviewListView> {
  final Set<Review> _userReviews = Set();
  Account _user;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        _user = Account(user.uid);
      });
    });
    Database.reviewsByUser(_user).listen((snapshot) {
      List<DocumentChange> docs = snapshot.documentChanges;
      docs.forEach((doc) {
        //Review review = Review.fromMap(doc.document.data);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.black,
      ),
      itemCount: _userReviews.length,
      itemBuilder: (context, index) {
        Review review = _userReviews.elementAt(index);
        return ListTile(
          title: Text(review.pin.name),
          subtitle: Text(review.timestamp.toString() + " - " + review.body),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MapPage()));
          },
          onLongPress: (){
            // do something else
          },
          //selected: true,
          trailing: Icon(Icons.keyboard_arrow_right),
        );
      },
    );
  }
}

Widget _myListView(BuildContext context) {
  Account account = Account(null);
  var location = new LatLng(52.518611, 13.408056);
  for (int i = 0; i < 25; i++) {
    Review review = Review(null, account, "Comment 1", DateTime.now(), 0);
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

