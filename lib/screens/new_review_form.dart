import 'package:flutter/material.dart';
import 'package:integrated_project/resources/account.dart';
import 'package:integrated_project/resources/review.dart';

class NewReviewForm extends StatefulWidget {
  NewReviewForm(Key key) : super(key: key);

  State<NewReviewForm> createState() => NewReviewFormState();
}

class NewReviewFormState extends State<NewReviewForm> {
  GlobalKey<FormFieldState> bodyKey;
  TextEditingController bodyController;
  TextFormField bodyField;

  @override
  void initState() {
    bodyKey = GlobalKey<FormFieldState>();
    bodyController = TextEditingController();

    bodyField = TextFormField(
      key: bodyKey,
      autofocus: true,
      controller: bodyController,
      decoration: InputDecoration(
        hintText: "Review of pin",
        border: UnderlineInputBorder(),
        contentPadding: EdgeInsets.all(10.0),
      ),
      validator: (value) => value.isEmpty ? "Please enter a review" : null,
      maxLines: 5,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) => bodyField;

  bool isValid() => bodyKey.currentState.validate();

  Review getReview() => Review(
        null,
        Account.currentAccount,
        this.bodyController.text,
        DateTime.now(),
        0,
      );
}
