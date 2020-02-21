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

  Set<Category> _categories = Set<Category>();
  List<Review> _reviews = List<Review>();

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

  Marker createMarker() {
    return Marker(
      markerId: MarkerId(id),
      position: this.location,
      // TODO: add onTap, infoWindow etc.
    );
  }
}
