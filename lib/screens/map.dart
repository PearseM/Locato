import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integrated_project/screens/map_drawer.dart';
import 'package:integrated_project/screens/map_search.dart';
import 'package:integrated_project/screens/new_pin_sheet.dart';
import 'package:integrated_project/screens/pin_info_drawer.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => MapPageState();
}

// FAB can be either the "new-pin" or "confirm-pin" button
enum FabMode {
  NewPin,
  ConfirmPin,
}

class MapPageState extends State<MapPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // static functions can be used in initialisers but need defining in initState
  static Function(FabMode) changeFabMode;
  static Function openBottomSheet;
  static Function closeBottomSheet;

  // currently shown FAB and its location
  static FloatingActionButton currentFab;

  static bool bottomSheetVisible;

  // controller for the bottom sheet so we know when it closes
  static PersistentBottomSheetController bottomSheetController;

  @override
  void initState() {
    super.initState();

    changeFabMode = (value) {
      setState(() {
        switch (value) {
          case FabMode.NewPin:
            currentFab = fabNewPin;
            break;
          case FabMode.ConfirmPin:
            currentFab = fabConfirmPin;
            break;
        }
      });
    };

    openBottomSheet = () {
      bottomSheetVisible = true;
    };

    closeBottomSheet = () {
      bottomSheetVisible = false;
    };

    // start in new-pin mode
    changeFabMode(FabMode.NewPin);
    bottomSheetVisible = false;
  }

  FloatingActionButton fabNewPin = FloatingActionButton(
    onPressed: () {
      openBottomSheet();
      changeFabMode(FabMode.ConfirmPin);
    },
    child: Icon(Icons.add_location),
  );

  FloatingActionButton fabConfirmPin = FloatingActionButton(
    onPressed: () {
      closeBottomSheet();
      changeFabMode(FabMode.NewPin);
    },
    child: Icon(Icons.check),
    backgroundColor: Colors.green,
  );

  @override
  Widget build(BuildContext context) {
    // used to prevent keyboard overlapping textboxes
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      key: scaffoldKey,
      body: MapBody(),
      drawer: MapDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: currentFab,
      resizeToAvoidBottomInset: false, // prevents map resizing with keyboard
      extendBody: true, // puts map beneath the notched app bar
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        // BottomAppBar has actual appbar with toggled-visibility new-pin sheet under
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            MapBarContents(),
            Visibility(
              child: Padding(
                padding: EdgeInsets.only(bottom: keyboardPadding),
                child: NewPinSheet(),
              ),
              visible: bottomSheetVisible,
            ),
          ],
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
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.gps_fixed),
        ),
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
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition uobPosition =
      CameraPosition(target: LatLng(51.3782261, -2.3285874), zoom: 14.4746);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false, // prevents map moving with keyboard
      body: GoogleMap(
        initialCameraPosition: uobPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
