import 'package:gruene_app/app/services/nominatim_service.dart';

class DoorDetailModel {
  String id;

  final AddressModel address;
  final int openedDoors;
  final int closedDoors;

  DoorDetailModel({
    required this.id,
    required this.address,
    required this.openedDoors,
    required this.closedDoors,
  });
}
