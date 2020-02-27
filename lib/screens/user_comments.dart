import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integrated_project/resources/Pin.dart';
import 'package:integrated_project/screens/comment_tile.dart';
import 'package:integrated_project/resources/Review.dart';
import 'package:integrated_project/resources/User.dart';
import 'package:integrated_project/resources/Category.dart';

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
  }
}

class BodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }
}

Widget _myListView(BuildContext context) {

  var user = new User();
  user.newList();
  var cat = new List<Category>();
  var coord1 = new LatLng(52.518611,13.408056);
  var pin1 = Pin.tempPin(user, "Pin1", coord1, cat);
  var pin2 = Pin.tempPin(user, "Pin2", coord1, cat);
  var pin3 = Pin.tempPin(user, "Pin3", coord1, cat);
  var pin4 = Pin.tempPin(user, "Pin4", coord1, cat);
  var pin5 = Pin.tempPin(user, "Pin5", coord1, cat);
  var pin6 = Pin.tempPin(user, "Pin6", coord1, cat);
  var pin7 = Pin.tempPin(user, "Pin7", coord1, cat);
  var pin8 = Pin.tempPin(user, "Pin8", coord1, cat);
  var pin9 = Pin.tempPin(user, "Pin9", coord1, cat);
  var pin10 = Pin.tempPin(user, "Pin10", coord1, cat);
  var pin11 = Pin.tempPin(user, "Pin11", coord1, cat);
  var pin12 = Pin.tempPin(user, "Pin12", coord1, cat);
  var pin13 = Pin.tempPin(user, "Pin13", coord1, cat);
  var pin14 = Pin.tempPin(user, "Pin14", coord1, cat);
  var review1 = new Review.wholeReview(pin1, user, DateTime.now(), "Comment 1", 001);
  var review2 = new Review.wholeReview(pin2, user, DateTime.now(), "Comment 2", 002);
  var review3 = new Review.wholeReview(pin3, user, DateTime.now(), "Comment 3", 003);
  var review4 = new Review.wholeReview(pin4, user, DateTime.now(), "Comment 4", 004);
  var review5 = new Review.wholeReview(pin5, user, DateTime.now(), "Comment 5", 005);
  var review6 = new Review.wholeReview(pin6, user, DateTime.now(), "Comment 6", 006);
  var review7 = new Review.wholeReview(pin7, user, DateTime.now(), "Comment 7", 007);
  var review8 = new Review.wholeReview(pin8, user, DateTime.now(), "Comment 8", 008);
  var review9 = new Review.wholeReview(pin9, user, DateTime.now(), "Comment 9", 009);
  var review10 = new Review.wholeReview(pin10, user, DateTime.now(), "Comment 10", 010);
  var review11 = new Review.wholeReview(pin11, user, DateTime.now(), "Comment 11", 011);
  var review12 = new Review.wholeReview(pin12, user, DateTime.now(), "Comment 12", 012);
  var review13 = new Review.wholeReview(pin13, user, DateTime.now(), "Comment 13", 013);
  var review14 = new Review.wholeReview(pin14, user, DateTime.now(), "Comment 14", 014);
  user.addReview(review1);
  user.addReview(review2);
  user.addReview(review3);
  user.addReview(review4);
  user.addReview(review5);
  user.addReview(review6);
  user.addReview(review7);
  user.addReview(review8);
  user.addReview(review9);
  user.addReview(review10);
  user.addReview(review11);
  user.addReview(review12);
  user.addReview(review13);
  user.addReview(review14);

  return ListView.separated(
    separatorBuilder: (context, index) => Divider(
      color: Colors.black,
    ),
    itemCount: 14,
    itemBuilder: (context, index) {

      return YourReviewsListItem (
        name: user.getReview(index).pin.name,
        date: user.getReview(index).date,
        comment: user.getReview(index).content,

      );

    },
  );

}

//title: Text(user.getReview(index).pin.name),
//subtitle: Text(user.getReview(index).date.day.toString() + "/" + user.getReview(index).date.month.toString() +
//"/"+ user.getReview(index).date.year.toString() + " \n " + user.getReview(index).content),