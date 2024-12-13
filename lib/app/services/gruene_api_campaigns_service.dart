import 'dart:async';
import 'dart:io';

import 'package:chopper/chopper.dart' as chopper;
import 'package:flutter/foundation.dart';
import 'package:gruene_app/app/auth/repository/auth_repository.dart';
import 'package:gruene_app/app/constants/config.dart';
import 'package:gruene_app/app/services/converters.dart';
import 'package:gruene_app/app/services/enums.dart';
import 'package:gruene_app/features/campaigns/models/doors/door_create_model.dart';
import 'package:gruene_app/features/campaigns/models/doors/door_detail_model.dart';
import 'package:gruene_app/features/campaigns/models/doors/door_update_model.dart';
import 'package:gruene_app/features/campaigns/models/flyer/flyer_create_model.dart';
import 'package:gruene_app/features/campaigns/models/flyer/flyer_detail_model.dart';
import 'package:gruene_app/features/campaigns/models/flyer/flyer_update_model.dart';
import 'package:gruene_app/features/campaigns/models/map_layer_model.dart';
import 'package:gruene_app/features/campaigns/models/marker_item_model.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_create_model.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_detail_model.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_list_item_model.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_update_model.dart';
import 'package:gruene_app/swagger_generated_code/gruene_api.swagger.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

part 'gruene_api_core.dart';

class GrueneApiCampaignsService {
  late GrueneApi grueneApi;

  final PoiServiceType poiType;

  GrueneApiCampaignsService({required this.poiType}) {
    grueneApi = _GrueneApiCore().service;
  }

  Future<List<MarkerItemModel>> loadPoisInRegion(LatLng locationSW, LatLng locationNE) async {
    final getPoisType = poiType.transformToApiGetType();

    final getPoisResult = await grueneApi.v1CampaignsPoisGet(
      type: getPoisType,
      bbox: locationSW.transformToGeoJsonBBoxString(locationNE),
    );
    if (getPoisResult.error != null) debugPrint(getPoisResult.error!.toString());

    return getPoisResult.body!.data.map((p) => p.transformToMarkerItem()).toList();
  }

  Future<List<MapLayerModel>> loadFocusAreasInRegion(LatLng locationSW, LatLng locationNE) async {
    var transformToGeoJsonBBoxString = locationSW.transformToGeoJsonBBoxString(locationNE);
    final getPoisResult = await grueneApi.v1CampaignsFocusAreasGet(
      bbox: transformToGeoJsonBBoxString,
    );
    return getPoisResult.body!.data.map((layerItem) => layerItem.transformToMapLayer()).toList();
  }

  Future<MarkerItemModel> createNewPoster(PosterCreateModel newPoster) async {
    final requestParam = CreatePoi(
      coords: newPoster.location.transformToGeoJsonCoords(),
      type: poiType.transformToApiCreateType(),
      address: newPoster.address.transformToPoiAddress(),
    );
    // saving POI
    final newPoiResponse = await grueneApi.v1CampaignsPoisPost(body: requestParam);

    if (newPoiResponse.error == null && newPoster.photo != null) {
      // saving Photo along with POI
      var poiId = newPoiResponse.body!.id;

      await _storeNewPhoto(poiId, newPoster.photo!);
    }

    return newPoiResponse.body!.transformToMarkerItem();
  }

  Future<MarkerItemModel> createNewDoor(DoorCreateModel newDoor) async {
    final requestParam = CreatePoi(
      coords: newDoor.location.transformToGeoJsonCoords(),
      type: poiType.transformToApiCreateType(),
      address: newDoor.address.transformToPoiAddress(),
      house: PoiHouse(
        countOpenedDoors: newDoor.openedDoors.toDouble(),
        countClosedDoors: newDoor.closedDoors.toDouble(),
      ),
    );
    // saving POI
    final newPoiResponse = await grueneApi.v1CampaignsPoisPost(body: requestParam);

    return newPoiResponse.body!.transformToMarkerItem();
  }

  Future<MarkerItemModel> createNewFlyer(FlyerCreateModel newFlyer) async {
    final requestParam = CreatePoi(
      coords: newFlyer.location.transformToGeoJsonCoords(),
      type: poiType.transformToApiCreateType(),
      address: newFlyer.address.transformToPoiAddress(),
      flyerSpot: PoiFlyerSpot(
        flyerCount: newFlyer.flyerCount.toDouble(),
      ),
    );
    // saving POI
    final newPoiResponse = await grueneApi.v1CampaignsPoisPost(body: requestParam);

    return newPoiResponse.body!.transformToMarkerItem();
  }

