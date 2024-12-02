import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gruene_app/features/campaigns/models/marker_item_model.dart';
import 'package:gruene_app/features/campaigns/widgets/map.dart';
import 'package:maplibre_gl_platform_interface/maplibre_gl_platform_interface.dart';

abstract class MapController {
  void setMarkerSource(List<MarkerItemModel> poiList) {}
  void addMarkerItem(MarkerItemModel markerItem) {}
  void removeMarkerItem(int markerItemId) {}

  Future<Point<num>?> getScreenPointFromLatLng(LatLng coord) async {
    return null;
  }

  void showMapPopover(LatLng coord, Widget widget, OnEditItemClickedCallback? onEditItemClicked) {}
}
