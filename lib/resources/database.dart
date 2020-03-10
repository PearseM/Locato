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
          context,
          review: firstReview,
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
      if (snapshot.documents.length > 0) {
        DocumentSnapshot firstReviewDocument =
            snapshot.documentChanges.first.document;
        return Review.fromMap(
            firstReviewDocument.documentID, firstReviewDocument.data);
      } else
        return null;
    });
  }

  static Future<Review> getReviewByID(
      String reviewID, BuildContext context) async {
    return await Firestore.instance
        .collection("reviews")
        .where(FieldPath.documentId, isEqualTo: reviewID)
        .limit(1)
        .snapshots()
        .first
        .then((snapshot) {
      if (snapshot.documents.length > 0) {
        DocumentSnapshot firstReviewDocument =
            snapshot.documentChanges.first.document;
        Review review = Review.fromMap(
            firstReviewDocument.documentID, firstReviewDocument.data);
        return getPinByID(firstReviewDocument.data["pinID"], context)
            .then((pin) {
          review.pin = pin;
          return review;
        });
      } else
        return null;
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
      context,
      review: Review(
        initialReview.documentID,
        author,
        reviewContent,
        initialReviewMap["dateAdded"].toDate(),
        0,
      ),
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

  /// Removes a flag from a review.
  ///
  /// Removes the currently logged in user's flag from the review indicated by
  /// [id].
  static void unFlag(String id) {
    Firestore.instance
        .collection("flags")
        .where("reviewID", isEqualTo: id)
        .where("userID", isEqualTo: Account.currentAccount.id)
        .getDocuments()
        .then((snapshot) {
      if (snapshot.documents.length > 0)
        snapshot.documents.first.reference.delete();
    });
  }

  /// Marks a review as flagged.
  ///
  /// Flags a review, indicated by [id] in the database, as the currently logged
  /// in user.
  static void flag(String id) {
    Map<String, dynamic> flag = Map();
    flag["reviewID"] = id;
    flag["userID"] = Account.currentAccount.id;
    Firestore.instance.collection("flags").add(flag);
  }

  /// Checks if the currently logged in user has flagged this review.
  ///
  /// Queries the database to determine whether the currently logged in user has
  /// flagged the review specified by [id].
  static Future<bool> isFlagged(id) {
    return Firestore.instance
        .collection("flags")
        .where("reviewID", isEqualTo: id)
        .where("userID", isEqualTo: Account.currentAccount.id)
        .getDocuments()
        .then((snapshot) {
      return (snapshot.documents.length > 0);
    });
  }

  static Future<bool> isAdmin() {
    return Firestore.instance
        .collection("users")
        .where("userID", isEqualTo: Account.currentAccount.id)
        .getDocuments()
        .then((snapshot) => snapshot.documents.first.data["isAdmin"]);
  }

  /// Returns all of the reviews that are currently flagged.
  static Stream<List<Review>> flaggedReviews(BuildContext context) {
    return Firestore.instance
        .collection("flags")
        .snapshots()
        .asyncMap((querySnapshot) async {
      Completer<List<Review>> reviewsCompleter = new Completer<List<Review>>();
      List<Review> reviews = [];
      for (DocumentSnapshot documentSnapshot in querySnapshot.documents) {
        Review review =
            await getReviewByID(documentSnapshot.data["reviewID"], context);
        reviews.add(review);
      }
      reviewsCompleter.complete(reviews);
      return reviewsCompleter.future;
    });
  }

  /// Ignores any flags for this review.
  ///
  /// Deletes all flags that users have made for the review specified by [id].
  static void ignoreFlags(String id) {
    Firestore.instance
        .collection("flags")
        .where("reviewID")
        .getDocuments()
        .then((query) {
      query.documents.forEach((document) {
        document.reference.delete();
      });
    });
  }

  /// Deletes this review.
  ///
  /// Deletes [review] from the database, removing any flags that users created
  /// for it and gives a strike to its author.
  static void deleteReview(Review review) {
    ignoreFlags(review.id);
    Firestore.instance.collection("reviews").document(review.id).delete();
    addStrike(review.author.id);
  }

  static void addStrike(String id) {
    Firestore.instance
        .collection("users")
        .where("userID", isEqualTo: id)
        .getDocuments()
        .then((query) {
      query.documents.first.reference
          .updateData({"strikes": FieldValue.increment(1)});
    });
  }
}
