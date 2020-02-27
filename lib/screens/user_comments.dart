import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:integrated_project/resources/account.dart';
import 'package:integrated_project/resources/database.dart';
import 'package:integrated_project/resources/review.dart';
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
            leading: IconButton(icon:Icon(Icons.arrow_back),
              onPressed:() => Navigator.pop(context, false),
            )
        ),
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
    return ReviewListView();
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


/*
Widget _myListView(BuildContext context) {

  // backing data
  final userPins = ['Pin 1', 'Pin 2', 'Pin 3', 'Pin 4', 'Pin 5', 'Pin 6', 'Pin 7',
    'Pin 8', 'Pin 9', 'Pin 10', 'Pin 11', 'Pin 12', 'Pin 13', 'Pin 14', 'Pin 15', 'Pin 16', 'Pin 17'
    , 'Pin 18', 'Pin 19', 'Pin 20', 'Pin 21', 'Pin 22', 'Pin 23', 'Pin 24', 'Pin 25', 'Pin 26', 'Pin 27'
    , 'Pin 28', 'Pin 29', 'Pin 30', 'Pin 31', 'Pin 32', 'Pin 33', 'Pin 34', 'Pin 35', 'Pin 36', 'Pin 37'
    , 'Pin 38', 'Pin 39', 'Pin 40', 'Pin 41', 'Pin 42', 'Pin 43', 'Pin 44'];
  final userComments = ['Comment 1', 'Comment 2', 'Comment 3', 'Comment 4', 'Comment 5', 'Comment 6', 'Comment 7',
    'Comment 8', 'Comment 9', 'Comment 10', 'Comment 11', 'Comment 12', 'Comment 13', 'Comment 14', 'Comment 15', 'Comment 16', 'Comment 17'
    , 'Comment 18', 'Comment 19', 'Comment 20', 'Comment 21', 'Comment 22', 'Comment 23', 'Comment 24', 'Comment 25', 'Comment 26', 'Comment 27'
    , 'Comment 28', 'Comment 29', 'Comment 30', 'Comment 31', 'Comment 32', 'Comment 33', 'Comment 34', 'Comment 35', 'Comment 36', 'Comment 37'
    , 'Comment 38', 'Comment 39', 'Comment 40', 'Comment 41', 'Comment 42', 'Comment 43', 'Comment 44'];
  final userTimes = ['11:01', '11:02', '11:03', '11:04', '11:05', '11:06', '11:07', '11:08', '11:09',
  '11:10', '11:11', '11:12', '11:13', '11:14', '11:15', '11:16', '11:17', '11:18', '11:19',
  '11:20', '11:21', '11:22', '11:23', '11:24', '11:25', '11:26', '11:27', '11:28', '11:29',
  '11:30', '11:31', '11:32', '11:33', '11:34', '11:35', '11:36', '11:37', '11:38', '11:39',
    '11:40', '11:41', '11:42', '11:43', '11:44'];

  final Set<Review> _userReviews = Set();


  return ListView.separated(
    separatorBuilder: (context, index) => Divider(
      color: Colors.black,
    ),
    itemCount: _userReviews.length,
    itemBuilder: (context, index) {
      return ListTile(
        title: Text(userPins[index]),
        subtitle: Text(userTimes[index] + " - " + userComments[index]),
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

}*/
