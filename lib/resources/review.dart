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
    return review;
  }

  static Map<String, dynamic> newReviewMap(
      Account author, String content, String pinID) {
    Map<String, dynamic> review = Map();
    review["author"] = author.id;
    review["dateAdded"] = Timestamp.now();
    review["content"] = content;
    review["flagCount"] = 0;
    review["pinID"] = pinID;
    return review;
  }

  /*static Review fromMap(Map<String, dynamic> data) {
    return Review(id, author, _body, timestamp, _flagCount)
  }*/
}
