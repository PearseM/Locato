import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:integrated_project/resources/database.dart';
import 'package:integrated_project/resources/pin.dart';
import 'package:integrated_project/resources/review.dart';
import 'package:integrated_project/screens/new_review_form.dart';
import 'package:integrated_project/screens/comment_tile.dart';
import 'package:photo_view/photo_view.dart';

class PinInfoDrawer extends StatelessWidget {
  final GlobalKey<FormState> _formKey;
  final Pin pin;
  final imgURL;

  PinInfoDrawer(this._formKey, this.pin, this.imgURL);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.75,
      builder: (_, scrollController) => Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppBar(
              title: Text(pin.name),
              shape: Theme.of(context).bottomSheetTheme.shape,
              actions: <Widget>[
                GestureDetector(
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
                IconButton(
                  icon: Icon(Icons.content_copy),
                  color: Colors.white,
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: pin.id.hashCode.toString()));
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
            Expanded(child: ReviewList(pin, scrollController)),
          ],
        ),
        Container(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.all(8.0),
          child: FloatingActionButton.extended(
            onPressed: () => [
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (_) => NewReviewForm(_formKey, pin),
              ),
            ],
            icon: Icon(Icons.add),
            label: Text("Add review"),
          ),
        ),
      ]),
    );
  }
}

class ReviewList extends StatelessWidget {
  final Pin pin;
  final ScrollController scrollController;

  ReviewList(this.pin, this.scrollController);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Review>>(
      stream: Database.getReviewsForPin(pin.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data.isEmpty) {
          return Center(child: Text("No reviews"));
        } else {
          return ListView.separated(
            controller: scrollController,
            itemCount: snapshot.data.length,
            separatorBuilder: (_, i) => Divider(color: Colors.black),
            itemBuilder: (_, i) {
              Review review = snapshot.data.elementAt(i);
              return FutureBuilder(
                future: review.author.userName,
                builder: (context, nameSnapshot) {
                  return (nameSnapshot.hasData)
                      ? PinListItem(
                          name: nameSnapshot.data ?? "Unknown",
                          date: review.timestamp,
                          comment: review.body,
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                },
              );
            },
          );
        }
      },
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
