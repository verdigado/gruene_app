import 'package:gruene_app/features/campaigns/models/marker_item_model.dart';

class MarkerItemManager {
  final List<MarkerItemModel> loadedMarkers = [];

  void addMarkers(List<MarkerItemModel> poiList) {
    loadedMarkers.retainWhere((oldMarker) => poiList.any((newMarker) => newMarker.id != oldMarker.id));
    loadedMarkers.addAll(poiList);
  }

  List<MarkerItemModel> getMarkers() {
    return loadedMarkers;
  }

  void removeMarker(int markerItemId) {
    loadedMarkers.retainWhere((item) => item.id == null || item.id != markerItemId);
  }
}
