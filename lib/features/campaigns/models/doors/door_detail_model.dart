import 'package:gruene_app/app/services/nominatim_service.dart';

class DoorDetailModel {
  String id;

  final AddressModel address;
  final int openedDoors;
  final int closedDoors;
  final String createdAt;

  DoorDetailModel({
    required this.id,
    required this.address,
    required this.openedDoors,
    required this.closedDoors,
    required this.createdAt,
  });
}
