import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:venture_app/models/venturelocation.dart';

const kGoogleApiKey = "";

Future<Null> handlePrediction(
    Prediction p, ScaffoldState scaffold, BuildContext context) async {
  if (p != null) {
    // // get detail (lat/lng)
    GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await GoogleApiHeaders().getHeaders(),
    );
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;
    print(_places);
    Navigator.of(context)
        .pop(VentureLocation(address: p.description, latLng: LatLng(lat, lng)));

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) {
    //     return AddNewSiteScreen(
    //       addressText: p.description,
    //       addressLatLng: LatLng(lat, lng),
    //     );
    //   }),
    // );

  }
}

// custom scaffold that handle search
// basically your widget need to extends [GooglePlacesAutocompleteWidget]
// and your state [GooglePlacesAutocompleteState]
class LocationSearch extends PlacesAutocompleteWidget {
  LocationSearch()
      : super(
          apiKey: kGoogleApiKey,
          sessionToken: Uuid().toString(),
          language: "en",
          mode: Mode.overlay,
          components: [Component(Component.country, "il")],
          radius: 10000000,
          types: [],
          strictbounds: false,
        );

  @override
  _LocationSearchState createState() => _LocationSearchState();
}

class _LocationSearchState extends PlacesAutocompleteState {
  final searchScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
        leadingWidth: 0,
        // leading: IconButton(
        //   splashColor: Colors.transparent,
        //   highlightColor: Colors.transparent,
        //   icon: Container(
        //       height: 20,
        //       child: new Image.asset(
        //         "assets/images/chev-left.png",
        //         fit: BoxFit.contain,
        //       )),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        backgroundColor: Colors.white,
        title: Container(
          height: 45,
          child: AppBarPlacesAutoCompleteTextField(
            textDecoration: InputDecoration(
              suffixIcon: Icon(
                Icons.search,
                size: 20,
                color: Colors.black.withAlpha(50),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              fillColor: Colors.white,
              filled: true,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              hintText: "Search for places...",
              hintStyle: TextStyle(
                  fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
                  fontWeight: FontWeight.w300,
                  fontSize: 15,
                  color: Colors.black.withAlpha(75)),
              labelText: 'Search for places...',
              labelStyle: TextStyle(
                  fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
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
        ));
    final body = PlacesAutocompleteResult(
      onTap: (p) {
        handlePrediction(p, searchScaffoldKey.currentState, context);
      },
      logo: Container(child: Center(child: Text('No results to show yet'))),
    );
    return Scaffold(key: searchScaffoldKey, appBar: appBar, body: body);
  }

  @override
  void onResponseError(PlacesAutocompleteResponse response) {
    super.onResponseError(response);
    searchScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  @override
  void onResponse(PlacesAutocompleteResponse response) {
    super.onResponse(response);
    if (response != null && response.predictions.isNotEmpty) {
      SnackBar(content: Text("Got answer"));
      searchScaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Got answer")),
      );
    }
  }
}
