import 'dart:typed_data';

import 'package:gruene_app/app/services/nominatim_service.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_detail_model.dart';

class PosterUpdateModel {
  final String id;
  final AddressModel address;
  final PosterStatus status;
  final String comment;
  final Uint8List? newPhoto;
  final bool removePreviousPhotos;

  PosterUpdateModel({
    required this.id,
    required this.address,
    required this.status,
    required this.comment,
    required this.removePreviousPhotos,
    this.newPhoto,
  });
}
