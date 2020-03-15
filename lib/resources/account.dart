import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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

  Future<String> get userName async {
    if (_userName != null) return _userName;
    else return Database.getUserNameByID(id);
  }

  static updateUserName(String value) async {
    Account.currentAccount._userName = value;
    Database.updateUsername(value);

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var newInfo = UserUpdateInfo();
    newInfo.displayName = value;
    user.updateProfile(newInfo);
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

  Map<String, dynamic> asMap() {
    Map<String, dynamic> accountMap = Map();
    accountMap["userID"] = id;
    accountMap["name"] = _userName;
    accountMap["email"] = _email;
    accountMap["isAdmin"] = false;
    return accountMap;
  }

  static Stream<List<Review>> getReviewsForUser(BuildContext context) {
    return Database.reviewsByUser(currentAccount, context);
  }

  static Future<Stream<List<Review>>> getDEF(BuildContext context) {
    return Database.getFavouriteReviewsForUser(currentAccount, context);
  }
}
