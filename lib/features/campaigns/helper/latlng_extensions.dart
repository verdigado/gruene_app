import 'package:maplibre_gl/maplibre_gl.dart';

extension LatLngToString on LatLng {
  String ToLatLngString() {
    return '${this.latitude.toString()},${this.longitude.toString()}';
  }
}
