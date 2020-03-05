import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:integrated_project/resources/database.dart';
import 'package:integrated_project/resources/pin.dart';
import 'package:integrated_project/resources/review.dart';
import 'package:integrated_project/screens/new_review_form.dart';
import 'package:integrated_project/screens/comment_tile.dart';

class PinInfoDrawer extends StatelessWidget {
  final GlobalKey<FormState> _formKey;
  final Pin pin;

  PinInfoDrawer(this._formKey, this.pin);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.75,
      builder: (_, scrollController) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  color: Theme.of(context).accentColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        pin.name,
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(color: Colors.white),
                      ),
                      IconButton(
                        icon: Icon(Icons.content_copy),
                        color: Colors.white,
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: pin.id));
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                content: Text(
                                  "You have copied the id of this pin to your clipboard.",
                                  textAlign: TextAlign.center,
                                ),
                                actions: <Widget>[
                                  new FlatButton(
                                    child: new Text("Close"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          Expanded(
            child: Stack(children: [
              StreamBuilder<List<Review>>(
                stream: Database.getReviewsForPin(pin.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    return (snapshot.data.isEmpty)
                        ? Center(
                            child: Text("No reviews"),
                          )
                        : ListView.separated(
                            controller: scrollController,
                            itemCount: snapshot.data.length,
                            separatorBuilder: (_, i) => Divider(
                              color: Colors.black,
                            ),
                            itemBuilder: (_, i) {
                              Review review = snapshot.data.elementAt(i);
                              return FutureBuilder(
                                future: review.author.userName,
                                builder: (context, nameSnapshot) {
                                  return PinListItem(
                                    name: (nameSnapshot.connectionState ==
                                                ConnectionState.waiting ||
                                            nameSnapshot.data == null)
                                        ? "Unknown"
                                        : nameSnapshot.data,
                                    date: review.timestamp,
                                    comment: review.body,
                                  );
                                },
                              );
                            },
                          );
                  }
                },
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 4.0, right: 8.0),
                  child: RaisedButton.icon(
                    onPressed: () => [
                      //Navigator.of(context).pop(),
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (_) => NewReviewForm(_formKey, pin),
                      ),
                    ],
                    icon: Icon(Icons.add),
                    shape: StadiumBorder(),
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                    label: Text("Add review"),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class ReviewItem extends StatelessWidget {
  final Review review;

  ReviewItem(this.review);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Text(review.body),
    );
  }
}
