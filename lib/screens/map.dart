import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integrated_project/resources/account.dart';
import 'package:integrated_project/resources/database.dart';
import 'package:integrated_project/resources/pin.dart';
import 'package:integrated_project/screens/map_drawer.dart';
import 'package:integrated_project/screens/map_search.dart';
import 'package:integrated_project/screens/new_pin_form.dart';
import 'package:integrated_project/screens/pin_info_drawer.dart';
import 'package:integrated_project/sign_in.dart';
import 'package:permission_handler/permission_handler.dart';

class MapPage extends StatefulWidget {
  static const kDefaultZoom = 14.4746;
  final CameraPosition currentMapPosition;

  MapPage({LatLng currentMapPosition})
      : this.currentMapPosition = (currentMapPosition == null)
            ? null
            : CameraPosition(target: currentMapPosition, zoom: kDefaultZoom);

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  // used to animate the change between new-pin states
  AnimationController drawerAnimator;
  bool showDrawer;
  final double drawerHeight = 325;

  // how much the map is covered by the system status bar & BAB
  EdgeInsets mapOverlap;
  CameraPosition currentMapPosition;

  Set<Pin> pins = Set<Pin>();

  GlobalKey<NewPinFormState> pinFormKey;
  StreamSubscription<List<PinChange>> pinsStream;

  // currently shown FAB and its location
  FloatingActionButton fabAddPin;
  FloatingActionButton fabConfirmPin;
  FloatingActionButton currentFab;

  //User instance
  FirebaseUser _user;
  Account _account;

  void openDrawer() {
    setState(() {
      drawerAnimator.forward();
      showDrawer = true;
      currentFab = fabConfirmPin;
    });
  }

  void closeDrawer() async {
    await drawerAnimator.reverse();
    setState(() {
      showDrawer = false;
      currentFab = fabAddPin;
    });
  }

