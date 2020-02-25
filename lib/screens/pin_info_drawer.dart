import 'package:flutter/material.dart';
import 'package:integrated_project/resources/pin.dart';

class PinInfoDrawer extends StatelessWidget {
  final Pin pin;

  PinInfoDrawer(this.pin);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.75,
      builder: (_, scrollController) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              left: 8.0,
              top: 8.0,
              bottom: 20.0,
            ),
            child: Text(
              pin.name,
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.separated(
              controller: scrollController,
              itemCount: 25,
              separatorBuilder: (_, i) => Divider(),
              itemBuilder: (_, i) => Text("Review " + i.toString()),
            ),
          ),
        ],
      ),
    );
  }
}
