import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integrated_project/resources/account.dart';
import 'package:integrated_project/resources/pin.dart';
import 'package:integrated_project/resources/review.dart';

class Database {
  static Stream<List<Pin>> getPins(BuildContext context) {
    return Firestore.instance
        .collection("pins")
        .snapshots()
        .asyncMap((snapshot) async {
      Completer<List<Pin>> pinsListCompleter = Completer<List<Pin>>();
      List<Pin> pins = [];
      for (DocumentSnapshot document in snapshot.documents) {
        Review firstReview = await getFirstReview(document.documentID);
        Pin pin = Pin(
          document.documentID,
          LatLng(
            document["location"].latitude,
            document["location"].longitude,
          ),
          Account(document["author"]),
          document["name"],
          firstReview,
          context,
        );
        pins.add(pin);
      }
      pinsListCompleter.complete(pins);
      return pinsListCompleter.future;
    });
  }

  /*
  static void addPin(Pin pin) async {
    //Add the pin to the database
    DocumentReference newPin =
        await Firestore.instance.collection("pins").add(pin.asMap());
    //Convert the first review to a map
    Map<String, dynamic> initialReviewMap = pin.reviews.elementAt(0).asMap();
    //Add the pin's ID to the review's map
    initialReviewMap["pinID"] = newPin.documentID;
    //Add the review to the database
    DocumentReference initialReview =
        await Firestore.instance.collection("reviews").add(initialReviewMap);

    //Give the pin its databaseID
    pin.id = newPin.documentID;
    //Give the initial review its database ID
    pin.reviews.elementAt(0).id = initialReview.documentID;
  }
   */

  static Stream<List<Review>> getReviewsForPin(String pinID) {
    return Firestore.instance
        .collection("reviews")
        .where("pinID", isEqualTo: pinID)
        .snapshots()
        .map((snapshot) {
      List<Review> reviews = [];
      for (DocumentSnapshot document in snapshot.documents) {
        Review review = Review.fromMap(document.documentID, document.data);
        reviews.add(review);
      }
      reviews.sort((firstReview, secondReview) =>
          firstReview.timestamp.compareTo((secondReview.timestamp)));
      return reviews;
    });
  }

  static Future<Review> getFirstReview(String pinID) async {
    return await Firestore.instance
        .collection("reviews")
        .where("pinID", isEqualTo: pinID)
        //.orderBy("dateAdded", descending: true)
        .limit(1)
        .snapshots()
        .first
        .then((snapshot) {
      DocumentSnapshot firstReviewDocument =
          snapshot.documentChanges.first.document;
      return Review.fromMap(
          firstReviewDocument.documentID, firstReviewDocument.data);
    });
  }

  static Future<Pin> newPin(LatLng location, String name, String reviewContent,
      Account author, BuildContext context) async {
    //Add the pin to the database
    DocumentReference newPin = await Firestore.instance
        .collection("pins")
        .add(Pin.newPinMap(name, location, author));

    //Create map for initial review
    Map<String, dynamic> initialReviewMap =
        Review.newReviewMap(author, reviewContent, newPin.documentID);

    //Add the review to the database
    DocumentReference initialReview =
        await Firestore.instance.collection("reviews").add(initialReviewMap);

    return Pin(
      newPin.documentID,
      location,
      author,
      name,
      Review(
        initialReview.documentID,
        author,
        reviewContent,
        initialReviewMap["dateAdded"].toDate(),
        0,
      ),
      context,
    );
  }

  static Stream<List<Review>> reviewsByUser(
      Account account, BuildContext context) {
    return Firestore.instance
        .collection("reviews")
        .where("author", isEqualTo: account.id)
        .snapshots()
        .asyncMap((querySnapshot) async {
      Completer<List<Review>> reviewsCompleter = new Completer<List<Review>>();
      List<Review> reviews = [];
      for (DocumentSnapshot documentSnapshot in querySnapshot.documents) {
        Map<String, dynamic> reviewMap = documentSnapshot.data;
        Review review = Review.fromMap(documentSnapshot.documentID, reviewMap);
        review.pin = await getPinByID(reviewMap["pinID"], context);
        reviews.add(review);
      }
      reviewsCompleter.complete(reviews);
      return reviewsCompleter.future;
    });
  }

  static Future<Pin> getPinByID(String pinID, BuildContext context) async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection("pins")
        .where(FieldPath.documentId, isEqualTo: pinID)
        .snapshots()
        .first;
    return Pin.fromMap(pinID, snapshot.documents.first.data,
        await getFirstReview(pinID), context);
  }

  ///Adds the specified review to the database. The review should already have
  ///its pinID attribute set.
  static void addReview(Review review) {
    Firestore.instance.collection("reviews").add(review.asMap());
  }
}
