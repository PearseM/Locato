import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integrated_project/resources/account.dart';
import 'package:integrated_project/resources/pin.dart';

class Review {
  String id;

  final Account author;
  final DateTime timestamp;

  Pin pin; // set by review when adopted

  String _body;

  int _flagCount;

  Review(this.id, this.author, this._body, this.timestamp, this._flagCount);

  String get body => _body;

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(other) {
    return id == other.id;
  }

  void updateBody(String value) {
    _body = value;
    // TODO: update DB
  }

  int get flagCount => _flagCount;

  void incFlagCount() {
    _flagCount++;
    // TODO: update DB
  }

  Map<String, dynamic> asMap() {
    Map<String, dynamic> review = Map();
    review["author"] = author.id;
    review["dateAdded"] = Timestamp.fromDate(timestamp);
    review["content"] = _body;
    review["flagCount"] = _flagCount;
    review["pinID"] = pin?.id;
    return review;
  }

  static Map<String, dynamic> newReviewMap(Review review, String pinID) {
    Map<String, dynamic> map = review.asMap();
    map["pinID"] = pinID;
    return map;
  }

  static Review fromMap(String id, Map<String, dynamic> data) {
    return Review(
      id,
      Account(data["author"]),
      data["content"],
      data["dateAdded"].toDate(),
      data["flagCount"],
    );
  }
}
