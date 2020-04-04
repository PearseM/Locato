import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integrated_project/resources/account.dart';
import 'package:integrated_project/resources/category.dart';
import 'package:integrated_project/resources/database.dart';
import 'package:integrated_project/resources/pin.dart';
import 'package:integrated_project/resources/review.dart';
import 'package:integrated_project/screens/map.dart';
import 'package:integrated_project/screens/new_review_form.dart';
import 'package:integrated_project/widgets/radio_button_picker.dart';
import 'package:integrated_project/widgets/image_picker_box.dart';

class NewPinForm extends StatefulWidget {
  final double drawerHeight;

  NewPinForm(this.drawerHeight, {Key key}) : super(key: key);

  @override
  State<NewPinForm> createState() => NewPinFormState();
}

class NewPinFormState extends State<NewPinForm>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  GlobalKey<_PinFormState> pinFormKey;
  GlobalKey<NewReviewFormState> reviewFormKey;

  PinForm pinForm;
  NewReviewForm reviewForm;

  bool validate() {
    if (!pinFormKey.currentState.isValid) {
      tabController.animateTo(0);
      return false;
    }

    if (reviewFormKey.currentState == null ||
        !reviewFormKey.currentState.isValid) {
      tabController.animateTo(1);
      tabController.addListener(() => reviewFormKey.currentState.isValid);
      return false;
    }

    return true;
  }

  Future<Pin> createPin() async {
    Review review = reviewFormKey.currentState.getReview();
    return pinFormKey.currentState.createPin(review);
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);

    pinFormKey = GlobalKey<_PinFormState>();
    reviewFormKey = GlobalKey<NewReviewFormState>();

    pinForm = PinForm(key: pinFormKey);
    reviewForm = NewReviewForm(key: reviewFormKey);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.drawerHeight,
      child: TabBarView(controller: tabController, children: [
        pinForm,
        reviewForm,
      ]),
    );
  }
}

class PinForm extends StatefulWidget {
  PinForm({Key key}) : super(key: key);

  @override
  _PinFormState createState() => _PinFormState();
}

class _PinFormState extends State<PinForm>
    with AutomaticKeepAliveClientMixin<PinForm> {
  GlobalKey<FormState> formKey;
  GlobalKey<FormFieldState> imagePickerKey;
  GlobalKey<FormFieldState> categoryPickerKey;

  TextEditingController nameController;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    imagePickerKey = GlobalKey<FormFieldState>();
    categoryPickerKey = GlobalKey<FormFieldState>();

    nameController = TextEditingController();

    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Form(
      key: formKey,
      child: Column(children: <Widget>[
        ImagePickerBox(
          key: imagePickerKey,
          validator: (image) => image == null ? "Pin must have an image" : null,
        ),
        RadioButtonPicker(
          key: categoryPickerKey,
          validator: (option) =>
              option == null ? "Pin must have a category" : null,
          options: Category.all(),
        ),
        TextFormField(
          controller: nameController,
          validator: (text) => text.isEmpty ? "Pin must have a name" : null,
          decoration: InputDecoration(
            hintText: "Name of pin",
            contentPadding: EdgeInsets.all(8.0),
          ),
        ),
      ]),
    );
  }

  bool get isValid => formKey.currentState.validate();

  Future<Pin> createPin(Review review) async {
    File image = imagePickerKey.currentState.value;
    String name = nameController.text;
    Category category = categoryPickerKey.currentState.value;

    CameraPosition position =
        context.findAncestorStateOfType<MapPageState>().currentMapPosition;

    return Database.newPin(
      position.target,
      name,
      review,
      Account.currentAccount,
      image,
      category,
      context,
    );
  }
}
