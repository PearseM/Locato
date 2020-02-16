import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integrated_project/screens/map_drawer.dart';
import 'package:integrated_project/screens/map_search.dart';
import 'package:integrated_project/screens/new_pin_sheet.dart';

enum NewPinMode {
  NewPin,
  ConfirmPin,
}

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // static functions can be used in initialisers but need defining in initState
  static Function(NewPinMode) changeNewPinMode;

  // currently shown FAB and its location
  static FloatingActionButton currentFab;

  // used to animate the bottom sheet popping up
  AnimationController bottomSheetController;
  bool bottomSheetVisible;

  @override
  void initState() {
    super.initState();

    changeNewPinMode = (newPinMode) async {
      switch (newPinMode) {
        case NewPinMode.NewPin:
          await bottomSheetController.reverse();
          setState(() {
            bottomSheetVisible = false;
            currentFab = fabNewPin;
          });
          break;
        case NewPinMode.ConfirmPin:
          setState(() {
            bottomSheetController.forward();
            bottomSheetVisible = true;
            currentFab = fabConfirmPin;
          });
          break;
      }
    };

    currentFab = fabNewPin;

    bottomSheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    bottomSheetVisible = false;

    final CameraPosition uobPosition =
        CameraPosition(target: LatLng(51.3782261, -2.3285874), zoom: 14.4746);
  }

  FloatingActionButton fabNewPin = FloatingActionButton(
    onPressed: () => changeNewPinMode(NewPinMode.ConfirmPin),
    child: Icon(Icons.add_location),
  );

  FloatingActionButton fabConfirmPin = FloatingActionButton(
    onPressed: () => changeNewPinMode(NewPinMode.NewPin),
    child: Icon(Icons.check),
    backgroundColor: Colors.green,
  );

  @override
  Widget build(BuildContext context) {
    // used to prevent keyboard overlapping textboxes
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      key: scaffoldKey,
      body: Stack(children: [
        GoogleMap(
          initialCameraPosition: currentMapPosition,
        ),
        // the new-pin indicator in the middle of the map
        Align(
          child: ScaleTransition(
            scale: bottomSheetController, // show pin with bottom sheet
            child: FractionalTranslation(
              translation: Offset(0.0, -0.5), // aligns pin point to centre
              child: Icon(
                Icons.location_on,
                size: 48.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ]),
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
              // giving bottom sheet visibility hides keyboard when its closed
              visible: bottomSheetVisible,
              child: SizeTransition(
                sizeFactor: bottomSheetController,
                axisAlignment: -1.0,
                child: Padding(
                  padding: EdgeInsets.only(bottom: keyboardPadding),
                  child: NewPinSheet(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    bottomSheetController.dispose();
    super.dispose();
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
