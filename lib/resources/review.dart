import 'package:integrated_project/resources/account.dart';
import 'package:integrated_project/resources/pin.dart';

class Review {
  final String id;

  final Account author;
  final DateTime timestamp;

  Pin pin; // set by review when adopted

  String _body;

  int _flagCount;

  Review(this.id, this.author, this._body, this.timestamp);

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