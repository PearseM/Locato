import 'package:flutter/material.dart';

class PinInfoDrawer extends StatefulWidget {
  @override
  _PinInfoDrawerState createState() => _PinInfoDrawerState();
}

class _PinInfoDrawerState extends State<PinInfoDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.0,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 8.0, top: 8.0, bottom: 20.0,),
                  color: Colors.blue,
                  child: Text(
                    "Name of pin",
                    style: Theme.of(context).textTheme.title.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
