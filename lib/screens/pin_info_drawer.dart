import 'package:flutter/material.dart';
import 'package:integrated_project/resources/pin.dart';
import 'package:integrated_project/resources/review.dart';

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
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              pin.name,
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.separated(
              controller: scrollController,
              itemCount: pin.reviews.length,
              separatorBuilder: (_, i) => Divider(),
              itemBuilder: (_, i) => ReviewItem(pin.reviews[i]),
            ),
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
