import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:integrated_project/resources/database.dart';
import 'package:integrated_project/resources/review.dart';

class Account {
  static Account currentAccount;
  final String id;

  String _userName;
  String _email;

  int _visitedCount;

  List<Review> _reviews = List<Review>();
  List<Review> _helpful = List<Review>();

  Account(
    this.id, {
    email,
    userName,
  }) {
    this._email = email;
    this._userName = userName;
  }

  static Account fromFirebaseUser(FirebaseUser user) {
    return Account(
      user.uid,
      email: user.email,
      userName: user.displayName,
    );
  }

  String get userName => _userName;

  void updateUserName(String value) {
    _userName = value;
    // TODO: update DB
  }

  String get email => _email;

  void updateEmail(String value) {
    _email = email;
    // TODO: update DB
  }

  int get visitedCount => _visitedCount;

  void incVisitedCount() {
    _visitedCount++;
    // TODO: update DB
  }

  List<Review> get reviews => _reviews;

  void addReview(Review review) {
    _reviews.add(review);
    // TODO: update DB
  }

  List<Review> get helpful => _helpful;

  void addHelpful(Review review) {
    _helpful.add(review);
    // TODO: update DB
  }

  static Stream<List<Review>> getReviewsForUser() {
    return Database.reviewsByUser(currentAccount);
        /*.listen((onData) {
      onData.documentChanges.forEach((change) {
        DocumentSnapshot reviewSnapshot = change.document;
        reviews.add(
            Review.fromMap(reviewSnapshot.documentID, reviewSnapshot.data));
      });
    });
    return reviews;*/
  }
}
