import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integrated_project/screens/map.dart';

class YourReviewsListItem extends ListTile {
  const YourReviewsListItem({
    this.name,
    this.date,
    this.comment,
    this.location,
  });

  final String name;
  final DateTime date;
  final String comment;
  final LatLng location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: CustomListItem(
              name: name,
              date: date,
              comment: comment,
            ),
          ),
          IconButton(
            icon: Icon(Icons.keyboard_arrow_right),
            iconSize: 40.0,
            color: Color.fromRGBO(0, 0, 0, 0.3),
            tooltip: 'Increase volume by 10',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MapPage(
                            currentMapPosition: location,
                          )));
            },
          ),
        ],
      ),
    );
  }
}

class PinListItem extends ListTile {
  const PinListItem({
    this.name,
    this.date,
    this.comment,
  });

  final String name;
  final DateTime date;
  final String comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: CustomListItem(
              name: name,
              date: date,
              comment: comment,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomListItem extends ListTile {
  const CustomListItem({
    this.name,
    this.date,
    this.comment,
  });

  final bool enabled = true;
  final String name;
  final DateTime date;
  final String comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              style:
                  DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.3),
            ),
            Text(comment),
            Text(
              date.day.toString() +
                  "/" +
                  date.month.toString() +
                  "/" +
                  date.year.toString() +
                  " " +
                  date.hour.toString() +
                  ":" +
                  date.minute.toString(),
              style: TextStyle(color: Colors.black.withOpacity(0.4)),
            ),
          ]),
//      onTap: () {
//        Navigator.push(context,
//            MaterialPageRoute(builder: (context) => MapPage()));
//      },
//      onLongPress: (){
//        // do something else
//      },
      //selected: true,
      //trailing: Icon(Icons.keyboard_arrow_right),
    );
  }
}
