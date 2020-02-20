import 'package:integrated_project/resources/review.dart';

class Account {
  final String id;

  String _userName;
  String _email;

  int _visitedCount;

  List<Review> _reviews;
  List<Review> _helpful;

  Account(this.id);

  String get userName => _userName;
  void updateUserName(String value) {
    _userName = value;
    // TODO: update DB
  }

  String get email => _email;
  void updateEmail(String value) {
    _email = email;
    // TODO: update DB
  }

  int get visitedCount => _visitedCount;
  void incVisitedCount() {
    _visitedCount++;
    // TODO: update DB
  }

  List<Review> get reviews => _reviews;
  void addReview(Review review) {
    _reviews.add(review);
    // TODO: update DB
  }

  List<Review> get helpful => _helpful;
  void addHelpful(Review review) {
    _helpful.add(review);
    // TODO: update DB
  }
}
