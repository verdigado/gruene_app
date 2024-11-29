import 'package:maplibre_gl/maplibre_gl.dart';

class MarkerItemModel {
  final LatLng location;
  final int? id;
  final String? status;

  const MarkerItemModel({
    this.id,
    this.status,
    required this.location,
  });
}
