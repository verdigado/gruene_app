import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gruene_app/app/services/campaign_action_database.dart';
import 'package:gruene_app/app/services/converters.dart';
import 'package:gruene_app/app/services/gruene_api_poster_service.dart';
import 'package:gruene_app/features/campaigns/helper/campaign_action.dart';
import 'package:gruene_app/features/campaigns/helper/media_helper.dart';
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

  Future<void> _addAction(CampaignAction action) async {
    await campaignActionDatabase.create(action);
    notifyListeners();
  }

  Future<void> _updateAction(CampaignAction action) async {
    await campaignActionDatabase.update(action);
  }

  Future<int> getCachedActionCount() {
    return campaignActionDatabase.getCount();
  }

  Future<MarkerItemModel> addPosterCreate(PosterCreateModel posterCreate) async {
    final action = CampaignAction(
      actionType: CampaignActionType.addPoster,
      serialized: jsonEncode(posterCreate.toJson()),
    );
    await _addAction(action);
    return posterCreate.transformToVirtualMarkerItem(action.poiTempId);
  }

  Future<MarkerItemModel> addPosterDelete(String posterId) async {
    final action = CampaignAction(
      poiId: int.parse(posterId),
      actionType: CampaignActionType.deletePoster,
    );

    var posterCacheList = await _findActionsByPoiId(posterId);
    var addPosterActions = posterCacheList.where((p) => p.actionType == CampaignActionType.addPoster).toList();
    if (addPosterActions.isNotEmpty) {
      // create_action is in cache
      for (var action in posterCacheList) {
        campaignActionDatabase.delete(action.id!);
      }
      notifyListeners();
    } else {
      await _addAction(action);
    }
    return _getDeletePosterMarkerModel(action.poiId!);
  }

  Future<MarkerItemModel> addPosterUpdate(PosterUpdateModel posterUpdate) async {
    var actions =
        (await _findActionsByPoiId(posterUpdate.id)).where((x) => x.actionType == CampaignActionType.editPoster);
    var action = actions.singleOrNull;
    if (action == null) {
      action = CampaignAction(
        poiId: int.parse(posterUpdate.id),
        actionType: CampaignActionType.editPoster,
        serialized: jsonEncode(posterUpdate.toJson()),
      );
      await _addAction(action);
    } else {
      // update previous edit action
      var oldUpdate = action.getAsPosterUpdate();
      var newPosterUpdate = oldUpdate.mergeWith(posterUpdate);
      action.serialized = jsonEncode(newPosterUpdate.toJson());
      await _updateAction(action);
    }

    return posterUpdate.transformToVirtualMarkerItem();
  }

  MarkerItemModel _getDeletePosterMarkerModel(int id) {
    return MarkerItemModel.virtual(
      id: id,
      status: 'poster_deleted',
      location: LatLng(0, 0),
    );
  }

  Future<List<MarkerItemModel>> getPosterMarkerItems() async {
    List<MarkerItemModel> markerItems = [];
    var posterActions = [
      CampaignActionType.addPoster.index,
      CampaignActionType.editPoster.index,
      CampaignActionType.deletePoster.index,
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
          var model = _getDeletePosterMarkerModel(action.poiId!);
          markerItems.add(model);
        case CampaignActionType.unknown:
        case CampaignActionType.addDoor:
        case CampaignActionType.editDoor:
        case CampaignActionType.deleteDoor:
        case CampaignActionType.addFlyer:
        case CampaignActionType.editFlyer:
        case CampaignActionType.deleteFlyer:
        case null:
          throw UnimplementedError();
      }
      if (action.actionType == CampaignActionType.addPoster) {}
    }
    return markerItems;
  }

  Future<PosterDetailModel> getPoiAsPosterDetail(String poiId) async {
    var posterCacheList = await _findActionsByPoiId(poiId);
    var addPosterActions = posterCacheList.where((p) => p.actionType == CampaignActionType.addPoster).toList();
    var editPosterActions = posterCacheList.where((p) => p.actionType == CampaignActionType.editPoster).toList();
    if (editPosterActions.isNotEmpty) {
      var editPosterAction = editPosterActions.single;
      var model = editPosterAction.getAsPosterUpdate();
      return model.transformToPosterDetailModel(int.parse(poiId));
    } else {
      var addPosterAction = addPosterActions.single;

      var model = addPosterAction.getAsPosterCreate();
      return model.transformToPosterDetailModel(int.parse(poiId));
    }
  }

  Future<List<CampaignAction>> _findActionsByPoiId(String poiId) async {
    var posterCacheList = campaignActionDatabase.getActionsWithPoiId(poiId);
    return posterCacheList;
  }

  void flushCachedItems() async {
    try {
      var posterApiService = GetIt.I<GrueneApiPosterService>();
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
          case CampaignActionType.deletePoster:
            await posterApiService.deletePoi(action.poiId!.toString());
            campaignActionDatabase.delete(action.id!);
          case CampaignActionType.addDoor:
          case CampaignActionType.editDoor:
          case CampaignActionType.deleteDoor:
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
