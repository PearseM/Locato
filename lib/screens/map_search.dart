import 'package:flutter/material.dart';

class MapSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // reset query on clear
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return BackButton(); // button before search query
  }

  @override
  Widget buildResults(BuildContext context) {
    return Column(); // TODO: add results
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column(); // TODO: add suggestions
  }
}