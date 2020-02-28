import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integrated_project/resources/review.dart';
import 'package:integrated_project/resources/account.dart';
import 'package:integrated_project/screens/pin_info_drawer.dart';

// TODO: decide on categories
enum Category {
  landscape,
  mountain,
  water,
  night,
}

class Pin {
  String id;
  final LatLng location;

  final Account author;
  final String name;

  Set<Category> _categories = Set<Category>();
  Set<Review> _reviews = Set<Review>();

  int _visitorCount = 0;

  Pin(
    this.id,
    this.location,
    this.author,
    this.name,
    Review review,
  ) {
    addReview(review);
  }

  Set<Category> get categories => _categories;

  void addCategory(Category value) {
    _categories.add(value);
    // TODO: update DB
  }

  Set<Review> get reviews => _reviews;

  void addReview(Review review) {
    _reviews.add(review);
    review.pin = this;
  }

  int get visitorCount => _visitorCount;

  void incVisitorCount() {
    _visitorCount++;
    // TODO: update DB
  }

  Marker createMarker(BuildContext context) {
    return Marker(
      markerId: MarkerId(id),
      position: this.location,
      onTap: () => showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) => PinInfoDrawer(this),
      ),
    );
  }

  Map<String, dynamic> asMap() {
    Map<String, dynamic> pin = Map();
    pin["name"] = name;
    pin["location"] = GeoPoint(location.latitude, location.longitude);
    pin["visitorCount"] = _visitorCount;
    pin["author"] = author.id;
    return pin;
  }

  static Map<String, dynamic> newPinMap(
      String name, LatLng location, Account author) {
    Map<String, dynamic> pin = Map();
    pin["name"] = name;
    pin["location"] = GeoPoint(location.latitude, location.longitude);
    pin["visitorCount"] = 0;
    pin["author"] = author.id;
    return pin;
  }

  static Pin fromMap(String id, Map<String, dynamic> pinMap, Review review) {
    return Pin(
        id,
        LatLng(pinMap["location"].latitude, pinMap["location"].longitude),
        Account(pinMap["author"]),
        pinMap["name"],
        review);//TODO think about this
  }
}
