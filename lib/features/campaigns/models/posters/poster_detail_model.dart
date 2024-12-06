enum PosterStatus { ok, damaged, missing, removed }

class PosterDetailModel {
  String id;
  String? thumbnailUrl;
  String? imageUrl;

  final String street;
  final String houseNumber;
  final String zipCode;
  final String city;
  final String comment;
  final PosterStatus status;

  PosterDetailModel({
    required this.id,
    required this.thumbnailUrl,
    required this.imageUrl,
    required this.street,
    required this.houseNumber,
    required this.zipCode,
    required this.city,
    required this.status,
    required this.comment,
  });
}
