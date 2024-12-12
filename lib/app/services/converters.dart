import 'package:gruene_app/app/services/enums.dart';
import 'package:gruene_app/app/services/nominatim_service.dart';
import 'package:gruene_app/features/campaigns/models/doors/door_detail_model.dart';
import 'package:gruene_app/features/campaigns/models/flyer/flyer_detail_model.dart';
import 'package:gruene_app/features/campaigns/models/map_layer_model.dart';
import 'package:gruene_app/features/campaigns/models/marker_item_model.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_detail_model.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_list_item_model.dart';
import 'package:gruene_app/features/campaigns/widgets/enhanced_wheel_slider.dart';
import 'package:gruene_app/features/campaigns/widgets/text_input_field.dart';
import 'package:gruene_app/i18n/translations.g.dart';
import 'package:gruene_app/swagger_generated_code/gruene_api.swagger.dart';
import 'package:intl/intl.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:turf/transform.dart';

extension PoiTypeParsing on PoiType {
  PoiServiceType transformToPoiServiceType() {
    switch (this) {
      case PoiType.flyerSpot:
        return PoiServiceType.flyer;
      case PoiType.poster:
        return PoiServiceType.poster;
      case PoiType.house:
        return PoiServiceType.door;
      case PoiType.swaggerGeneratedUnknown:
        throw UnimplementedError();
    }
  }
}

extension LatLngParsing on LatLng {
  String toLngLatString() {
    return transformToGeoJsonCoords().join(',');
  }

  List<double> transformToGeoJsonCoords() {
    return [longitude, latitude];
  }

  List<double> transformToGeoJsonBBox(LatLng northEast) {
    final southWest = this;
    final coords = southWest.transformToGeoJsonCoords();
    coords.addAll(northEast.transformToGeoJsonCoords());
    return coords;
  }

  String transformToGeoJsonBBoxString(LatLng northEast) {
    return transformToGeoJsonBBox(northEast).join(',');
  }
}

extension LatLngParsingExtended on List<double> {
  LatLng transformToLatLng() {
    if (length != 2) throw ArgumentError('coordinates should contain 2 items');
    return LatLng(this[1], this[0]);
  }
}

extension PoiServiceTypeParsing on PoiServiceType {
  V1CampaignsPoisGetType transformToApiGetType() {
    switch (this) {
      case PoiServiceType.poster:
        return V1CampaignsPoisGetType.poster;
      case PoiServiceType.door:
        return V1CampaignsPoisGetType.house;
      case PoiServiceType.flyer:
        return V1CampaignsPoisGetType.flyerSpot;
    }
  }

  CreatePoiType transformToApiCreateType() {
    switch (this) {
      case PoiServiceType.poster:
        return CreatePoiType.poster;
      case PoiServiceType.door:
        return CreatePoiType.house;
      case PoiServiceType.flyer:
        return CreatePoiType.flyerSpot;
    }
  }
}

extension PosterStatusParsing on PosterStatus {
  PoiPosterStatus transformToPoiPosterStatus() {
    return switch (this) {
      PosterStatus.ok => PoiPosterStatus.ok,
      PosterStatus.damaged => PoiPosterStatus.damaged,
      PosterStatus.missing => PoiPosterStatus.missing,
      PosterStatus.removed => PoiPosterStatus.removed,
    };
  }
}

extension PoiPosterStatusParsing on PoiPosterStatus {
  PosterStatus transformToModelPosterStatus() {
    return switch (this) {
      PoiPosterStatus.ok => PosterStatus.ok,
      PoiPosterStatus.damaged => PosterStatus.damaged,
      PoiPosterStatus.missing => PosterStatus.missing,
      PoiPosterStatus.removed => PosterStatus.removed,
      PoiPosterStatus.swaggerGeneratedUnknown => throw UnimplementedError(),
    };
  }

  String translatePosterStatus() {
    return switch (this) {
      PoiPosterStatus.ok => '',
      PoiPosterStatus.damaged => t.campaigns.posters.status.damaged.label,
      PoiPosterStatus.removed => t.campaigns.posters.status.removed.label,
      PoiPosterStatus.missing => t.campaigns.posters.status.missing.label,
      PoiPosterStatus.swaggerGeneratedUnknown => throw UnimplementedError(),
    };
  }
}

extension PoiAddressParsing on PoiAddress {
  AddressModel transformToAddressModel() {
    final address = this;
    return AddressModel(
      street: address.street,
      houseNumber: address.houseNumber,
      zipCode: address.zip,
      city: address.city,
    );
  }
}

extension AddressModelParsing on AddressModel {
  PoiAddress transformToPoiAddress() {
    final address = this;
    return PoiAddress(
      city: address.city,
      zip: address.zipCode,
      street: address.street,
      houseNumber: address.houseNumber,
    );
  }
}

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
      address: poi.address!.transformToAddressModel(),
      openedDoors: poi.house!.countOpenedDoors.toInt(),
      closedDoors: poi.house!.countClosedDoors.toInt(),
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
      address: poi.address!.transformToAddressModel(),
      status: poi.poster!.status.transformToModelPosterStatus(),
      comment: poi.poster!.comment ?? '',
    );
  }

  FlyerDetailModel transformPoiToFlyerDetail() {
    final poi = this;
    if (poi.type != PoiType.flyerSpot) {
      throw Exception('Unexpected PoiType');
    }
    return FlyerDetailModel(
      id: poi.id,
      address: poi.address!.transformToAddressModel(),
      flyerCount: poi.flyerSpot!.flyerCount.toInt(),
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
      address: poi.address!.transformToAddressModel(),
      status: poi.poster!.status.translatePosterStatus(),
      lastChangeStatus: poi._getLastChangeStatus(),
      lastChangeDateTime: poi._getLastChangeDateTimeInfo(),
      createdAt: poi.createdAt,
    );
  }

  String _getLastChangeDateTimeInfo() {
    final lastChange = updatedAt.toLocal();
    final lastChangeDate = DateFormat(t.campaigns.posters.date_format).format(lastChange);
    final lastChangeTime = DateFormat(t.campaigns.posters.time_format).format(lastChange);
    return t.campaigns.posters.datetime_display_template
        .replaceAll('{date}', lastChangeDate)
        .replaceAll('{time}', lastChangeTime);
  }

  String _getLastChangeStatus() {
    return createdAt == updatedAt ? t.campaigns.posters.created : t.campaigns.posters.updated;
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

extension FocusAreaParsing on FocusArea {
  MapLayerModel transformToMapLayer() {
    toPosition(List<double?>? point) => Position(
          point![0]!,
          point[1]!,
        );
    toPositionList(List<List<double?>?> points) => points.map(toPosition).toList();

    var coordList = polygon.coordinates.map(toPositionList).toList();
    return MapLayerModel(id: id, coords: coordList);
  }
}

extension SliderRangeParsing on SliderInputRange {
  InputFieldType getInputFieldType() {
    return switch (this) {
      SliderInputRange.numbers0To99 => InputFieldType.numbers0To99,
      SliderInputRange.numbers0To999 => InputFieldType.numbers0To999,
      SliderInputRange.numbers1To999 => InputFieldType.numbers1To999,
    };
  }

  int getMinValue() {
    return switch (this) {
      SliderInputRange.numbers0To99 => 0,
      SliderInputRange.numbers0To999 => 0,
      SliderInputRange.numbers1To999 => 1,
    };
  }

  int getMaxValue() {
    return switch (this) {
      SliderInputRange.numbers0To99 => 99,
      SliderInputRange.numbers0To999 => 999,
      SliderInputRange.numbers1To999 => 999,
    };
  }
}
