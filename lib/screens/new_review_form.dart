import 'package:flutter/material.dart';
import 'package:integrated_project/resources/account.dart';
import 'package:integrated_project/resources/pin.dart';
import 'package:integrated_project/resources/review.dart';

class NewReviewForm extends StatelessWidget {
  final GlobalKey _formKey;
  final Pin _pin;

  final TextEditingController bodyController = new TextEditingController();

  NewReviewForm(this._formKey, this._pin);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.0, right: 8.0),
                      child: BackButton(
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.0, right: 8.0),
                      child: RaisedButton.icon(
                        icon: Icon(Icons.save),
                        shape: StadiumBorder(),
                        color: Theme.of(context).accentColor,
                        textColor: Colors.white,
                        label: Text("Save review"),
                        onPressed: () {
                          Review review = Review(
                              null,
                              Account.currentAccount,
                              this.bodyController.text,
                              DateTime.now(),
                              0);
                          _pin.addReview(review);
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ]),
            ),
            SizedBox(height: 10),
            TextFormField(
              autofocus: true,
              controller: bodyController,
              decoration: InputDecoration(
                hintText: "Review of pin",
                border: UnderlineInputBorder(),
                contentPadding: EdgeInsets.all(10.0),
                //border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value.isEmpty ? "Please enter a review" : null,
              maxLines: 5,
            ),
          ],
        ),
      ),
    ));
  }
}
