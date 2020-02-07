import 'package:flutter/material.dart';
import 'package:integrated_project/screens/map_drawer.dart';
import 'package:integrated_project/screens/pin_info_drawer.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Title"),
      ),
      drawer: MapDrawer(),
      floatingActionButton: PinButton(),
    );
  }
}

class PinButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.location_on),
      onPressed: () {
        showBottomSheet(
          context: context,
          builder: (context) => PinInfoDrawer(),
        );
      },
    );
  }
}

