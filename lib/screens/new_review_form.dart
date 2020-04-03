import 'package:flutter/material.dart';
import 'package:integrated_project/resources/account.dart';
import 'package:integrated_project/resources/option.dart';
import 'package:integrated_project/resources/review.dart';
import 'package:integrated_project/resources/tag.dart';
import 'package:integrated_project/widgets/check_box_picker.dart';

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
        CheckBoxPicker(
          options: Tag.all(),
          validator: (value) =>
              // TODO: does a review NEED tags?
              value.isEmpty ? "Review must have tags" : null,
        ),
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
