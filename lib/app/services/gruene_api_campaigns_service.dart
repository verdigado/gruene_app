import 'dart:typed_data';

import 'package:chopper/chopper.dart' as chopper;
import 'package:flutter/material.dart';
import 'package:gruene_app/app/constants/config.dart';
import 'package:gruene_app/features/campaigns/models/doors/door_create_model.dart';
import 'package:gruene_app/features/campaigns/models/doors/door_detail_model.dart';
import 'package:gruene_app/features/campaigns/models/doors/door_update_model.dart';
import 'package:gruene_app/features/campaigns/models/flyer/flyer_create_model.dart';
import 'package:gruene_app/features/campaigns/models/flyer/flyer_detail_model.dart';
import 'package:gruene_app/features/campaigns/models/flyer/flyer_update_model.dart';
import 'package:gruene_app/features/campaigns/models/marker_item_model.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_create_model.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_detail_model.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_update_model.dart';
import 'package:gruene_app/swagger_generated_code/gruene_api.swagger.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:maplibre_gl_platform_interface/maplibre_gl_platform_interface.dart';

part 'gruene_api_core.dart';

class GrueneApiCampaignsService {
  late GrueneApi grueneApi;

  final PoiServiceType poiType;

  GrueneApiCampaignsService({required this.poiType}) {
    grueneApi = _GrueneApiCore().getService();
  }

  Future<List<MarkerItemModel>> loadPoisInRegion(LatLng locationSW, LatLng locationNE) async {
    final getPoisType = _getPoiGetType();
    final getPoisResult = await grueneApi.v1CampaignsPoisGet(
      type: getPoisType,
      bbox: [locationSW.latitude, locationSW.longitude, locationNE.latitude, locationNE.longitude].join(','),
    );
    return getPoisResult.body!.data.map(_transformToMarkerItem).toList();
  }

  V1CampaignsPoisGetType _getPoiGetType() {
    switch (poiType) {
      case PoiServiceType.poster:
        return V1CampaignsPoisGetType.poster;
      case PoiServiceType.door:
        return V1CampaignsPoisGetType.house;
      case PoiServiceType.flyer:
        return V1CampaignsPoisGetType.flyerSpot;
    }
  }

  CreatePoiType _getPoiCreateType() {
    switch (poiType) {
      case PoiServiceType.poster:
        return CreatePoiType.poster;
      case PoiServiceType.door:
        return CreatePoiType.house;
      case PoiServiceType.flyer:
        return CreatePoiType.flyerSpot;
    }
  }

  MarkerItemModel _transformToMarkerItem(Poi poi) {
    String statusSuffix = '';
    if (poi.poster != null) statusSuffix = '_${poi.poster!.status.name}';
    return MarkerItemModel(
      id: int.parse(poi.id),
      location: LatLng(poi.coords[0], poi.coords[1]),
      status: '${poiType.name}$statusSuffix',
    );
  }

  Future<MarkerItemModel> createNewPoster(PosterCreateModel newPoster) async {
    final requestParam = CreatePoi(
      coords: [newPoster.location.latitude, newPoster.location.longitude],
      type: _getPoiCreateType(),
      address: PoiAddress(
        city: newPoster.city,
        zip: newPoster.zipCode,
        street: newPoster.street,
        houseNumber: newPoster.houseNumber,
      ),
    );
    // saving POI
    final newPoiResponse = await grueneApi.v1CampaignsPoisPost(body: requestParam);

    if (newPoiResponse.error == null && newPoster.photo != null) {
      // saving Photo along with POI
      var poiId = newPoiResponse.body!.id;

      _storePhoto(poiId, newPoster.photo!);
    }

    return _transformToMarkerItem(newPoiResponse.body!);
  }

  Future<PosterDetailModel> getPoiAsPosterDetail(String poiId) async {
    return _getPoi(poiId, transformPoiToPosterDetail);
  }

  Future<DoorDetailModel> getPoiAsDoorDetail(String poiId) {
    return _getPoi(poiId, transformPoiToDoorDetail);
  }

  Future<FlyerDetailModel> getPoiAsFlyerDetail(String poiId) {
    return _getPoi(poiId, transformPoiToFlyerDetail);
  }

