import 'package:gruene_app/app/services/nominatim_service.dart';
import 'package:maplibre_gl_platform_interface/maplibre_gl_platform_interface.dart';

class FlyerCreateModel {
  final LatLng location;

  final AddressModel address;

  final int flyerCount;

  FlyerCreateModel({required this.location, required this.address, required this.flyerCount});
}
