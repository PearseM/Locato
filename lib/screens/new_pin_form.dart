import 'package:flutter/material.dart';

class NewPinForm extends StatelessWidget {
  static GlobalKey _formKey;

  final TextEditingController nameController = new TextEditingController();
  final TextEditingController bodyController = new TextEditingController();

  NewPinForm(GlobalKey formKey) {
    _formKey = formKey;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Name of pin",
                border: UnderlineInputBorder(),
                contentPadding: EdgeInsets.all(10.0),
              ),
              validator: (value) =>
                  value.isEmpty ? 'Pin must have a name' : null,
            ),
            SizedBox(height: 5.0),
            TextFormField(
              controller: bodyController,
              decoration: InputDecoration(
                hintText: "Description of pin",
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                //border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value.isEmpty ? "Pin must have description" : null,
              maxLines: 5,
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
