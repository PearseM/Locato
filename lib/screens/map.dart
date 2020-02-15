import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integrated_project/screens/map_drawer.dart';
import 'package:integrated_project/screens/map_search.dart';
import 'package:integrated_project/screens/pin_info_drawer.dart';
import 'package:permission_handler/permission_handler.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      //Adds a margin at the top on Android devices to avoid the status bar
      top: (Theme
          .of(context)
          .platform == TargetPlatform.android),
      bottom: false,
      child: Scaffold(
        body: MapBody(),
        drawer: MapDrawer(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: PinButton(),
        resizeToAvoidBottomInset: false,
        // prevents map resizing with keyboard
        //extendBody: true, // puts map below the notched app bar
        // -- Removed this to prevent navbar from covering location button
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 4.0,
          child: MapBarContents(),
        ),
      ),
    );
  }
}

class MapBarContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: Icon(Icons.menu),
        ),
        Spacer(),
        //This is no longer needed as the location button is part of the map
        /*
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.gps_fixed),
        ),
         */
        IconButton(
          onPressed: () {
            showSearch(context: context, delegate: MapSearchDelegate());
          },
          icon: Icon(Icons.search),
        ),
      ],
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }
}

class MapBody extends StatefulWidget {
  @override
  State<MapBody> createState() => MapBodyState();
}

class MapBodyState extends State<MapBody> {
  GoogleMapController _controller;
  Map<PermissionGroup, PermissionStatus> _permissions;

  static final CameraPosition uobPosition =
  CameraPosition(target: LatLng(51.3782261, -2.3285874), zoom: 14.4746);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GoogleMap>(
      future: _createMap(),
      builder: (BuildContext context, AsyncSnapshot<GoogleMap> snapshot) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          // prevents map moving with keyboard
          body: snapshot.data,
        );
      },);
  }

  Future<GoogleMap> _createMap() async {
    Map<PermissionGroup, PermissionStatus> permissions =
    await PermissionHandler()
        .requestPermissions([PermissionGroup.locationWhenInUse]);
    setState(() {
      _permissions = permissions;
    });
    bool locationGranted = ((await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.locationWhenInUse))
        == PermissionStatus.granted);
    return GoogleMap(
      myLocationEnabled: locationGranted,
      myLocationButtonEnabled: locationGranted,
      initialCameraPosition: uobPosition,
      onMapCreated: (GoogleMapController controller) async {
        setState(() {
          _controller = controller;
        });
      },
    );
  }
}

class PinButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add_location),
      onPressed: () {
        showBottomSheet(
          context: context,
          builder: (context) => PinInfoDrawer(),
        );
      },
    );
  }
}
