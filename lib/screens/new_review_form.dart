import 'package:flutter/material.dart';
import 'package:integrated_project/resources/account.dart';
import 'package:integrated_project/resources/review.dart';

class NewReviewForm extends StatefulWidget {
  NewReviewForm({Key key}) : super(key: key);

  State<NewReviewForm> createState() => NewReviewFormState();
}

class NewReviewFormState extends State<NewReviewForm>
    with AutomaticKeepAliveClientMixin<NewReviewForm> {
  GlobalKey<FormState> formKey;

  TextEditingController bodyController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    bodyController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Form(
      key: formKey,
      child: Column(children: <Widget>[
        TextFormField(
          controller: bodyController,
          decoration: InputDecoration(
            hintText: "Review notes",
            contentPadding: EdgeInsets.all(8.0),
          ),
          validator: (text) => text.isEmpty ? "Review must have notes" : null,
          maxLines: 5,
        ),
      ]),
    );
  }

  bool get isValid => formKey.currentState.validate();

  Review getReview() => Review(
        null,
        Account.currentAccount,
        this.bodyController.text,
        DateTime.now(),
        0,
      );
}
