import 'package:maplibre_gl/maplibre_gl.dart';

class MarkerItemModel {
  final LatLng location;
  final int? id;
  final String? status;

  const MarkerItemModel({
    required this.id,
    required this.status,
    required this.location,
  });
}
