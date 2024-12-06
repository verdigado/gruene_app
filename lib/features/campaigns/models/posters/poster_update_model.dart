import 'dart:typed_data';

import 'package:gruene_app/features/campaigns/models/posters/poster_detail_model.dart';

class PosterUpdateModel {
  final String id;
  final String street;
  final String housenumber;
  final String city;
  final String zipCode;
  final PosterStatus status;
  final String comment;
  final Uint8List? newPhoto;
  final bool removePreviousPhotos;

  PosterUpdateModel({
    required this.id,
    required this.street,
    required this.housenumber,
    required this.zipCode,
    required this.city,
    required this.status,
    required this.comment,
    required this.removePreviousPhotos,
    this.newPhoto,
  });
}
