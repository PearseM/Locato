import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integrated_project/resources/review.dart';
import 'package:integrated_project/resources/account.dart';

// TODO: decide on categories
enum Category {
  landscape,
  mountain,
  water,
  night,
}

class Pin {
  final String id;
  final LatLng location;

  final Account author;
  final String name;

  Set<Category> _categories;
  List<Review> _reviews;

  int _visitorCount;

  Pin(
    this.id,
    this.location,
    this.author,
    this.name,
  );

  Set<Category> get categories => _categories;
  void addCategory(Category value) {
    _categories.add(value);
    // TODO: update DB
  }

  List<Review> get reviews => _reviews;
  void addReview(Review review) {
    _reviews.add(review);
    // TODO: update DB
  }

  int get visitorCount => _visitorCount;
  void incVisitorCount() {
    _visitorCount++;
    // TODO: update DB
  }
}
