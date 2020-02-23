import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integrated_project/resources/account.dart';
import 'package:integrated_project/resources/database.dart';
import 'package:integrated_project/screens/map_drawer.dart';
import 'package:integrated_project/screens/map_search.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:integrated_project/screens/new_pin_form.dart';
import 'package:integrated_project/resources/pin.dart';
import 'package:integrated_project/resources/review.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  // used to animate the change between new-pin states
  AnimationController drawerAnimator;
  bool showDrawer;

  // how much the map is covered by the system status bar & BAB
  EdgeInsets mapOverlap;
  Set<Marker> markers;
  CameraPosition currentMapPosition;

  Set<Pin> pins = Set<Pin>();

  GlobalKey<FormState> formKey;

  // currently shown FAB and its location
  FloatingActionButton fabAddPin;
  FloatingActionButton fabConfirmPin;
  FloatingActionButton currentFab;

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

  /// Creates a new pin and displays it on the map.
  ///
  /// Requires the location of the pin, a name and the first review to be
  /// displayed. The pin will also be added to the database
  void createPin(CameraPosition location, String name, Review review) {
    Pin pin = Pin(
      pins.length.toString(),
      location.target,
      null,
      name,
      review,
    );
    setState(() {
      pins.add(pin);
      markers.add(pin.createMarker());
    });
    Database.addPin(pin);
  }

  void barHeightChange(double height) {
    setState(() {
      mapOverlap =
          MediaQuery.of(context).padding + EdgeInsets.only(bottom: height);
    });
  }

  /// Fetches the pins from the database and adds them to the map.
  void queryPins() {
    Stream<QuerySnapshot> query = Database.getPins();
    query.listen((data) {
      data.documentChanges.forEach((documentChange) {
        Map<String, dynamic> document = documentChange.document.data;
        Review review = Review("0", Account("0"), "Review", DateTime.now());
        Pin pin = Pin(
          documentChange.document.documentID,
          LatLng(
              document["location"].latitude,
              document["location"].longitude,
          ),
          Account("0"),
          document["name"],
          review,
        ); //TODO Add review
        setState(() {
          pins.add(pin);
          markers.add(pin.createMarker());
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();

    drawerAnimator = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    showDrawer = false;

    mapOverlap = EdgeInsets.zero;
    markers = Set<Marker>();
    currentMapPosition =
        CameraPosition(target: LatLng(51.3782261, -2.3285874), zoom: 14.4746);

    formKey = GlobalKey<FormState>();

    fabAddPin = FloatingActionButton(
      onPressed: openDrawer,
      child: Icon(Icons.add_location),
    );

    fabConfirmPin = FloatingActionButton(
      onPressed: () {
        if (formKey.currentState.validate()) {
          NewPinForm form = formKey.currentContext
              .findAncestorWidgetOfExactType<NewPinForm>();
          String pinName = form.nameController.text;
          Review review =
              Review(null, null, form.bodyController.text, DateTime.now());
          createPin(currentMapPosition, pinName, review);
          closeDrawer();
        }
      },
      child: Icon(Icons.check),
      backgroundColor: Colors.green,
    );

    currentFab = fabAddPin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapBody(
        mapMoveCallback: (value) => currentMapPosition = value,
        initialPosition: currentMapPosition,
        mapOverlap: mapOverlap,
        markers: markers,
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
    this.markers,
    this.pinAnimation,
    this.queryPins,
  }) : super(key: key);

  final Function(CameraPosition) mapMoveCallback;
  final Function() queryPins;
  final CameraPosition initialPosition;
  final EdgeInsets mapOverlap;

  final Set<Marker> markers;

  final Animation<double> pinAnimation;

  @override
  State<MapBody> createState() => MapBodyState();
}

class MapBodyState extends State<MapBody> {
  static const CameraPosition uobPosition =
      CameraPosition(target: LatLng(51.3782261, -2.3285874), zoom: 14.4746);

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
    return Stack(
      children: <Widget>[
        GoogleMap(
          initialCameraPosition: widget.initialPosition,
          padding: widget.mapOverlap,
          markers: widget.markers,
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

  BottomBar(
    this.formKey,
    this.closeBarCallback,
    this.barHeightCallback,
    this.openAnimation,
    this.drawerOpen,
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

  BottomBarNav(
    this.closeBarCallback,
    this.drawerOpen,
  );

  @override
  Widget build(BuildContext context) {
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
            icon: Icon(Icons.menu),
          ),
          replacement: IconButton(
            onPressed: () {
              closeBarCallback();
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        Spacer(),
        IconButton(
          onPressed: () {
            showSearch(context: context, delegate: MapSearchDelegate());
          },
          icon: Icon(Icons.search),
        ),
      ],
    );
  }
}
