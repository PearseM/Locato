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

    changeNewPinMode = (newPinMode) {
      setState(() {
        switch (newPinMode) {
          case NewPinMode.NewPin:
            bottomSheetController.reverse().then((value) {
              bottomSheetVisible = false;
            });
            currentFab = fabNewPin;
            break;
          case NewPinMode.ConfirmPin:
            bottomSheetController.forward();
            bottomSheetVisible = true;
            currentFab = fabConfirmPin;
            break;
        }
      });
    };

    currentFab = fabNewPin;

    bottomSheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    bottomSheetVisible = false;
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

class MapBody extends StatelessWidget {
  static final CameraPosition uobPosition =
      CameraPosition(target: LatLng(51.3782261, -2.3285874), zoom: 14.4746);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false, // prevents map moving with keyboard
      body: GoogleMap(
        initialCameraPosition: uobPosition,
        onMapCreated: (GoogleMapController controller) {},
      ),
    );
  }
}
