class DoorDetailModel {
  String id;

  final String street;
  final String houseNumber;
  final String zipCode;
  final String city;
  final int openedDoors;
  final int closedDoors;

  DoorDetailModel({
    required this.id,
    required this.street,
    required this.houseNumber,
    required this.zipCode,
    required this.city,
    required this.openedDoors,
    required this.closedDoors,
  });
}
