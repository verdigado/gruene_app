part of '../converters.dart';

extension PoiParsing on Poi {
  MarkerItemModel transformToMarkerItem() {
    final poi = this;
    String statusSuffix = '';
    if (poi.poster != null) statusSuffix = '_${poi.poster!.status.name}';
    return MarkerItemModel(
      id: int.parse(poi.id),
      location: poi.coords.transformToLatLng(),
      status: '${poi.type.transformToPoiServiceType().name}$statusSuffix',
    );
  }

  DoorDetailModel transformPoiToDoorDetail() {
    final poi = this;
    if (poi.type != PoiType.house) {
      throw Exception('Unexpected PoiType');
    }
    return DoorDetailModel(
      id: poi.id,
      address: poi.address.transformToAddressModel(),
      openedDoors: poi.house!.countOpenedDoors.toInt(),
      closedDoors: poi.house!.countClosedDoors.toInt(),
      createdAt: _getDateTimeAsString(poi.createdAt),
    );
  }

  PosterDetailModel transformPoiToPosterDetail() {
    final poi = this;
    if (poi.type != PoiType.poster) {
      throw Exception('Unexpected PoiType');
    }
    return PosterDetailModel(
      id: poi.id,
      thumbnailUrl: _getThumbnailImageUrl(poi),
      imageUrl: _getImageUrl(poi),
      address: poi.address.transformToAddressModel(),
      status: poi.poster!.status.transformToModelPosterStatus(),
      comment: poi.poster!.comment ?? '',
      createdAt: _getDateTimeAsString(poi.createdAt),
    );
  }

  FlyerDetailModel transformPoiToFlyerDetail() {
    final poi = this;
    if (poi.type != PoiType.flyerSpot) {
      throw Exception('Unexpected PoiType');
    }
    return FlyerDetailModel(
      id: poi.id,
      address: poi.address.transformToAddressModel(),
      flyerCount: poi.flyerSpot!.flyerCount.toInt(),
      createdAt: _getDateTimeAsString(poi.createdAt),
    );
  }

  PosterListItemModel transformToPosterListItem() {
    final poi = this;
    if (poi.type != PoiType.poster) {
      throw Exception('Unexpected PoiType');
    }
    return PosterListItemModel(
      id: poi.id,
      thumbnailUrl: _getThumbnailImageUrl(poi),
      imageUrl: _getImageUrl(poi),
      address: poi.address.transformToAddressModel(),
      status: poi.poster!.status.translatePosterStatus(),
      lastChangeStatus: poi._getLastChangeStatus(),
      lastChangeDateTime: poi._getLastChangeDateTimeInfo(),
      createdAt: poi.createdAt,
    );
  }

  String _getLastChangeDateTimeInfo() {
    final lastChange = updatedAt.toLocal();
    return _getDateTimeAsString(lastChange);
  }

  String _getDateTimeAsString(DateTime lastChange) {
    final lastChangeDate = DateFormat(t.campaigns.poster.date_format).format(lastChange);
    final lastChangeTime = DateFormat(t.campaigns.poster.time_format).format(lastChange);
    return t.campaigns.poster.datetime_display_template
        .replaceAll('{date}', lastChangeDate)
        .replaceAll('{time}', lastChangeTime);
  }

  String _getLastChangeStatus() {
    return createdAt == updatedAt ? t.campaigns.poster.created : t.campaigns.poster.updated;
  }

  String? _getThumbnailImageUrl(Poi poi) {
    if (poi.photos.isEmpty) {
      return null;
    }

    final thumbnail = poi.photos.expand((x) => x.srcset).where((x) => x.type == 'thumbnail').first;
    return thumbnail.url;
  }

  String? _getImageUrl(Poi poi) {
    if (poi.photos.isEmpty) {
      return null;
    }

    final image = poi.photos.map((x) => x.original).first;
    return image.url;
  }
}
