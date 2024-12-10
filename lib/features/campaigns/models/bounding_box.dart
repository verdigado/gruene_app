import 'package:maplibre_gl/maplibre_gl.dart';

class BoundingBox {
  final LatLng southwest;

  final LatLng northeast;

  const BoundingBox({required this.southwest, required this.northeast});
}
