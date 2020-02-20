import 'package:integrated_project/resources/Pin.dart';
import 'package:integrated_project/resources/Account.dart';

class Review {
  Pin _pin;
  Account _author;
  DateTime _date;
  String _content;
  bool _flagged = false;
  int _id;


  Review.wholeReview(this._pin, this._author, this._date, this._content, this._id);

  Review.partReview(this._pin,  this._author, this._content);

  bool get flagged => _flagged;

  String get content => _content;

  DateTime get date => _date;

  Account get author => _author;

  Pin get pin => _pin;
}