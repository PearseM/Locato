import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:integrated_project/resources/category.dart';
import 'package:integrated_project/widgets/radio_button_picker.dart';

class NewPinForm extends StatefulWidget {
  final GlobalKey formKey;

  NewPinForm(this.formKey);

  @override
  State<NewPinForm> createState() => NewPinFormState();
}

class NewPinFormState extends State<NewPinForm> {
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController bodyController = new TextEditingController();
  File image;

  int selected = 2;

  @override
  Widget build(BuildContext context) {
    Widget imagePicker = FormField(
      validator: (_) => image == null ? "Pin must have an image" : null,
      builder: (state) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100.0,
            height: 100.0,
            padding: EdgeInsets.all(4.0),
            child: OutlineButton(
              clipBehavior: Clip.antiAlias,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              onPressed: () {
                ImagePicker.pickImage(
                  source: ImageSource.gallery,
                ).then((value) {
                  setState(() {
                    image = value;
                  });
                });
              },
              child: image == null
                  ? Icon(
                      Icons.add_photo_alternate,
                      semanticLabel: "Add image",
                    )
                  : Image.file(
                      image,
                      width: 100.0,
                      height: 100.0,
                      semanticLabel: "Uploaded image",
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          state.hasError
              ? Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    state.errorText,
                    style: TextStyle(
                        color: Theme.of(context).errorColor,
                        fontSize: Theme.of(context).textTheme.caption.fontSize),
                  ),
                )
              : Container(),
        ],
      ),
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
        //border: OutlineInputBorder(),
      ),
      validator: (value) => value.isEmpty ? "Pin must have a review" : null,
      maxLines: 5,
    );

    return Container(
      child: Form(
        key: widget.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            imagePicker,
            pinNameField,
            RadioButtonPicker(options: Category.all()),
            Divider(),
            SizedBox(height: 5.0),
            reviewBody,
            SizedBox(height: 5.0),
          ],
        ),
      ),
    );
  }
}
