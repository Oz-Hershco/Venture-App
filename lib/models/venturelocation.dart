import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VentureLocation {
  @required final String address;
  @required final LatLng latLng;

  VentureLocation({this.address, this.latLng});
}
