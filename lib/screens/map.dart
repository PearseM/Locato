import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integrated_project/resources/account.dart';
import 'package:integrated_project/resources/database.dart';
import 'package:integrated_project/screens/map_drawer.dart';
import 'package:integrated_project/screens/map_search.dart';
import 'package:integrated_project/screens/pin_info_drawer.dart';
import 'package:integrated_project/sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:integrated_project/screens/new_pin_form.dart';
import 'package:integrated_project/resources/pin.dart';

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

  // how much the map is covered by the system status bar & BAB
  EdgeInsets mapOverlap;
  CameraPosition currentMapPosition;

  Set<Pin> pins = Set<Pin>();

  GlobalKey<FormState> formKey;

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

  /// Creates a new pin and displays it on the map.
  ///
  /// Requires the location of the pin, a name and the first review to be
  /// displayed. The pin will also be added to the database
  void createPin(CameraPosition location, String name, String reviewContent,
      File image) async {
    Pin pin = await Database.newPin(
        location.target, name, reviewContent, _account, image, context);
    setState(() {
      pins.add(pin);
    });
  }

  void barHeightChange(double height) {
    setState(() {
      mapOverlap =
          MediaQuery.of(context).padding + EdgeInsets.only(bottom: height);
    });
  }

  /*
  /// Fetches the pins from the database and adds them to the map.
  void queryPins() {
    Stream<QuerySnapshot> query = Database.getPins();
    query.listen((data) {
      for (DocumentChange documentChange in data.documentChanges) {
        Map<String, dynamic> document = documentChange.document.data;
        Review review =
            Database.getFirstReview(documentChange.document.documentID);
        Pin pin = Pin(
          documentChange.document.documentID,
          LatLng(
            document["location"].latitude,
            document["location"].longitude,
          ),
          Account(document["author"]),
          document["name"],
          review,
        );
        setState(() {
          pins.add(pin);
        });
        Database.getReviewsForPin(documentChange.document.documentID)
            .listen((data) {
          data.documentChanges.removeAt(0);
          data.documentChanges.forEach((change) {
            pin.addReview(Review.fromMap(
                change.document.documentID, change.document.data));
          });
        });
      }
    });
  }*/

  void queryPins() {
    Database.getPins(context).listen((pinsList) {
      setState(() {
        pins.addAll(pinsList);
      });
    });
  }

  @override
  void initState() {
    super.initState();

    Pin.formKey = formKey;

    drawerAnimator = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    showDrawer = false;

    mapOverlap = EdgeInsets.zero;
    currentMapPosition = (widget.currentMapPosition == null)
        ? CameraPosition(
            target: LatLng(51.3782261, -2.3285874), zoom: MapPage.kDefaultZoom)
        : widget.currentMapPosition;

    formKey = GlobalKey<FormState>();

    fabAddPin = FloatingActionButton(
      tooltip: "Add pin",
      onPressed: openDrawer,
      child: Icon(Icons.add_location),
    );

    fabConfirmPin = FloatingActionButton(
      tooltip: "Confirm",
      onPressed: () {
        if (formKey.currentState.validate()) {
          NewPinFormState form =
              formKey.currentContext.findAncestorStateOfType<NewPinFormState>();
          String pinName = form.nameController.text;
          File image = form.imagePickerKey.currentState.value;

          createPin(
              currentMapPosition, pinName, form.bodyController.text, image);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapBody(
        mapMoveCallback: (value) => currentMapPosition = value,
        initialPosition: currentMapPosition,
        mapOverlap: mapOverlap,
        pins: pins,
        pinAnimation: drawerAnimator,
        queryPins: queryPins,
      ),
      drawer: MapDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: currentFab,
      resizeToAvoidBottomInset: false,
      // prevents map resizing with keyboard
      extendBody: true,
      // puts map beneath the notched app bar
      bottomNavigationBar: BottomBar(
        formKey,
        closeDrawer,
        mapOverlap == EdgeInsets.zero ? barHeightChange : (_) {},
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
    this.pins,
    this.pinAnimation,
    this.queryPins,
  }) : super(key: key);

  final Function(CameraPosition) mapMoveCallback;
  final Function() queryPins;
  final CameraPosition initialPosition;
  final EdgeInsets mapOverlap;

  final Set<Pin> pins;

  final Animation<double> pinAnimation;

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
  Widget build(BuildContext context) {
    Set<Marker> markers = Set<Marker>();
    for (Pin pin in widget.pins) {
      markers.add(pin.marker);
    }

    return Stack(
      children: <Widget>[
        GoogleMap(
          initialCameraPosition: widget.initialPosition,
          padding: widget.mapOverlap,
          markers: markers,
          myLocationEnabled: locationEnabled,
          myLocationButtonEnabled: locationEnabled,
          onCameraMove: widget.mapMoveCallback,
          onMapCreated: (_) => widget.queryPins(),
        ),
        Align(
          child: ScaleTransition(
            scale: widget.pinAnimation, // scale the pin with this animation
            child: Transform.translate(
              // corrects the offset caused by the mapOverlap
              offset: Offset(
                0.0,
                (widget.mapOverlap.top - widget.mapOverlap.bottom) / 2,
              ),
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
  final GlobalKey<FormState> formKey;
  final VoidCallback closeBarCallback;

  final Function(double) barHeightCallback;
  final Animation<double> openAnimation;
  final bool drawerOpen;
  final Function(Pin) updateCameraPosition;

  BottomBar(
    this.formKey,
    this.closeBarCallback,
    this.barHeightCallback,
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
                child: NewPinForm(formKey),
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
