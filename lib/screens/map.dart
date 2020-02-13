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

  // static callbacks for when new-pin and confirm-pin callbacks pressed
  static VoidCallback newPinCallback;
  static VoidCallback confirmPinCallback;
  // currently shown FAB and its location
  static FloatingActionButton currentFab;
  static FloatingActionButtonLocation currentFabLocation;
  // controller for the bottom sheet so we know when it closes
  static PersistentBottomSheetController bottomSheetController;

  @override
  void initState() {
    super.initState();

    // lets us reference non-static functions using setState from initialisers
    newPinCallback = newPin;
    confirmPinCallback = confirmPin;

    // start in new-pin mode
    changeFabMode(FabMode.NewPin);
  }

  void changeFabMode(FabMode value) {
    setState(() {
      switch (value) {
        case FabMode.NewPin:
          currentFabLocation = FloatingActionButtonLocation.centerDocked;
          currentFab = fabNewPin;
          break;
        case FabMode.ConfirmPin:
          currentFabLocation = FloatingActionButtonLocation.endDocked;
          currentFab = fabConfirmPin;
          break;
      }
    });
  }

  // called when new-pin FAB pressed
  void newPin() {
    changeFabMode(FabMode.ConfirmPin);

    bottomSheetController = scaffoldKey.currentState.showBottomSheet((context) {
      return NewPinSheet();
    });

    // re-enter new-pin mode when bottom sheet swiped down
    bottomSheetController.closed.then((value) {
      changeFabMode(FabMode.NewPin);
    });
  }

  // called when confirm-pin FAB pressed
  void confirmPin() {
    bottomSheetController.close();
    changeFabMode(FabMode.NewPin);
  }

  static FloatingActionButton fabNewPin = FloatingActionButton(
    child: Icon(Icons.add_location),
    onPressed: newPinCallback,
  );

  static FloatingActionButton fabConfirmPin = FloatingActionButton(
    child: Icon(Icons.check),
    onPressed: confirmPinCallback,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: MapBody(),
      drawer: MapDrawer(),
      floatingActionButtonLocation: currentFabLocation,
      floatingActionButton: currentFab,
      resizeToAvoidBottomInset: false, // prevents map resizing with keyboard
      extendBody: true, // puts map below the notched app bar
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: MapBarContents(),
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
