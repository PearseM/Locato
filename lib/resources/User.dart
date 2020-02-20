import 'package:integrated_project/resources/Account.dart';
import 'package:integrated_project/resources/Review.dart';

class User extends Account{
  String _email;
  List<Review> _reviews;
  int _visitedCount;
  List<Review> _foundHelpful;

  void increaseVisited() {
    this._visitedCount++;
  }

  void addFoundHelpful(Review review) {
    this._foundHelpful.add(review);
  }

  void addReview(Review review) {
    this._reviews.add(review);
  }

  String get email => _email;

  int get visitedCount => _visitedCount;
}