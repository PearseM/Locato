import 'package:flutter/material.dart';

class NewPinSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
                hintText: "Name of pin", border: UnderlineInputBorder()),
            validator: (value) {
              if (value.isEmpty) {
                return 'Pin must have a name';
              }
              return null;
            },
          )
        ],
      ),
    );
  }
}
