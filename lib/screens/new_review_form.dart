import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  TextEditingController isoController;
  TextEditingController shutterSpeedController;
  TextEditingController apertureController;

  Set<Tag> tags = Set();
  bool tripod = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    bodyController = TextEditingController();
    isoController = TextEditingController();
    shutterSpeedController = TextEditingController();
    apertureController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(children: <Widget>[
          CheckBoxPicker(
            options: Tag.all(),
            onSaved: (Set<Option> tags) {
              setState(() {
                for (Option option in tags) {
                  this.tags.add(option);
                }
              });
              return;
            },
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Text(
                  "Camera settings (optional):",
                  style: Theme.of(context).textTheme.subhead,
                  textAlign: TextAlign.left,
                ),
                GridView.count(
                  childAspectRatio: 4,
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  children: <Widget>[
                    //TODO Get settings from review
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text("Tripod"),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Checkbox(
                        value: tripod,
                        onChanged: (value) {
                          setState(() {
                            tripod = value;
                          });
                        },
                        tristate: false,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text("ISO"),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: isoController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        validator: (input) => (input.length > 0)
                            ? ((int.parse(input) < 0)
                                ? "ISO must be greater than 0."
                                : null)
                            : null,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text("Shutter speed"),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: shutterSpeedController,
                        validator: (input) {
                          final RegExp shutterSpeedRegEx =
                              RegExp("[0-9]([0-9])*((/([0-9]*))|\$)");
                          if (input.length == 0)
                            return null;
                          else if (!shutterSpeedRegEx.hasMatch(input)) {
                            return "Shutter speed should be an integer or a fraction (e.g. 1/200)";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text("Aperture (f/\u2026)"),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: apertureController,
                        validator: (input) {
                          final RegExp shutterSpeedRegEx =
                              RegExp("[0-9]([0-9]*)((\\.[0-9][0-9]*)|\$)");
                          if (input.length == 0)
                            return null;
                          else if (!shutterSpeedRegEx.hasMatch(input)) {
                            return "Aperture should be an integer or a decimal value.";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  bool get isValid => formKey.currentState.validate();

  Review getReview() {
    formKey.currentState.save();
    return Review(
      null,
      Account.currentAccount,
      this.bodyController.text,
      DateTime.now(),
      0,
      tags: this.tags,
      tripod: tripod,
      iso: isoController.text,
      shutterSpeed: shutterSpeedController.text,
      aperture: apertureController.text,
    );
  }
}