  ///Opens the pin info drawer for this pin.
  void updateMapPosition(Pin pin) {
    //TODO make this actually move the camera position on the map
    CameraPosition newPosition =
        CameraPosition(target: pin.location, zoom: MapPage.kDefaultZoom);
    setState(() {
      currentMapPosition = newPosition;
    });
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => PinInfoDrawer(pin, pin.imageUrl),
    );
  }

  void barHeightChange(double height) {
    setState(() {
      mapOverlap =
          MediaQuery.of(context).padding + EdgeInsets.only(bottom: height);
    });
  }

  void queryPins() {
    pinsStream = Database.getPins(context).listen((pinChangesList) {
      setState(() {
        for (PinChange pinChange in pinChangesList) {
          if (pinChange.type == DocumentChangeType.added) {
            pins.add(pinChange.pin);
          }
          else if (pinChange.type == DocumentChangeType.removed) {
            pins.remove(pinChange.pin);
          }
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();

    drawerAnimator = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    showDrawer = false;

    mapOverlap = EdgeInsets.zero;
    currentMapPosition = (widget.currentMapPosition == null)
        ? CameraPosition(
            target: LatLng(51.3782261, -2.3285874), zoom: MapPage.kDefaultZoom)
        : widget.currentMapPosition;

    pinFormKey = GlobalKey<NewPinFormState>();

    fabAddPin = FloatingActionButton(
      tooltip: "Add pin",
      onPressed: openDrawer,
      child: Icon(Icons.add_location),
    );

    fabConfirmPin = FloatingActionButton(
      tooltip: "Confirm",
      onPressed: () {
        if (pinFormKey.currentState.validate()) {
          pinFormKey.currentState.createPin().then((pin) {
            pins.add(pin);
          });
          closeDrawer();
        }
      },
      child: Icon(Icons.check),
      backgroundColor: Colors.green,
    );

    currentFab = fabAddPin;

    SignIn.auth.currentUser().then((user) {
      Account account = Account.fromFirebaseUser(user);
      setState(() {
        _user = user;
        _account = account;
      });
    });

    queryPins();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapBody(
        mapMoveCallback: (value) => currentMapPosition = value,
        initialPosition: currentMapPosition,
        mapOverlap: mapOverlap,
        drawerHeight: drawerHeight,
        pins: pins,
        pinAnimation: drawerAnimator,
        pinsStream: pinsStream,
      ),
      drawer: MapDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: currentFab,
      resizeToAvoidBottomInset: false,
      // prevents map resizing with keyboard
      extendBody: true,
      // puts map beneath the notched app bar
      bottomNavigationBar: BottomBar(
        pinFormKey,
        closeDrawer,
        mapOverlap == EdgeInsets.zero ? barHeightChange : (_) {},
        drawerHeight,
        drawerAnimator,
        showDrawer,
        updateMapPosition,
      ),
    );
  }

  @override
  void dispose() {
    drawerAnimator.dispose();
    super.dispose();
  }
}

class MapBody extends StatefulWidget {
  MapBody({
    Key key,
    this.mapMoveCallback,
    this.initialPosition,
    this.mapOverlap,
    this.drawerHeight,
    this.pins,
    this.pinAnimation,
    this.pinsStream,
  }) : super(key: key);

  final Function(CameraPosition) mapMoveCallback;
  final CameraPosition initialPosition;
  final EdgeInsets mapOverlap;
  final double drawerHeight;

  final Set<Pin> pins;

  final Animation<double> pinAnimation;
  final StreamSubscription<List<PinChange>> pinsStream;

  @override
  State<MapBody> createState() => MapBodyState();
}

class MapBodyState extends State<MapBody> {
  static const CameraPosition uobPosition = CameraPosition(
      target: LatLng(51.3782261, -2.3285874), zoom: MapPage.kDefaultZoom);

  bool locationEnabled;

  /// monitors changes to location permission and updates map.
  ///
  /// if the location service becomes enabled but the permission
  /// is denied, requests permission (unless never-ask-again chosen).
  void monitorLocationPerm() async {
    ServiceStatus oldServiceStatus, serviceStatus;

    while (true) {
      oldServiceStatus = serviceStatus;
      serviceStatus = await PermissionHandler()
          .checkServiceStatus(PermissionGroup.location);
      // only check if the service status has changed
      if (serviceStatus == oldServiceStatus) continue;

      // if service is off, disable location
      if (serviceStatus == ServiceStatus.disabled) {
        setState(() {
          locationEnabled = false;
        });
        continue;
      }

      // service has been turned on, check permissions
      PermissionStatus permissionStatus = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.location);

      if (permissionStatus == PermissionStatus.denied ||
          permissionStatus == PermissionStatus.unknown) {
        permissionStatus = (await PermissionHandler().requestPermissions(
            [PermissionGroup.location]))[PermissionGroup.location];
      }

      setState(() {
        if (permissionStatus == PermissionStatus.denied ||
            permissionStatus == PermissionStatus.neverAskAgain) {
          locationEnabled = false;
        } else if (permissionStatus == PermissionStatus.granted) {
          locationEnabled = true;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();

    monitorLocationPerm();
  }

  @override
  void dispose() {
    widget.pinsStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = Set<Marker>();
    for (Pin pin in widget.pins) {
      markers.add(pin.marker);
    }

    return Stack(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.pinAnimation,
          builder: (context, _) => GoogleMap(
            initialCameraPosition: widget.initialPosition,
            padding: widget.mapOverlap +
                EdgeInsets.only(
                    bottom: widget.drawerHeight * widget.pinAnimation.value),
            markers: markers,
            myLocationEnabled: locationEnabled,
            myLocationButtonEnabled: locationEnabled,
            onCameraMove: widget.mapMoveCallback,
          ),
        ),
        Align(
          child: Transform.translate(
            // corrects the offset caused by the mapOverlap
            offset: Offset(
              0.0,
              (widget.mapOverlap.top -
                      widget.drawerHeight -
                      widget.mapOverlap.bottom) /
                  2,
            ),
            child: ScaleTransition(
              scale: widget.pinAnimation, // scale the pin with this animation
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
        ),
      ],
    );
  }
}

class BottomBar extends StatelessWidget {
  final GlobalKey<NewPinFormState> pinFormKey;
  final VoidCallback closeBarCallback;

  final Function(double) barHeightCallback;
  final double drawerHeight;
  final Animation<double> openAnimation;
  final bool drawerOpen;
  final Function(Pin) updateCameraPosition;

  BottomBar(
    this.pinFormKey,
    this.closeBarCallback,
    this.barHeightCallback,
    this.drawerHeight,
    this.openAnimation,
    this.drawerOpen,
    this.updateCameraPosition,
  );

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      barHeightCallback(context.size.height);
    });

    // used to prevent keyboard overlapping textboxes
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;

    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      // BottomAppBar has actual appbar with toggled-visibility new-pin sheet under
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          BottomBarNav(
            closeBarCallback,
            drawerOpen,
            updateCameraPosition,
          ),
          Visibility(
            // giving bottom sheet visibility hides keyboard when its closed
            visible: drawerOpen,
            child: SizeTransition(
              sizeFactor: openAnimation,
              axisAlignment: -1.0,
              child: Padding(
                padding: EdgeInsets.only(bottom: keyboardPadding),
                child: NewPinForm(drawerHeight, key: pinFormKey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomBarNav extends StatelessWidget {
  final VoidCallback closeBarCallback;
  final bool drawerOpen;
  final Function(Pin) updateMapPosition;

  BottomBarNav(
    this.closeBarCallback,
    this.drawerOpen,
    this.updateMapPosition,
  );

  @override
  Widget build(BuildContext context) {
    Set<Pin> pins = context.findAncestorStateOfType<MapPageState>().pins;

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Visibility(
          visible: !drawerOpen,
          child: IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(
              Icons.menu,
              semanticLabel: "Menu",
            ),
          ),
          replacement: IconButton(
            onPressed: () {
              closeBarCallback();
            },
            icon: Icon(
              Icons.arrow_back,
              semanticLabel: "Cancel",
            ),
          ),
        ),
        Spacer(),
        PopupMenuButton(
          tooltip: "Help",
          icon: Icon(
            Icons.help,
            color: Colors.black,
          ),
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            const PopupMenuItem(
              child: Text(
                  "\nThis is the map. Navigate around and click on pins made by users.\n\n"
                  "You can add your own pin by clicking the plus button and centring the screen on the correct location.\n\n"
                  "Alternatively, search for a pin using the search icon.\n"),
            ),
          ],
        ),
        IconButton(
          onPressed: () async {
            Pin pin = await showSearch(
                context: context, delegate: MapSearchDelegate(pins));
            updateMapPosition(pin);
          },
          icon: Icon(
            Icons.search,
            semanticLabel: "Search",
          ),
        ),
      ],
    );
  }
}
