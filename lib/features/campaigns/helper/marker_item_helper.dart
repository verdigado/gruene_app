import 'dart:math';

import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/features/campaigns/models/map_layer_model.dart';
import 'package:gruene_app/features/campaigns/models/marker_item_model.dart';
import 'package:turf/transform.dart';

class MarkerItemHelper {
  static FeatureCollection transformListToGeoJson(List<MarkerItemModel> markerItems) {
    return FeatureCollection(features: markerItems.map(transformMarkerItemToGeoJson).toList());
  }

  static Feature<Point> transformMarkerItemToGeoJson(MarkerItemModel markerItem) {
    return Feature<Point>(
      id: markerItem.id,
      properties: <String, dynamic>{
        'status_type': markerItem.status,
      },
      geometry: Point(coordinates: Position(markerItem.location.longitude, markerItem.location.latitude)),
    );
  }

  static FeatureCollection transformMapLayerDataToGeoJson(List<MapLayerModel> mapLayerData) {
    return FeatureCollection(features: mapLayerData.map(transformMapLayerModelToGeoJson).toList());
  }

  static Feature<Polygon> transformMapLayerModelToGeoJson(MapLayerModel mapLayerModel) {
    final scoreColors = [ThemeColors.primary, ThemeColors.secondary, ThemeColors.tertiary];
    final random = Random();
    final scoreColor = scoreColors[random.nextInt(scoreColors.length)];
    return Feature<Polygon>(
      id: mapLayerModel.id,
      properties: <String, dynamic>{
        'id': mapLayerModel.id.toString(),
        'score_color': 'rgb(${scoreColor.red},${scoreColor.green},${scoreColor.blue})',
        'score_opacity': random.nextDouble() * 0.8,
      },
      geometry: Polygon(coordinates: mapLayerModel.coords),
    );
  }
}
