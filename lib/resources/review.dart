import 'package:integrated_project/resources/account.dart';

class Review {
  final String id;

  final Account author;
  final DateTime timestamp;

  String _body;

  int _flagCount;

  Review(this.id, this.author, this.timestamp);

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
}