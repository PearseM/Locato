import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integrated_project/resources/Category.dart';
import 'package:integrated_project/resources/Review.dart';
import 'package:integrated_project/resources/User.dart';

class Pin {
  User _author;
  String _name;
  LatLng _coords;
  List<Category> _category;
  List<Review> _reviews;
  int _visitorCount;
  int _id;


  Pin.oldPin(this._id);

  Pin.newPin(this._author, this._name, this._coords, this._category, Review review) {
    this._reviews.add(review);
  }
  Pin.tempPin(this._author, this._name, this._coords, this._category);

  void _updateDatabase() {

  }

  void addReview(Review review) {
    this._reviews.add(review);
  }

  void addVisitor() {
    this._visitorCount++;
  }

  int get visitorCount => _visitorCount;

  List<Review> get reviews => _reviews;

  List<Category> get category => _category;

  LatLng get coords => _coords;

  String get name => _name;

  set name(String value) {
    _name = value;
  }


}