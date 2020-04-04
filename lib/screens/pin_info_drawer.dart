import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:integrated_project/resources/account.dart';
import 'package:integrated_project/resources/category.dart';
import 'package:integrated_project/resources/database.dart';
import 'package:integrated_project/resources/pin.dart';
import 'package:integrated_project/resources/review.dart';
import 'package:integrated_project/screens/new_review_form.dart';
import 'package:integrated_project/screens/comment_tile.dart';
import 'package:integrated_project/widgets/radio_button_picker.dart';
import 'package:photo_view/photo_view.dart';

class PinInfoDrawer extends StatefulWidget {
  final Pin pin;
  final imgURL;

  PinInfoDrawer(this.pin, this.imgURL);

  @override
  _PinInfoDrawerState createState() => _PinInfoDrawerState();
}

class _PinInfoDrawerState extends State<PinInfoDrawer> {
  GlobalKey<NewReviewFormState> reviewFormKey;

  @override
  void initState() {
    reviewFormKey = GlobalKey<NewReviewFormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

    Widget copyURLButton(context) => Builder(
          builder: (context) => IconButton(
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
          ),
        );

    Widget bar = SliverAppBar(
      pinned: true,
      floating: true,
      stretch: true,
      onStretchTrigger: () async {
        Navigator.maybePop(context);
      },
      expandedHeight: 250,
      actions: <Widget>[
        visitedButton,
        copyURLButton(context),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(widget.pin.name),
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.network(
              widget.imgURL,
              fit: BoxFit.cover,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.0, -0.5),
                  end: Alignment(0.0, -0.2),
                  colors: <Color>[
                    Theme.of(context).primaryColor.withOpacity(0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: "Write review",
        child: Icon(Icons.create),
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (_) => Scaffold(
            appBar: AppBar(actions: <Widget>[
              IconButton(
                icon: Icon(Icons.save),
                onPressed: () {
                  if (reviewFormKey.currentState.isValid) {
                    Review review = reviewFormKey.currentState.getReview();
                    widget.pin.addReview(review);
                    Navigator.pop(context);
                  }
                },
              )
            ]),
            body: NewReviewForm(key: reviewFormKey),
          ),
        ),
      ),
      body: StreamBuilder(
          stream: Database.getReviewsForPin(widget.pin.id),
          builder: (context, snapshot) {
            Widget progressIndicator = Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            );

            Category category = widget.pin.category;
            Widget categoryChip = Chip(
              label: Text(category.text),
              labelStyle: TextStyle(color: Colors.white),
              backgroundColor: category.colour,
            );

            return CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                bar,
                SliverToBoxAdapter(
                  child: Row(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text("Category:"),
                    ),
                    categoryChip,
                  ]),
                ),
                snapshot.hasData
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) => PinListItem(snapshot.data[i]),
                          childCount: snapshot.data.length,
                        ),
                      )
                    : SliverFillRemaining(
                        child: progressIndicator,
                        hasScrollBody: false,
                      ),
                SliverFillRemaining(hasScrollBody: false),
                SliverToBoxAdapter(
                  child: Padding(padding: EdgeInsets.all(1.0)),
                )
              ],
            );
          }),
    );
  }
}
