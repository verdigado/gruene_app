import 'package:gruene_app/features/campaigns/models/marker_item_model.dart';

abstract class MapController {
  void setMarkerSource(List<MarkerItemModel> poiList) {}

  void addMarkerItem(MarkerItemModel markerItem) {}
}
