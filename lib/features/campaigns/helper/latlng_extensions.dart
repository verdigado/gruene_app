import 'package:maplibre_gl/maplibre_gl.dart';

extension LatLngToString on LatLng {
  String toLatLngString() {
    return '${latitude.toString()},${longitude.toString()}';
  }
}
