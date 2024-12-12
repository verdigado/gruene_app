import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/features/campaigns/models/map_layer_model.dart';
import 'package:gruene_app/features/campaigns/models/marker_item_model.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
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
    var opacities = [0, 0.2, 0.35, 0.5, 0.65];
    final scoreColor = ThemeColors.secondary.toHexStringRGB(); //scoreColors[random.nextInt(scoreColors.length)];
    var scoreIndex = mapLayerModel.score.toInt() - 1;
    return Feature<Polygon>(
      id: mapLayerModel.id,
      properties: <String, dynamic>{
        'id': mapLayerModel.id.toString(),
        'score_color': scoreColor,
        'score_opacity': scoreIndex > opacities.length || scoreIndex < 0 ? opacities.first : opacities[scoreIndex],
        'info': mapLayerModel.description,
      },
      geometry: Polygon(coordinates: mapLayerModel.coords),
    );
  }
}
