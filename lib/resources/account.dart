import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:integrated_project/resources/database.dart';
import 'package:integrated_project/resources/review.dart';
import 'package:integrated_project/resources/pin.dart';

class Account {
  static Account currentAccount;
  final String id;
  String _userName;
  String _email;

  List<Pin> _visited = List<Pin>();
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

  int get visitedCount => _visited.length;

  void incVisited(Pin pin) {
    _visited.add(pin);
    // TODO: update DB
  }

  void decVisited(Pin pin) {
    _visited.remove(pin);
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
//  static Stream<List<Pin>> getVisited(BuildContext context) {
//    return Database.visitedByUser(currentAccount, context);
//  }
}
