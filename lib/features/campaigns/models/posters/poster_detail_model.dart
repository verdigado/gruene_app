import 'package:gruene_app/app/services/nominatim_service.dart';

enum PosterStatus { ok, damaged, missing, removed }

class PosterDetailModel {
  String id;
  String? thumbnailUrl;
  String? imageUrl;

  final AddressModel address;
  final String comment;
  final PosterStatus status;

  PosterDetailModel({
    required this.id,
    required this.thumbnailUrl,
    required this.imageUrl,
    required this.address,
    required this.status,
    required this.comment,
  });
}
