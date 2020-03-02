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
  final GlobalKey<FormState> _formKey;

  final String id;
  final LatLng location;

  final Account author;
  final String name;

  Set<Category> _categories = Set<Category>();
  List<Review> _reviews = List<Review>();

  int _visitorCount = 0;

  Pin(
      this._formKey,
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

  List<Review> get reviews => _reviews;
  void addReview(Review review) {
    _reviews.add(review);
    review.pin = this;
    // TODO: update DB
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
        builder: (_) => PinInfoDrawer(_formKey, this),
      ),
    );
  }

  Map<String, dynamic> asMap() {
    Map<String, dynamic> pin = Map();
    pin["name"] = name;
    pin["location"] = GeoPoint(location.latitude, location.longitude);
    pin["visitorCount"] = _visitorCount;
    return pin;
  }
}
