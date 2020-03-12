import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integrated_project/resources/account.dart';
import 'package:integrated_project/resources/pin.dart';
import 'package:integrated_project/resources/review.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
          document["imageUrl"],
          firstReview,
          context,
        );
        pins.add(pin);
      }
      pinsListCompleter.complete(pins);
      return pinsListCompleter.future;
    });
  }

  static Future<File> getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    return image;
  }

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
      Account author, Future<File> image, BuildContext context) async {
    //Add the image to the database
    File actualImage = await image;
    var timeKey = new DateTime.now();
    final StorageReference postImageRef =
        FirebaseStorage.instance.ref().child("Pin Images");
    final StorageUploadTask uploadTask =
        postImageRef.child(timeKey.toString() + ".jpg").putFile(actualImage);
    var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    print(imageUrl);

    //Add the pin to the database
    DocumentReference newPin = await Firestore.instance
        .collection("pins")
        .add(Pin.newPinMap(name, location, author, imageUrl));

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
      imageUrl,
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


















  static Stream<List<Review>> getFavouriteReviewsForUser(Account account, BuildContext context) {
    Future<List<String>> reviewIDsF = getFavouriteReviewsIDs(account);
    Future<List<Review>> reviewsF = getReviewsByReviewIDs(reviewIDsF, context);
    Stream<List<Review>> stream = new Stream.fromFuture(reviewsF);

    return stream;
  }


  static Future<List<Review>> favouriteReviewsForUser(Account account, BuildContext context) async {
    Future<List<String>> reviewIDs = getFavouriteReviewsIDs(account);
    List<Review> reviews = await getReviewsByReviewIDs(reviewIDs, context);

    print(reviews.toString());
    print(reviews[0].id);
    print(reviews[0].author);
    print(reviews[0].body);

    return reviews;
  }

  static Future<List<String>> getFavouriteReviewsIDs(Account account) async {
    List users = await Firestore.instance
        .collection("users")
        .where("userID", isEqualTo: account.id)
        .getDocuments()
        .then((value) => value.documents);

    String user = users[0].documentID.toString();
    List reviewDocs = await Firestore.instance
        .collection("users")
        .document(user)
        .collection("favourites")
        .getDocuments()
        .then((val) => val.documents);

    List<String> reviewIds = [];
    for (var reviewDoc in reviewDocs) {
      reviewIds.add(reviewDoc.documentID.toString());
    }
    print(reviewIds.toString());

    return reviewIds;
  }

  static Future<List<Review>> getReviewsByReviewIDs(Future<List<String>> reviewIDsF, BuildContext context) async {
    List<Review> reviews = [];
    List<String> reviewIDs = await reviewIDsF;

    for (var reviewID in reviewIDs) {
      QuerySnapshot snapshot = await Firestore.instance
          .collection("reviews")
          .where(FieldPath.documentId, isEqualTo: reviewID)
          .snapshots()
          .first;
      DocumentSnapshot docSnap = snapshot.documents.first;
      Map<String, dynamic> reviewMap = docSnap.data;
      Review review = Review.fromMap(docSnap.documentID, reviewMap);
      review.pin = await getPinByID(reviewMap["pinID"], context);
      reviews.add(review);
    }

    return reviews;
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

  static void addUserToDatabase(Account user) {
    Firestore.instance.collection("users").add(user.asMap());
  }

  static Future<String> getUserNameByID(String id) {
    return Firestore.instance
        .collection("users")
        .where("userID", isEqualTo: id)
        .getDocuments()
        .then((snapshot) {
      return snapshot.documents.first.data["name"];
    });
  }
}
