import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integrated_project/resources/account.dart';
import 'package:integrated_project/resources/pin.dart';
import 'package:integrated_project/resources/review.dart';

class Database {
  static Stream<QuerySnapshot> getPins() {
    return Firestore.instance.collection("pins").snapshots();
  }

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

  static Stream<QuerySnapshot> getReviewsForPin(String pinID) {
    return Firestore.instance
        .collection("reviews")
        .where("pinID", isEqualTo: pinID)
        .orderBy("dateAdded", descending: true)
        .snapshots();
  }

  static Future<Review> getFirstReview(String pinID) async {
    QuerySnapshot review = await Firestore.instance
        .collection("reviews")
        .where("pinID", isEqualTo: pinID)
        .orderBy("dateAdded", descending: true)
        .limit(1)
        .snapshots()
        .first;
    DocumentSnapshot firstReviewDocument =
        review.documentChanges.first.document;
    return Review.fromMap(
        firstReviewDocument.documentID, firstReviewDocument.data);
  }

  static Future<Pin> newPin(LatLng location, String name, String reviewContent,
      Account author) async {
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
        ));
  }

  static Stream<List<Review>> reviewsByUser(Account account) {
    return Firestore.instance
        .collection("reviews")
        .where("author", isEqualTo: account.id)
        .snapshots().asyncMap((querySnapshot) async {
          Completer<List<Review>> reviewsCompleter = new Completer<List<Review>>();
          List<Review> reviews = [];
          for (DocumentSnapshot documentSnapshot in  querySnapshot.documents) {
            Map<String, dynamic> reviewMap = documentSnapshot.data;
            Review review = Review.fromMap(documentSnapshot.documentID, reviewMap);
            review.pin = await getPinByID(reviewMap["pinID"]);
            reviews.add(review);
          }
          reviewsCompleter.complete(reviews);
          return reviewsCompleter.future;
    });
  }

  static Future<Pin> getPinByID(String pinID) async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection("pins")
        .where(FieldPath.documentId, isEqualTo: pinID)
        .snapshots()
        .first;
    return Pin.fromMap(
        pinID, snapshot.documents.first.data, await getFirstReview(pinID));
  }
}
