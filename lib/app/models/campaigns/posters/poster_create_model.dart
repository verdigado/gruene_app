import 'dart:io';
import 'dart:typed_data';

import 'package:maplibre_gl/maplibre_gl.dart';

class PosterCreateModel {
  final String? street;
  final String? houseNumber;
  final String? zipCode;
  final String? city;
  final LatLng location;
  final Uint8List? photo;

  const PosterCreateModel({
    this.street,
    this.houseNumber,
    this.zipCode,
    this.city,
    this.photo,
    required this.location,
  });
}
