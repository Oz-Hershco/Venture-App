import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:venture_app/models/filter_item.dart';
import 'package:venture_app/models/venture.dart';
import 'package:venture_app/providers/user_provider.dart';
import 'package:venture_app/providers/ventures_provider.dart';
import 'package:venture_app/screens/AddNewVentureScreen.dart';
import 'package:venture_app/screens/VentureScreen.dart';
import 'package:venture_app/widgets/LocationMapFilters/LocationMapFiltersList.dart';
import 'package:venture_app/widgets/Spinner.dart';

class ExploreScreen extends StatefulWidget {
  static const routeName = '/explore';
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  Set<Marker> _markers = {};
  String _address, _dateTime;
  LatLng _initialcameraposition = LatLng(36.1069258, -112.1129484);
  bool _isinitialcamerapositionset = false;
  bool _showCurrentLocationButton = false;
  GoogleMapController _controller;
  LocationData _currentPosition;
  Location _location = Location();
  String _mapStyle;
  BitmapDescriptor campingMapMarker;
  BitmapDescriptor bbqMapMarker;
  BitmapDescriptor trailMapMarker;
  List<FilterItem> ventureFilterStates = [];
  String venturesSearchText = "";

  var uuid = Uuid();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    rootBundle.loadString('assets/googlemap_style.txt').then((string) {
      _mapStyle = string;
    });
    setCustomMarkers();
    getLoc();
  }

  void setCustomMarkers() async {
    campingMapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/images/camping-pin-icon.png');
    bbqMapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/images/bbq-pin-icon.png');
    trailMapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/images/trail-pin-icon.png');
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _controller.setMapStyle(_mapStyle);
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _initialcameraposition, zoom: 15),
      ),
    );
    // setState(() {
    //   _markers.add(Marker(
    //       markerId: MarkerId(uuid.v4()),
    //       icon: mapMarker,
    //       position: LatLng(32.0945977, 34.8765991),
    //       infoWindow: InfoWindow(title: 'Cocks', snippet: 'Some dicks!')));
    // });
    // _location.onLocationChanged.listen((l) {
    //   // _controller.animateCamera(
    //   //   CameraUpdate.newCameraPosition(
    //   //     CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
    //   //   ),
    //   // );
    // });
  }

  void _handleLocationFilterSelect(List<FilterItem> locationMapFilterStates) {
    setState(() {
      ventureFilterStates = locationMapFilterStates;
    });
  }

  void _handleLocationSearch(enteredtext) {
    setState(() {
      venturesSearchText = enteredtext;
    });
  }

  void _moveToCurrentPosition() async {
    _currentPosition = await _location.getLocation();
    await _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target:
                LatLng(_currentPosition.latitude, _currentPosition.longitude),
            zoom: 15),
      ),
    );
    setState(() {
      _showCurrentLocationButton = false;
    });
  }

  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await _location.getLocation();
    setState(() {
      _initialcameraposition =
          LatLng(_currentPosition.latitude, _currentPosition.longitude);
      _isinitialcamerapositionset = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final venturesData = Provider.of<VenturesProvider>(context);
    final userData = Provider.of<UserProvider>(context);
    final ventures = venturesData.list;
    final user = userData.item;
    List<FilterItem> activeLocationFilters =
        ventureFilterStates.where((l) => l.isActive).toList();

    List<Venture> filteredVentures = ventures
        .where((v) =>
            v.title.toLowerCase().contains(venturesSearchText.toLowerCase()))
        .toList()
        .where((v) => (activeLocationFilters.length > 0)
            ? activeLocationFilters
                    .where((f) =>
                        v.type.where((l) => l.isActive).toList()[0].id == f.id)
                    .toList()
                    .length >
                0
            : true)
        .toList();

    return new Scaffold(
      floatingActionButton: user != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedOpacity(
                  opacity: _showCurrentLocationButton ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 250),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: .25,
                        color: Colors.black.withOpacity(.5),
                      ),
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white,
                    ),
                    height: 45,
                    width: 45,
                    child: FloatingActionButton(
                      onPressed: () {
                        _moveToCurrentPosition();
                      },
                      child: Icon(
                        Icons.center_focus_weak_rounded,
                        color: Colors.black.withOpacity(.5),
                      ),
                      backgroundColor: Color.fromRGBO(242, 242, 242, 1),
                      elevation: 2,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AddNewVentureScreen.routeName,
                        arguments: {'isEditMode': false},
                      );
                    },
                    child: Container(
                      height: 25,
                      child: new Image.asset(
                        'assets/images/feed_nav_icon.png',
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Theme.of(context).accentColor,
                    elevation: 3,
                  ),
                ),
              ],
            )
          : null,
      body: _isinitialcamerapositionset
          ? Stack(
              children: <Widget>[
                GoogleMap(
                  onCameraMoveStarted: () {
                    setState(() {
                      _showCurrentLocationButton = true;
                    });
                  },
                  onTap: (latlng) {
                    FocusScopeNode currentScope = FocusScope.of(context);
                    if (!currentScope.hasPrimaryFocus &&
                        currentScope.hasFocus) {
                      FocusManager.instance.primaryFocus.unfocus();
                    }
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  markers: filteredVentures.map((venture) {
                    return Marker(
                        markerId: MarkerId(venture.id),
                        icon: venture.type
                                    .where((l) => l.isActive)
                                    .toList()[0]
                                    .id ==
                                "5"
                            ? campingMapMarker
                            : (venture.type
                                        .where((l) => l.isActive)
                                        .toList()[0]
                                        .id ==
                                    "6"
                                ? bbqMapMarker
                                : trailMapMarker),
                        position: venture.position.latLng,
                        // infoWindow: InfoWindow(title: venture.title),
                        onTap: () {
                          // _controller.animateCamera(
                          //   CameraUpdate.newCameraPosition(
                          //     CameraPosition(
                          //         target: venture.position.latLng, zoom: 16),
                          //   ),
                          // );
                          Navigator.of(context).pushNamed(
                            VentureScreen.routeName,
                            arguments: {'ventureId': venture.id},
                          );
                        });
                  }).toSet(),
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  initialCameraPosition:
                      CameraPosition(target: _initialcameraposition),
                  mapToolbarEnabled: false,
                  onMapCreated: _onMapCreated,
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            top: 15, bottom: 10, right: 15, left: 15),
                        height: 45,
                        child: TextField(
                          onChanged: _handleLocationSearch,
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.search,
                              size: 20,
                              color: Colors.black.withAlpha(50),
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            fillColor: Colors.white,
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            hintText: "Search for places...",
                            hintStyle: TextStyle(
                                fontFamily: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .fontFamily,
                                fontWeight: FontWeight.w300,
                                fontSize: 15,
                                color: Colors.black.withAlpha(75)),
                            labelText: 'Search for places...',
                            labelStyle: TextStyle(
                                fontFamily: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .fontFamily,
                                fontWeight: FontWeight.w300,
                                fontSize: 15,
                                color: Colors.black.withAlpha(75)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: new BorderSide(
                                  width: .5, color: Colors.black.withAlpha(75)),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(
                                  width: .5, color: Colors.black.withAlpha(75)),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ),
                      LocationMapFiltersList(
                        onChange: _handleLocationFilterSelect,
                        containerMargin: EdgeInsets.symmetric(horizontal: 15),
                      ),
                    ],
                  ),
                  height: 120,
                ),
              ],
            )
          : Spinner(
              color: Theme.of(context).accentColor,
              sizeWidth: 40,
              sizeHeight: 40,
              circleStrokeWidth: 4,
            ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _goToTheLake,

      // ),
    );
  }

  Future<List<Address>> _getAddress(double lat, double lang) async {
    final coordinates = new Coordinates(lat, lang);
    List<Address> add =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return add;
  }
}
