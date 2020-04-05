import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integrated_project/resources/account.dart';
import 'package:integrated_project/resources/pin.dart';
import 'package:integrated_project/resources/tag.dart';

class Review {
  String id;

  final Account author;
  final DateTime timestamp;

  Pin pin; // set by review when adopted

  String _body;

  int _flagCount;
  Set<Tag> tags = Set();

  bool tripod;
  String iso;
  String shutterSpeed;
  String aperture;

  Review(this.id, this.author, this._body, this.timestamp, this._flagCount,
      {tags, tripod, iso, shutterSpeed, aperture}) {
    if (tags != null) this.tags = tags;
    if (tripod != null) this.tripod = tripod;
    if (iso != null) this.iso = iso;
    if (shutterSpeed != null) this.shutterSpeed = shutterSpeed;
    if (aperture != null) this.aperture = aperture;
  }

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
    review["tripod"] = tripod;
    review["iso"] = iso;
    review["shutterSpeed"] = shutterSpeed;
    review["aperture"] = aperture;
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
      tripod: data["tripod"],
      iso: data["iso"],
      shutterSpeed: data["shutterSpeed"],
      aperture: data["aperture"],
    );
  }
}
