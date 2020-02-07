import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integrated_project/screens/map_drawer.dart';
import 'package:integrated_project/screens/pin_info_drawer.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Title"),
      ),
      body: MapBody(),
      drawer: MapDrawer(),
      floatingActionButton: PinButton(),
    );
  }
}

class MapBody extends StatefulWidget {
  @override
  State<MapBody> createState() => MapBodyState();
}

class MapBodyState extends State<MapBody> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition uobPosition =
      CameraPosition(target: LatLng(51.3782261, -2.3285874), zoom: 14.4746);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        initialCameraPosition: uobPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
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
