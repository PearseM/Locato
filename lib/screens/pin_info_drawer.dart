import 'package:flutter/material.dart';
import 'package:integrated_project/resources/pin.dart';
import 'package:integrated_project/resources/review.dart';
import 'package:integrated_project/screens/comment_tile.dart';

class PinInfoDrawer extends StatelessWidget {
  final Pin pin;

  PinInfoDrawer(this.pin);

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
                  child: Text(
                    pin.name,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ]
          ),
          Expanded(
            child: Stack(children: [
              ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                ),
                itemCount: pin.reviews.length * 25,
                itemBuilder: (context, index) {
                  Review review = pin.reviews[0];

                  return PinListItem(
                    name: review.pin.name,
                    date: review.timestamp,
                    comment: review.body,
                  );
                },
                //controller: scrollController,
                //itemCount: pin.reviews.length * 25,
                //separatorBuilder: (_, i) => Divider(),
                //itemBuilder: (_, i) => ReviewItem(pin.reviews[0]),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 4.0, right: 8.0),
                  child: RaisedButton.icon(
                    onPressed: () {},
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