  DoorDetailModel transformPoiToDoorDetail(Poi? poi) {
    if (poi!.type != PoiType.house) {
      throw Exception('Unexpected PoiType');
    }
    return DoorDetailModel(
      id: poi.id,
      street: poi.address!.street,
      houseNumber: poi.address!.houseNumber,
      zipCode: poi.address!.zip,
      city: poi.address!.city,
      openedDoors: poi.house!.countOpenedDoors.toInt(),
      closedDoors: poi.house!.countClosedDoors.toInt(),
    );
  }

  PosterDetailModel transformPoiToPosterDetail(Poi? poi) {
    if (poi!.type != PoiType.poster) {
      throw Exception('Unexpected PoiType');
    }
    return PosterDetailModel(
      id: poi.id,
      thumbnailUrl: _getThumbnailImageUrl(poi),
      imageUrl: _getImageUrl(poi),
      street: poi.address!.street,
      houseNumber: poi.address!.houseNumber,
      zipCode: poi.address!.zip,
      city: poi.address!.city,
      status: transformToModelPosterStatus(poi.poster!.status),
      comment: poi.poster!.comment ?? '',
    );
  }

  static String? _getThumbnailImageUrl(Poi poi) {
    if (poi.photos.isEmpty) {
      return null;
    }

    final thumbnail = poi.photos.expand((x) => x.srcset).where((x) => x.type == 'thumbnail').first;
    return thumbnail.url;
  }

  static String? _getImageUrl(Poi poi) {
    if (poi.photos.isEmpty) {
      return null;
    }

    final image = poi.photos.map((x) => x.original).first;
    return image.url;
  }

  Future<T> _getPoi<T>(String poiId, T Function(Poi?) transform) async {
    final poiResponse = await grueneApi.v1CampaignsPoisPoiIdGet(poiId: poiId);
    return transform(poiResponse.body);
  }

  Future<void> deletePoi(String poiId) async {
    // ignore: unused_local_variable
    final deletePoiResponse = await grueneApi.v1CampaignsPoisPoiIdDelete(poiId: poiId);
  }

  Future<MarkerItemModel> updatePoster(PosterUpdateModel posterUpdate) async {
    var dtoUpdate = UpdatePoi(
      address: PoiAddress(
        street: posterUpdate.street,
        houseNumber: posterUpdate.housenumber,
        zip: posterUpdate.zipCode,
        city: posterUpdate.city,
      ),
      poster: PoiPoster(status: transformToPoiPosterStatus(posterUpdate.status), comment: posterUpdate.comment),
    );
    // ignore: unused_local_variable
    var updatePoiResponse = await grueneApi.v1CampaignsPoisPoiIdPut(poiId: posterUpdate.id, body: dtoUpdate);

    if (posterUpdate.newPhoto != null || posterUpdate.removePreviousPhotos) {
      debugPrint(updatePoiResponse.body!.photos.length.toString());
      for (var photo in updatePoiResponse.body!.photos) {
        updatePoiResponse = await grueneApi.v1CampaignsPoisPoiIdPhotosPhotoIdDelete(
          poiId: posterUpdate.id,
          photoId: photo.id,
        );
      }
    }
    if (posterUpdate.newPhoto != null) {
      updatePoiResponse = await _storePhoto(posterUpdate.id, posterUpdate.newPhoto!);
    }

    return _transformToMarkerItem(updatePoiResponse.body!);
  }

  Future<MarkerItemModel> updateDoor(DoorUpdateModel doorUpdate) async {
    var dtoUpdate = UpdatePoi(
      address: PoiAddress(
        street: doorUpdate.address.street,
        houseNumber: doorUpdate.address.houseNumber,
        zip: doorUpdate.address.zipCode,
        city: doorUpdate.address.city,
      ),
      house: PoiHouse(
        countOpenedDoors: doorUpdate.openedDoors.toDouble(),
        countClosedDoors: doorUpdate.closedDoors.toDouble(),
      ),
    );
    var updatePoiResponse = await grueneApi.v1CampaignsPoisPoiIdPut(poiId: doorUpdate.id, body: dtoUpdate);

    return _transformToMarkerItem(updatePoiResponse.body!);
  }

