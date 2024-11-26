import 'package:gruene_app/app/models/campaigns/marker_item_model.dart';
import 'package:turf/bbox_polygon.dart';
import 'package:turf/helpers.dart';
import 'package:turf/transform.dart';

class MarkerItemHelper {
  static FeatureCollection transformListToGeoJson(List<MarkerItemModel> markerItems) {
    return FeatureCollection(features: markerItems.map(transformMarkerItemToGeoJson).toList());
  }

  static Feature<Point> transformMarkerItemToGeoJson(MarkerItemModel markerItem) {
    return Feature<Point>(
      id: markerItem.id,
      properties: <String, dynamic>{
        'type': markerItem.status ?? 'poster',
      },
      geometry: Point(coordinates: Position(markerItem.location.longitude, markerItem.location.latitude)),
    );
  }
}
