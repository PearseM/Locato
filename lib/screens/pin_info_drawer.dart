import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:integrated_project/resources/account.dart';
import 'package:integrated_project/resources/database.dart';
import 'package:integrated_project/resources/pin.dart';
import 'package:integrated_project/resources/review.dart';
import 'package:integrated_project/screens/new_review_form.dart';
import 'package:integrated_project/screens/comment_tile.dart';
import 'package:photo_view/photo_view.dart';

class PinInfoDrawer extends StatefulWidget {
  final Pin pin;
  final imgURL;

  PinInfoDrawer(this.pin, this.imgURL);

  @override
  _PinInfoDrawerState createState() => _PinInfoDrawerState();
}

class _PinInfoDrawerState extends State<PinInfoDrawer> {
  final reviewFormKey = GlobalKey<NewReviewFormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget imageView = Scaffold(
      appBar: AppBar(
        title: Text(widget.pin.name),
      ),
      body: PhotoView(
        imageProvider: NetworkImage(
          widget.imgURL,
        ),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2,
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
        ),
      ),
    );

    Widget visitedButton = StreamBuilder<List<String>>(
      stream: Database.visitedByUser(Account.currentAccount, context),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return Padding(
          padding: EdgeInsets.all(8.0),
          child: RaisedButton(
            child: Text("Visited"),
            onPressed: () {
              if (snapshot.data.contains(widget.pin.id)) {
                Database.deleteVisited(
                    Account.currentAccount.id, widget.pin.id);
              } else {
                Database.addVisited(Account.currentAccount.id, widget.pin.id);
              }
            },
            shape: StadiumBorder(),
            color: snapshot.data.contains(widget.pin.id)
                ? Colors.green
                : Theme.of(context).primaryColorDark,
            textColor: Theme.of(context).primaryTextTheme.button.color,
          ),
        );
      },
    );

    Widget image = GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => imageView),
      ),
      child: Image.network(
        widget.imgURL,
        loadingBuilder: (context, child, progress) {
          if (progress == null) {
            return child;
          }
          return Center(
            child: CircularProgressIndicator(backgroundColor: Colors.white),
          );
        },
        width: 50.0,
        height: MediaQuery.of(context).size.height,
        fit: BoxFit.cover,
      ),
    );

    Widget copyURLButton(context) => IconButton(
          icon: Icon(
            Icons.content_copy,
            semanticLabel: "Copy URL",
          ),
          color: Colors.white,
          onPressed: () {
            Clipboard.setData(
                ClipboardData(text: widget.pin.id.hashCode.toString()));
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("URL copied to clipboard."),
            ));
          },
        );

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.75,
      builder: (_, scrollController) => Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(widget.pin.name),
          shape: Theme.of(context).bottomSheetTheme.shape,
          actions: <Widget>[
            visitedButton,
            image,
            Builder(builder: copyURLButton),
          ],
        ),
        body: ReviewList(widget.pin, scrollController),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          tooltip: "Write review",
          onPressed: () => showModalBottomSheet(
            context: context,
            builder: (_) => Scaffold(
              appBar: AppBar(actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () {
                    if (reviewFormKey.currentState.isValid()) {
                      Review review = reviewFormKey.currentState.getReview();
                      widget.pin.addReview(review);
                      Navigator.pop(context);
                    }
                  },
                )
              ]),
              body: NewReviewForm(reviewFormKey),
            ),
          ),
          child: Icon(Icons.create),
        ),
      ),
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
                          id: review.id,
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
