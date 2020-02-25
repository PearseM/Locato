import 'package:flutter/material.dart';

import 'package:integrated_project/resources/pin.dart';

class MapSearchDelegate extends SearchDelegate {
  final Set<Pin> pins;

  MapSearchDelegate(this.pins);

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
    List<Pin> results = List<Pin>();

    for (Pin pin in pins) {
      /* a much better algorithm would look for terms in the query separately
       * using a fuzzy-match and rank results based on how close they are to terms.
       */
      // if pin's name contains query, add as result
      if (pin.name.contains(RegExp(query, caseSensitive: false))) {
        results.add(pin);
      }
    }

    return ListView.separated(
      padding: EdgeInsets.all(8),
      itemCount: results.length,
      itemBuilder: (context, i) {
        return Container(
          height: 50,
          child: Align(
            child: Text(
              results[i].name,
              textScaleFactor: 1.2,
            ),
            alignment: Alignment.centerLeft,
          ),
        );
      },
      separatorBuilder: (context, i) {
        return Divider();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column(); // TODO: add suggestions
  }
}
