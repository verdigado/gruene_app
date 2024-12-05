import 'package:gruene_app/app/services/nominatim_service.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class DoorCreateModel {
  final LatLng location;
  final AddressModel address;
  final int openedDoors;
  final int closedDoors;

  DoorCreateModel({
    required this.location,
    required this.address,
    required this.openedDoors,
    required this.closedDoors,
  });
}
