import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gruene_app/app/services/campaign_action_database.dart';
import 'package:gruene_app/app/services/converters.dart';
import 'package:gruene_app/app/services/enums.dart';
import 'package:gruene_app/app/services/gruene_api_door_service.dart';
import 'package:gruene_app/app/services/gruene_api_poster_service.dart';
import 'package:gruene_app/features/campaigns/helper/campaign_action.dart';
import 'package:gruene_app/features/campaigns/helper/media_helper.dart';
import 'package:gruene_app/features/campaigns/models/doors/door_create_model.dart';
import 'package:gruene_app/features/campaigns/models/doors/door_detail_model.dart';
import 'package:gruene_app/features/campaigns/models/doors/door_update_model.dart';
import 'package:gruene_app/features/campaigns/models/marker_item_model.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_create_model.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_detail_model.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_list_item_model.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_update_model.dart';
import 'package:gruene_app/features/campaigns/widgets/map_controller_simplified.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class CampaignActionCache extends ChangeNotifier {
  static CampaignActionCache? _instance;
  var campaignActionDatabase = CampaignActionDatabase.instance;

  MapControllerSimplified? _currentMapController;

  CampaignActionCache._();

  factory CampaignActionCache() => _instance ??= CampaignActionCache._();

  Future<bool> isCached(String poiId) async {
    return campaignActionDatabase.actionsWithPoiIdExists(poiId);
  }

  Future<void> _appendActionToCache(CampaignAction action) async {
    await campaignActionDatabase.create(action);
    notifyListeners();
  }

  Future<void> _updateAction(CampaignAction action) async {
    await campaignActionDatabase.update(action);
  }

  Future<int> getCachedActionCount() {
    return campaignActionDatabase.getCount();
  }

  Future<MarkerItemModel> addCreateAction(PoiServiceType poiType, dynamic poiCreate) async {
    switch (poiType) {
      case PoiServiceType.poster:
        return await _addCreateAction<PosterCreateModel>(
          poiType: poiType,
          poi: poiCreate as PosterCreateModel,
          getJson: (poi) => poi.toJson(),
          getMarker: (poi, tempId) => poi.transformToVirtualMarkerItem(tempId),
        );
      case PoiServiceType.door:
        return await _addCreateAction<DoorCreateModel>(
          poiType: poiType,
          poi: poiCreate as DoorCreateModel,
          getJson: (poi) => poi.toJson(),
          getMarker: (poi, tempId) => poi.transformToVirtualMarkerItem(tempId),
        );
      case PoiServiceType.flyer:
        throw UnimplementedError();
    }
  }

  Future<MarkerItemModel> _addCreateAction<T>({
    required PoiServiceType poiType,
    required T poi,
    required Map<String, dynamic> Function(T) getJson,
    required MarkerItemModel Function(T, int) getMarker,
  }) async {
    final action = CampaignAction(
      actionType: poiType.getCacheAddAction(),
      serialized: jsonEncode(getJson(poi)),
    );
    await _appendActionToCache(action);
    return getMarker(poi, action.poiTempId);
  }

  Future<MarkerItemModel> addDeleteAction(PoiServiceType poiType, String poiId) async {
    final action = CampaignAction(
      poiId: int.parse(poiId),
      actionType: poiType.getCacheDeleteAction(),
    );

    var poiCacheList = await _findActionsByPoiId(poiId);
    var addActions = poiCacheList.where((p) => p.actionType == poiType.getCacheAddAction()).toList();
    if (addActions.isNotEmpty) {
      // create_action is in cache
      for (var action in poiCacheList) {
        campaignActionDatabase.delete(action.id!);
      }
      notifyListeners();
    } else {
      await _appendActionToCache(action);
    }
    return _getDeleteMarkerModel(poiType, action.poiId!);
  }

  Future<MarkerItemModel> addUpdateAction(PoiServiceType poiType, dynamic poi) async {
    switch (poiType) {
      case PoiServiceType.poster:
        return await _addUpdateAction<PosterUpdateModel>(
          poiType: poiType,
          poi: poi as PosterUpdateModel,
          getId: (poi) => poi.id,
          getJson: (poi) => poi.toJson(),
          mergeUpdates: (action, poiUpdate) => action.getAsPosterUpdate().mergeWith(poiUpdate),
          getMarker: (poi) => poi.transformToVirtualMarkerItem(),
        );
      case PoiServiceType.door:
        return await _addUpdateAction<DoorUpdateModel>(
          poiType: poiType,
          poi: poi as DoorUpdateModel,
          getId: (poi) => poi.id,
          getJson: (poi) => poi.toJson(),
          mergeUpdates: (action, poiUpdate) => poiUpdate,
          getMarker: (poi) => poi.transformToVirtualMarkerItem(),
        );
      case PoiServiceType.flyer:
        throw UnimplementedError();
    }
  }

  Future<MarkerItemModel> _addUpdateAction<T>({
    required PoiServiceType poiType,
    required T poi,
    required String Function(T) getId,
    required Map<String, dynamic> Function(T) getJson,
    required T Function(CampaignAction, T) mergeUpdates,
    required MarkerItemModel Function(T) getMarker,
  }) async {
    var actions = (await _findActionsByPoiId(getId(poi))).where((x) => x.actionType == poiType.getCacheEditAction());
    var action = actions.singleOrNull;
    if (action == null) {
      action = CampaignAction(
        poiId: int.parse(getId(poi)),
        actionType: poiType.getCacheEditAction(),
        serialized: jsonEncode(getJson(poi)),
      );
      await _appendActionToCache(action);
    } else {
      // update previous edit action
      var newPoiUpdate = mergeUpdates(action, poi);
      action.serialized = jsonEncode(getJson(newPoiUpdate));
      await _updateAction(action);
    }

    return getMarker(poi);
  }

  MarkerItemModel _getDeleteMarkerModel(PoiServiceType poiType, int id) {
    return MarkerItemModel.virtual(
      id: id,
      status: '${poiType.name}_deleted',
      location: LatLng(0, 0),
    );
  }

  Future<List<MarkerItemModel>> getMarkerItems(PoiServiceType poiType) async {
    List<MarkerItemModel> markerItems = [];
    var posterActions = [
      poiType.getCacheAddAction().index,
      poiType.getCacheEditAction().index,
      poiType.getCacheDeleteAction().index,
    ];
    final posterCacheList = await campaignActionDatabase.readAllByActionType(posterActions);
    for (var action in posterCacheList) {
      if (markerItems.any((m) => m.id! == action.id)) continue;
      switch (action.actionType) {
        case CampaignActionType.addPoster:
          var model = action.getAsPosterCreate();
          markerItems.add(model.transformToVirtualMarkerItem(action.poiTempId));
        case CampaignActionType.editPoster:
          var model = action.getAsPosterUpdate();
          markerItems.add(model.transformToVirtualMarkerItem());
        case CampaignActionType.deletePoster:
          var model = _getDeleteMarkerModel(PoiServiceType.poster, action.poiId!);
          markerItems.add(model);
        case CampaignActionType.addDoor:
          var model = action.getAsDoorCreate();
          markerItems.add(model.transformToVirtualMarkerItem(action.poiTempId));
        case CampaignActionType.editDoor:
          var model = action.getAsDoorUpdate();
          markerItems.add(model.transformToVirtualMarkerItem());
        case CampaignActionType.deleteDoor:
          var model = _getDeleteMarkerModel(PoiServiceType.door, action.poiId!);
          markerItems.add(model);
        case CampaignActionType.addFlyer:
        case CampaignActionType.editFlyer:
        case CampaignActionType.deleteFlyer:
        // var model = _getDeleteMarkerModel(PoiServiceType.door, action.poiId!);
        // markerItems.add(model);
        case CampaignActionType.unknown:
        case null:
          throw UnimplementedError();
      }
      if (action.actionType == CampaignActionType.addPoster) {}
    }
    return markerItems;
  }

  Future<PosterDetailModel> getPoiAsPosterDetail(String poiId) async {
    var detailModel = await getPoiDetail<PosterDetailModel>(
      poiId: poiId,
      addActionFilter: CampaignActionType.addDoor,
      editActionFilter: CampaignActionType.editDoor,
      transformEditAction: (action) => action.getAsPosterUpdate().transformToPosterDetailModel(),
      transformAddAction: (action) => action.getAsPosterCreate().transformToPosterDetailModel(poiId),
    );
    return detailModel;
  }

  Future<DoorDetailModel> getPoiAsDoorDetail(String poiId) async {
    var detailModel = await getPoiDetail<DoorDetailModel>(
      poiId: poiId,
      addActionFilter: CampaignActionType.addDoor,
      editActionFilter: CampaignActionType.editDoor,
      transformEditAction: (action) => action.getAsDoorUpdate().transformToDoorDetailModel(),
      transformAddAction: (action) => action.getAsDoorCreate().transformToDoorDetailModel(poiId),
    );
    return detailModel;
  }

  Future<T> getPoiDetail<T>({
    required String poiId,
    required CampaignActionType addActionFilter,
    required CampaignActionType editActionFilter,
    required T Function(CampaignAction) transformEditAction,
    required T Function(CampaignAction) transformAddAction,
  }) async {
    var cacheList = await _findActionsByPoiId(poiId);
    var addActions = cacheList.where((p) => p.actionType == addActionFilter).toList();
    var editActions = cacheList.where((p) => p.actionType == editActionFilter).toList();
    if (editActions.isNotEmpty) {
      var editAction = editActions.single;
      return transformEditAction(editAction);
    } else {
      var addAction = addActions.single;
      return transformAddAction(addAction);
    }
  }

  Future<List<CampaignAction>> _findActionsByPoiId(String poiId) async {
    var posterCacheList = campaignActionDatabase.getActionsWithPoiId(poiId);
    return posterCacheList;
  }

  void flushCachedItems() async {
    try {
      var posterApiService = GetIt.I<GrueneApiPosterService>();
      var doorApiService = GetIt.I<GrueneApiDoorService>();
      final allActions = await campaignActionDatabase.readAll();

      for (int i = 0; i < allActions.length; i++) {
        var action = allActions[i];
        switch (action.actionType) {
          case CampaignActionType.addPoster:
            var model = action.getAsPosterCreate();
            var newPosterMarker = await posterApiService.createNewPoster(model);
            await updateIds(
              oldId: action.poiTempId,
              newId: newPosterMarker.id!,
              startIndex: i + 1,
              allActions: allActions,
            );
            campaignActionDatabase.delete(action.id!);

          case CampaignActionType.editPoster:
            var model = action.getAsPosterUpdate();
            await posterApiService.updatePoster(model);
            campaignActionDatabase.delete(action.id!);

          case CampaignActionType.addDoor:
            var model = action.getAsDoorCreate();
            var newDoorMarker = await doorApiService.createNewDoor(model);
            await updateIds(
              oldId: action.poiTempId,
              newId: newDoorMarker.id!,
              startIndex: i + 1,
              allActions: allActions,
            );
            campaignActionDatabase.delete(action.id!);

          case CampaignActionType.editDoor:
            var model = action.getAsDoorUpdate();
            await doorApiService.updateDoor(model);
            campaignActionDatabase.delete(action.id!);

          case CampaignActionType.deleteDoor:
          case CampaignActionType.deletePoster:
            await posterApiService.deletePoi(action.poiId!.toString());
            campaignActionDatabase.delete(action.id!);

          case CampaignActionType.addFlyer:
          case CampaignActionType.editFlyer:
          case CampaignActionType.deleteFlyer:
          case CampaignActionType.unknown:
          case null:
            throw UnimplementedError();
        }
        notifyListeners();
      }
    } finally {
      notifyListeners();
      if (await getCachedActionCount() == 0) {
        MediaHelper.removeAllFiles();
      }
      if (_currentMapController != null) {
        _currentMapController!.resetMarkerItems();
      }
    }
  }

  Future<void> updateIds({
    required int oldId,
    required int newId,
    required List<CampaignAction> allActions,
    int startIndex = 0,
  }) async {
    await campaignActionDatabase.updatePoiId(oldId, newId);
    for (var j = startIndex; j < allActions.length; j++) {
      if (allActions[j].poiId == null) continue;
      if (allActions[j].poiId! == oldId) {
        allActions[j] = allActions[j].copyWith(poiId: newId);
      }
    }
  }

  Future<void> replaceAndFillUpMyPosterList(List<PosterListItemModel> myPosters) async {
    for (var i = 0; i < myPosters.length; i++) {
      final currentPoster = myPosters[i];
      var posterCacheList = await _findActionsByPoiId(currentPoster.id);
      var deletePosterActions = posterCacheList.where((p) => p.actionType == CampaignActionType.deletePoster).toList();
      if (deletePosterActions.isNotEmpty) {
        myPosters.remove(currentPoster);
        i--;
        continue;
      }
      var editPosterActions = posterCacheList.where((p) => p.actionType == CampaignActionType.editPoster).toList();
      if (editPosterActions.isNotEmpty) {
        var editPosterAction = editPosterActions.single;
        var posterListItem = editPosterAction.getPosterUpdateAsPosterListItem(currentPoster.createdAt);
        myPosters[i] = posterListItem;
      }
    }

    var newPosterCacheList = await campaignActionDatabase.readAllByActionType([CampaignActionType.addPoster.index]);
    for (var newPoster in newPosterCacheList) {
      var posterCacheList = await _findActionsByPoiId(newPoster.poiTempId.toString());
      var deletePosterActions = posterCacheList.where((p) => p.actionType == CampaignActionType.deletePoster).toList();
      if (deletePosterActions.isNotEmpty) {
        continue;
      }
      var editPosterActions = posterCacheList.where((p) => p.actionType == CampaignActionType.editPoster).toList();
      if (editPosterActions.isNotEmpty) {
        var editPosterAction = editPosterActions.single;
        var posterListItem =
            editPosterAction.getPosterUpdateAsPosterListItem(DateTime.fromMillisecondsSinceEpoch(newPoster.poiTempId));
        myPosters.add(posterListItem);
        continue;
      }
      var addPosterActions = posterCacheList.where((p) => p.actionType == CampaignActionType.addPoster).toList();
      if (addPosterActions.isNotEmpty) {
        var addPosterAction = addPosterActions.single;
        var posterListItem = addPosterAction.getPosterCreateAsPosterListItem();
        myPosters.add(posterListItem);
        continue;
      }
    }
  }

  Future<PosterListItemModel> getPoiAsPosterListItem(String id, {DateTime? createdAt}) async {
    var posterCacheList = await _findActionsByPoiId(id);
    var editPosterActions = posterCacheList.where((p) => p.actionType == CampaignActionType.editPoster).toList();
    if (editPosterActions.isNotEmpty) {
      var editPosterAction = editPosterActions.single;
      var posterListItem = editPosterAction.getPosterUpdateAsPosterListItem(createdAt ?? DateTime.now());
      return posterListItem;
    }
    var addPosterActions = posterCacheList.where((p) => p.actionType == CampaignActionType.addPoster).toList();
    if (addPosterActions.isNotEmpty) {
      var addPosterAction = addPosterActions.single;
      var posterListItem = addPosterAction.getPosterCreateAsPosterListItem();
      return posterListItem;
    }
    throw UnimplementedError();
  }

  void setCurrentMapController(MapControllerSimplified controller) {
    _currentMapController = controller;
  }
}