  Future<PosterDetailModel> getPoiAsPosterDetail(String poiId) async {
    return _getPoi(poiId, (p) => p.transformPoiToPosterDetail());
  }

  Future<PosterListItemModel> getPoiAsPosterListItem(String poiId) {
    return _getPoi(poiId, (p) => p.transformToPosterListItem());
  }

  Future<DoorDetailModel> getPoiAsDoorDetail(String poiId) {
    return _getPoi(poiId, (p) => p.transformPoiToDoorDetail());
  }

  Future<FlyerDetailModel> getPoiAsFlyerDetail(String poiId) {
    return _getPoi(poiId, (p) => p.transformPoiToFlyerDetail());
  }

  Future<T> _getPoi<T>(String poiId, T Function(Poi) transform) async {
    final poiResponse = await grueneApi.v1CampaignsPoisPoiIdGet(poiId: poiId);
    return transform(poiResponse.body!);
  }

  Future<void> deletePoi(String poiId) async {
    // ignore: unused_local_variable
    final deletePoiResponse = await grueneApi.v1CampaignsPoisPoiIdDelete(poiId: poiId);
  }

  Future<MarkerItemModel> updatePoster(PosterUpdateModel posterUpdate) async {
    var dtoUpdate = UpdatePoi(
      address: posterUpdate.address.transformToPoiAddress(),
      poster: PoiPoster(
        status: posterUpdate.status.transformToPoiPosterStatus(),
        comment: posterUpdate.comment,
      ),
    );
    var updatePoiResponse = await grueneApi.v1CampaignsPoisPoiIdPut(poiId: posterUpdate.id, body: dtoUpdate);

    if (posterUpdate.newPhoto != null || posterUpdate.removePreviousPhotos) {
      for (var photo in updatePoiResponse.body!.photos) {
        updatePoiResponse = await grueneApi.v1CampaignsPoisPoiIdPhotosPhotoIdDelete(
          poiId: posterUpdate.id,
          photoId: photo.id,
        );
      }
    }
    if (posterUpdate.newPhoto != null) {
      updatePoiResponse = await _storeNewPhoto(posterUpdate.id, posterUpdate.newPhoto!);
    }

    return updatePoiResponse.body!.transformToMarkerItem();
  }

  Future<MarkerItemModel> updateDoor(DoorUpdateModel doorUpdate) async {
    var dtoUpdate = UpdatePoi(
      address: doorUpdate.address.transformToPoiAddress(),
      house: PoiHouse(
        countOpenedDoors: doorUpdate.openedDoors.toDouble(),
        countClosedDoors: doorUpdate.closedDoors.toDouble(),
      ),
    );
    var updatePoiResponse = await grueneApi.v1CampaignsPoisPoiIdPut(poiId: doorUpdate.id, body: dtoUpdate);

    return updatePoiResponse.body!.transformToMarkerItem();
  }

  Future<MarkerItemModel> updateFlyer(FlyerUpdateModel flyerUpdate) async {
    var dtoUpdate = UpdatePoi(
      address: flyerUpdate.address.transformToPoiAddress(),
      flyerSpot: PoiFlyerSpot(
        flyerCount: flyerUpdate.flyerCount.toDouble(),
      ),
    );
    var updatePoiResponse = await grueneApi.v1CampaignsPoisPoiIdPut(poiId: flyerUpdate.id, body: dtoUpdate);

    return updatePoiResponse.body!.transformToMarkerItem();
  }

  Future<chopper.Response<Poi>> _storeNewPhoto(String poiId, Uint8List photo) async {
    var timeStamp = DateFormat('yyMMdd_HHmmss').format(DateTime.now());
    // ignore: unused_local_variable
    final savePoiPhotoResponse = await grueneApi.v1CampaignsPoisPoiIdPhotosPost(
      poiId: poiId,
      image: http.MultipartFile.fromBytes(
        'image',
        photo,
        filename: 'poi_${poiId}_$timeStamp.jpg',
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    return savePoiPhotoResponse;
  }

  Future<List<PosterListItemModel>> getMyPosters() async {
    final getPoisType = poiType.transformToApiSelfGetType();

    final getPoisResult = await grueneApi.v1CampaignsPoisSelfGet(type: getPoisType);
    return getPoisResult.body!.data.map((p) => p.transformToPosterListItem()).toList();
  }
}
