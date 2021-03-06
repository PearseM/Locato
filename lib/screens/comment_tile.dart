import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integrated_project/resources/database.dart';
import 'package:integrated_project/resources/review.dart';
import 'package:integrated_project/resources/tag.dart';
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
  const PinListItem(this.review);

  final Review review;

  @override
  _PinListItemState createState() => _PinListItemState();
}

class _PinListItemState extends State<PinListItem> {
  bool isFlagged = false;
  bool isFavourite = false;

  @override
  void initState() {
    Database.isFlagged(widget.review.id).then((value) {
      setState(() {
        isFlagged = value;
      });
    });
    Database.isFavourite(widget.review.id).then((value) {
      setState(() {
        isFavourite = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      child: InkWell(
        onTap: () => showDialog(
          context: context,
          builder: (context) => ReviewInfoDialog(widget.review),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.review.body,
              textScaleFactor: 1.1,
            ),
            Wrap(
              spacing: 8.0,
              children: List.generate(widget.review.tags.length, (i) {
                Tag tag = widget.review.tags.elementAt(i);
                return Chip(
                  label: Text(tag.text),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: tag.colour,
                );
              }),
            ),
            Row(children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FutureBuilder(
                    future: widget.review.author.userName,
                    builder: (_, snapshot) => Text(
                      (snapshot.hasData) ? snapshot.data : "Unknown",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    formatDate(widget.review.timestamp),
                    style: TextStyle(color: Colors.black.withOpacity(0.4)),
                  ),
                ],
              ),
              Spacer(),
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  isFlagged ? Icons.flag : Icons.outlined_flag,
                  semanticLabel: "Flagged",
                ),
                onPressed: () {
                  if (isFlagged) {
                    Database.unFlag(widget.review.id);
                  } else {
                    Database.flag(widget.review.id);
                  }
                  setState(() {
                    isFlagged = !isFlagged;
                  });
                },
              ),
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  isFavourite ? Icons.star : Icons.star_border,
                  semanticLabel: "Favourite",
                ),
                onPressed: () {
                  if (isFavourite) {
                    Database.removeFavourite(widget.review.id);
                  } else {
                    Database.addFavourite(widget.review.id);
                  }
                  setState(() {
                    isFavourite = !isFavourite;
                  });
                },
              ),
            ])
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime timestamp) =>
      timestamp.day.toString().padLeft(2, '0') +
      "/" +
      timestamp.month.toString().padLeft(2, '0') +
      "/" +
      timestamp.year.toString() +
      " " +
      timestamp.hour.toString().padLeft(2, '0') +
      ":" +
      timestamp.minute.toString().padLeft(2, '0');
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

class ReviewInfoDialog extends StatelessWidget {
  ReviewInfoDialog(this._review);

  final Review _review;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text("Review info",
                            style: Theme.of(context).textTheme.title),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(_review.body),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _review.timestamp.day.toString().padLeft(2, '0') +
                              "/" +
                              _review.timestamp.month
                                  .toString()
                                  .padLeft(2, '0') +
                              "/" +
                              _review.timestamp.year.toString() +
                              " " +
                              _review.timestamp.hour
                                  .toString()
                                  .padLeft(2, '0') +
                              ":" +
                              _review.timestamp.minute
                                  .toString()
                                  .padLeft(2, '0'),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Tags:",
                            style: Theme.of(context).textTheme.subhead,
                          ),
                          Row(
                            children: () {
                              List<Widget> chips = [];
                              for (Tag tag in _review.tags) {
                                chips.add(Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Chip(
                                    label: Text(tag.text),
                                    labelStyle: TextStyle(color: Colors.white),
                                    backgroundColor: tag.colour,
                                  ),
                                ));
                              }
                              return chips;
                            }(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Camera settings:",
                        style: Theme.of(context).textTheme.subhead,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.count(
                                childAspectRatio: 4,
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                children: <Widget>[
                                  //TODO Get settings from review
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Tripod"),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: (_review.tripod == null)
                                        ? Text("-")
                                        : Icon(((_review.tripod)
                                            ? Icons.check
                                            : Icons.clear)),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text("ISO"),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(_review.iso ?? "-"),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Shutter speed"),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(_review.shutterSpeed ?? "-"),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Aperture"),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child:
                                        Text("f/" + (_review.aperture ?? "-"))
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16)),
                color: Colors.blue,
              ),
              padding: EdgeInsets.all(16),
              child: Text(
                "Close",
                style: Theme.of(context).primaryTextTheme.button,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
