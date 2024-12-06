import 'package:gruene_app/app/services/nominatim_service.dart';

class FlyerUpdateModel {
  final String id;
  final AddressModel address;
  final int flyerCount;

  FlyerUpdateModel({required this.id, required this.address, required this.flyerCount});
}
