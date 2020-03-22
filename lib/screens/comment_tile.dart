import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integrated_project/resources/database.dart';
import 'package:integrated_project/resources/review.dart';
import 'package:integrated_project/screens/map.dart';

class YourReviewsListItem extends ListTile {
  const YourReviewsListItem({
    this.name,
    this.date,
    this.comment,
    this.location,
    this.url,
  });

  final String name;
  final DateTime date;
  final String comment;
  final LatLng location;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.network(
            url,
            height: 65,
            width: 100,
          ),
          Expanded(
            flex: 3,
            child: CustomListItem(
              name: name,
              date: date,
              comment: comment,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.keyboard_arrow_right,
              semanticLabel: "Go to pin",
            ),
            iconSize: 40.0,
            color: Color.fromRGBO(0, 0, 0, 0.3),
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

class PinListItem extends StatefulWidget {
  const PinListItem({this.name, this.date, this.comment, this.id});

  final String name;
  final DateTime date;
  final String comment;
  final String id;

  @override
  _PinListItemState createState() => _PinListItemState();
}

class _PinListItemState extends State<PinListItem> {
  bool isFlagged = false;
  bool isFavourite = false;

  @override
  void initState() {
    Database.isFlagged(widget.id).then((value) {
      setState(() {
        isFlagged = value;
      });
    });
    Database.isFavourite(widget.id).then((value) {
      setState(() {
        isFavourite = value;
      });
    });

    super.initState();
  }

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
            child: PinCustomListItem(
              name: widget.name,
              date: widget.date,
              comment: widget.comment,
            ),
          ),
          //Spacer(),
          IconButton(
              icon: Icon(
                isFlagged ? Icons.flag : Icons.outlined_flag,
                semanticLabel: "Flagged",
              ),
              onPressed: () {
                if (isFlagged) {
                  Database.unFlag(widget.id);
                } else {
                  Database.flag(widget.id);
                }
                setState(() {
                  isFlagged = !isFlagged;
                });
              }),
          IconButton(
              icon: Icon(
                isFavourite ? Icons.star : Icons.star_border,
                semanticLabel: "Favourite",
              ),
              onPressed: () {
                if (isFavourite) {
                  Database.removeFavourite(widget.id);
                } else {
                  Database.addFavourite(widget.id);
                }
                setState(() {
                  isFavourite = !isFavourite;
                });
              })
        ],
      ),
    );
  }
}

class PinCustomListItem extends ListTile {
  const PinCustomListItem({
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
              comment,
              style:
                  DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.1),
            ),
            Text(name),
            Text(
              date.day.toString().padLeft(2, '0') +
                  "/" +
                  date.month.toString().padLeft(2, '0') +
                  "/" +
                  date.year.toString() +
                  " " +
                  date.hour.toString().padLeft(2, '0') +
                  ":" +
                  date.minute.toString().padLeft(2, '0'),
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
              date.day.toString().padLeft(2, '0') +
                  "/" +
                  date.month.toString().padLeft(2, '0') +
                  "/" +
                  date.year.toString() +
                  " " +
                  date.hour.toString().padLeft(2, '0') +
                  ":" +
                  date.minute.toString().padLeft(2, '0'),
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

class StarredReviewsListItem extends ListTile {
  const StarredReviewsListItem(this.review);
  final Review review;

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
              name: review.pin.name,
              date: review.timestamp,
              comment: review.body,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.star,
              semanticLabel: "Remove",
            ),
            iconSize: 28.0,
            onPressed: () {
              Database.removeFavourite(review.id);
            },
          ),
        ],
      ),
    );
  }
}

class FlaggedReviewsListItem extends ListTile {
  const FlaggedReviewsListItem(this.review);

  final Review review;

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
              name: review.pin.name,
              date: review.timestamp,
              comment: review.body,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.check,
              semanticLabel: "Allow",
            ),
            iconSize: 40.0,
            color: Colors.grey[600],
            onPressed: () {
              Database.ignoreFlags(review.id);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete_forever,
              semanticLabel: "Delete",
            ),
            iconSize: 40.0,
            color: Colors.red,
            onPressed: () {
              Database.deleteReview(review);
            },
          ),
        ],
      ),
    );
  }
}
