import 'package:gruene_app/app/models/campaigns/marker_item_model.dart';

abstract class MapController {
  void setMarkerSource(List<MarkerItemModel> poiList) {}

  void addMarkerItem(MarkerItemModel markerItem) {}
  // void setMarkerSource(Iterable<PosterPOI> map) {}
  // Future<void> addPOIClicked(LatLng location);

  // Future<void> bringCameraToLocation(LatLng location, {double zoomLevel});

  // Future<void> setSymbol(LatLng location, int categoryId);

  // Future<void> removeSymbol();

  // Future<void> bringCameraToUser(Position position);

  // Future<void> setTelemetryEnabled({bool enabled});
}