  Future<MarkerItemModel> updateFlyer(FlyerUpdateModel flyerUpdate) async {
    var dtoUpdate = UpdatePoi(
      address: PoiAddress(
        street: flyerUpdate.address.street,
        houseNumber: flyerUpdate.address.houseNumber,
        zip: flyerUpdate.address.zipCode,
        city: flyerUpdate.address.city,
      ),
      flyerSpot: PoiFlyerSpot(
        flyerCount: flyerUpdate.flyerCount.toDouble(),
      ),
    );
    var updatePoiResponse = await grueneApi.v1CampaignsPoisPoiIdPut(poiId: flyerUpdate.id, body: dtoUpdate);

    return _transformToMarkerItem(updatePoiResponse.body!);
  }

  PosterStatus transformToModelPosterStatus(PoiPosterStatus status) {
    return switch (status) {
      PoiPosterStatus.ok => PosterStatus.ok,
      PoiPosterStatus.damaged => PosterStatus.damaged,
      PoiPosterStatus.missing => PosterStatus.missing,
      PoiPosterStatus.removed => PosterStatus.removed,
      PoiPosterStatus.swaggerGeneratedUnknown => throw UnimplementedError(),
    };
  }

  PoiPosterStatus transformToPoiPosterStatus(PosterStatus status) {
    return switch (status) {
      PosterStatus.ok => PoiPosterStatus.ok,
      PosterStatus.damaged => PoiPosterStatus.damaged,
      PosterStatus.missing => PoiPosterStatus.missing,
      PosterStatus.removed => PoiPosterStatus.removed,
    };
  }

  Future<chopper.Response<Poi>> _storePhoto(String poiId, Uint8List photo) async {
    var timeStamp = DateFormat('yyMMdd_HHmmss').format(DateTime.now());
    // ignore: unused_local_variable
    final savePoiPhotoResponse = await grueneApi.v1CampaignsPoisPoiIdPhotosPost(
      poiId: poiId,
      image: MultipartFile.fromBytes(
        'image',
        photo,
        filename: 'poi_${poiId}_$timeStamp.jpg',
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    return savePoiPhotoResponse;
  }

  Future<MarkerItemModel> createNewDoor(DoorCreateModel newDoor) async {
    final requestParam = CreatePoi(
      coords: [newDoor.location.latitude, newDoor.location.longitude],
      type: _getPoiCreateType(),
      address: PoiAddress(
        city: newDoor.address.city,
        zip: newDoor.address.zipCode,
        street: newDoor.address.street,
        houseNumber: newDoor.address.houseNumber,
      ),
      house: PoiHouse(
        countOpenedDoors: newDoor.openedDoors.toDouble(),
        countClosedDoors: newDoor.closedDoors.toDouble(),
      ),
    );
    // saving POI
    final newPoiResponse = await grueneApi.v1CampaignsPoisPost(body: requestParam);

    return _transformToMarkerItem(newPoiResponse.body!);
  }

  Future<MarkerItemModel> createNewFlyer(FlyerCreateModel newFlyer) async {
    final requestParam = CreatePoi(
      coords: [newFlyer.location.latitude, newFlyer.location.longitude],
      type: _getPoiCreateType(),
      address: PoiAddress(
        city: newFlyer.address.city,
        zip: newFlyer.address.zipCode,
        street: newFlyer.address.street,
        houseNumber: newFlyer.address.houseNumber,
      ),
      flyerSpot: PoiFlyerSpot(
        flyerCount: newFlyer.flyerCount.toDouble(),
      ),
    );
    // saving POI
    final newPoiResponse = await grueneApi.v1CampaignsPoisPost(body: requestParam);

    return _transformToMarkerItem(newPoiResponse.body!);
  }

  FlyerDetailModel transformPoiToFlyerDetail(Poi? poi) {
    if (poi!.type != PoiType.flyerSpot) {
      throw Exception('Unexpected PoiType');
    }
    return FlyerDetailModel(
      id: poi.id,
      street: poi.address!.street,
      houseNumber: poi.address!.houseNumber,
      zipCode: poi.address!.zip,
      city: poi.address!.city,
      flyerCount: poi.flyerSpot!.flyerCount.toInt(),
    );
  }
}

enum PoiServiceType { poster, door, flyer }
