import 'package:flutter/material.dart';
import 'package:integrated_project/resources/category.dart';
import 'package:integrated_project/widgets/radio_button_picker.dart';
import 'package:integrated_project/widgets/image_picker_box.dart';

class NewPinForm extends StatefulWidget {
  final GlobalKey formKey;
  final double drawerHeight;

  NewPinForm(this.formKey, this.drawerHeight);

  @override
  State<NewPinForm> createState() => NewPinFormState();
}

class NewPinFormState extends State<NewPinForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final imagePickerKey = GlobalKey<FormFieldState>();
  final categoryPickerKey = GlobalKey<RadioButtonPickerState>();

  @override
  Widget build(BuildContext context) {
    Widget imagePicker = ImagePickerBox(
      key: imagePickerKey,
      validator: (image) => image == null ? "Pin must have an image" : null,
    );

    Widget pinNameField = TextFormField(
      controller: nameController,
      decoration: InputDecoration(
        hintText: "Name of pin",
        border: UnderlineInputBorder(),
        contentPadding: EdgeInsets.all(10.0),
      ),
      validator: (value) => value.isEmpty ? 'Pin must have a name' : null,
    );

    Widget reviewBody = TextFormField(
      controller: bodyController,
      decoration: InputDecoration(
        hintText: "Review",
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
      ),
      validator: (value) => value.isEmpty ? "Pin must have a review" : null,
      maxLines: 5,
    );

    Widget pinForm = Form(
      key: widget.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          imagePicker,
          pinNameField,
          RadioButtonPicker(options: Category.all()),
        ],
      ),
    );

    return SizedBox(
      height: widget.drawerHeight,
      child: DefaultTabController(
        length: 2,
        child: TabBarView(children: [
          pinForm,
          reviewBody,
        ]),
      ),
    );
  }
}
