import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integrated_project/resources/database.dart';
import 'package:integrated_project/resources/review.dart';
import 'package:integrated_project/screens/map.dart';
import 'package:photo_view/photo_view.dart';
import 'package:integrated_project/resources/account.dart';

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
  Widget build (BuildContext context) {
    return Padding (
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Row (
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
    this.imgURL
  });

  final String name;
  final DateTime date;
  final String comment;
  final String imgURL;

  @override
  Widget build (BuildContext context) {
    return Padding (
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Row (
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: PinCustomListItem(
              name: name,
              date: date,
              comment: comment,
            ),
          ),
          SizedBox(
            height: 60,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text('Photo View'),
                      ),
                      body: PhotoView(
                        imageProvider: NetworkImage(
                          imgURL,
                        ),
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.covered * 2,
                        backgroundDecoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                        ),
                      ),
                    );
                  },
                )
                );
              },
              child: Image.network(
                imgURL,
                height: MediaQuery.of(context).size.height,
              ),
            ),
          ),
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
              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.1),
            ),
            Text(name),
            Text(
              date.day.toString().padLeft(2, '0') + "/" + date.month.toString().padLeft(2, '0') + "/" +date.year.toString()
                  + " " + date.hour.toString().padLeft(2, '0') + ":" + date.minute.toString().padLeft(2, '0'),
              style: TextStyle(color: Colors.black.withOpacity(0.4)),
            ),
          ]
      ),
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
              date.day.toString().padLeft(2, '0') + "/" + date.month.toString().padLeft(2, '0') + "/" +date.year.toString()
                  + " " + date.hour.toString().padLeft(2, '0') + ":" + date.minute.toString().padLeft(2, '0'),
              style: TextStyle(color: Colors.black.withOpacity(0.4)),
            ),
          ]
      ),
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

class FlaggedReviewsListItem extends ListTile{
  const FlaggedReviewsListItem({
    this.name,
    this.date,
    this.comment,
  });

  final String name;
  final DateTime date;
  final String comment;

  @override
  Widget build (BuildContext context) {
    return Padding (
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Row (
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
            icon: Icon(Icons.check),
            iconSize: 40.0,
            color: Color.fromRGBO(0, 255, 0, 1),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MapPage()));
            },
          ),
          IconButton(
            icon: Icon(Icons.close),
            iconSize: 40.0,
            color: Color.fromRGBO(255, 0, 0, 1),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MapPage()));
            },
          ),
        ],
      ),

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
      child: Row (
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
            icon: Icon(Icons.close),
            iconSize: 40.0,
            color: Colors.red[600],
            onPressed: () {
              Database.removeFavourite(Account.currentAccount, review.id);
            },
          ),
        ],
      ),
    );
  }
}
