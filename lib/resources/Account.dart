class Account {
  String _userID;
  String _userName;

  String get userID => _userID;

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
  }
}