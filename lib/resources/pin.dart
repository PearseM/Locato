import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integrated_project/resources/database.dart';
import 'package:integrated_project/resources/review.dart';
import 'package:integrated_project/resources/account.dart';
import 'package:integrated_project/resources/category.dart';
import 'package:integrated_project/screens/pin_info_drawer.dart';

class Pin {
  String id;
  final LatLng location;

  final Account author;
  final String name;
  final String imageUrl;
  Marker marker;

  Set<Category> _categories = Set<Category>();
  Set<Review> _reviews = Set<Review>();

  int _visitorCount = 0;

  Pin(
    this.id,
    this.location,
    this.author,
    this.name,
    this.imageUrl,
    BuildContext context, {
    Review review,
  }) {
    marker = _createMarker(context, this);
    if (review != null) {
      _reviews.add(review);
      review.pin = this;
    }
  }

  Set<Category> get categories => _categories;

  void addCategory(Category value) {
    _categories.add(value);
    // TODO: update DB
  }

  Set<Review> get reviews => _reviews;

  ///Adds a review to the database
  void addReview(Review review) {
    _reviews.add(review);
    review.pin = this;
    Database.addReview(review);
  }

  int get visitorCount => _visitorCount;

  void incVisitorCount() {
    _visitorCount++;
    // TODO: update DB
  }

  static Marker _createMarker(BuildContext context, Pin pin) {
    return Marker(
      markerId: MarkerId(pin.id),
      position: pin.location,
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (_) => PinInfoDrawer(pin, pin.imageUrl),
        isScrollControlled: true,
      ),
    );
  }

  Map<String, dynamic> asMap() {
    Map<String, dynamic> pin = Map();
    pin["name"] = name;
    pin["location"] = GeoPoint(location.latitude, location.longitude);
    pin["visitorCount"] = _visitorCount;
    pin["author"] = author.id;
    pin["imageUrl"] = imageUrl;
    return pin;
  }

  static Map<String, dynamic> newPinMap(
      String name, LatLng location, Account author, String imageUrl) {
    Map<String, dynamic> pin = Map();
    pin["name"] = name;
    pin["location"] = GeoPoint(location.latitude, location.longitude);
    pin["visitorCount"] = 0;
    pin["author"] = author.id;
    pin["imageUrl"] = imageUrl;
    return pin;
  }

  static Pin fromMap(String id, Map<String, dynamic> pinMap, Review review,
      BuildContext context) {
    return Pin(
      id,
      LatLng(pinMap["location"].latitude, pinMap["location"].longitude),
      Account(pinMap["author"]),
      pinMap["name"],
      pinMap["imageUrl"],
      context,
      review: review,
    );
  }
}
