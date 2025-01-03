import 'package:gruene_app/app/services/nominatim_service.dart';

class FlyerDetailModel {
  final String id;

  final AddressModel address;

  final int flyerCount;

  final String createdAt;

  FlyerDetailModel({
    required this.id,
    required this.address,
    required this.flyerCount,
    required this.createdAt,
  });
}
