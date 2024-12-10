import 'dart:typed_data';

import 'package:gruene_app/app/services/nominatim_service.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class PosterCreateModel {
  final AddressModel address;
  final LatLng location;
  final Uint8List? photo;

  const PosterCreateModel({
    required this.address,
    this.photo,
    required this.location,
  });
}
