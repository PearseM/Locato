import 'package:flutter/material.dart';

class NewPinSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                hintText: "Name of pin",
                border: UnderlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
              ),
              validator: (value) =>
                  value.isEmpty ? 'Pin must have a name' : null,
            ),
            SizedBox(height: 5.0),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Description of pin",
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                //border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value.isEmpty ? "Pin must have description" : null,
              maxLines: 5,
            )
          ],
        ),
      ),
    );
  }
}
