import 'package:gruene_app/app/services/nominatim_service.dart';

class DoorUpdateModel {
  int openedDoors;
  int closedDoors;
  String id;
  AddressModel address;

  DoorUpdateModel({
    required this.id,
    required this.address,
    required this.openedDoors,
    required this.closedDoors,
  });
}
