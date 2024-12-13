import 'package:gruene_app/features/campaigns/models/map_layer_model.dart';

class MapLayerDataManager {
  final Map<String, List<MapLayerModel>> loadedLayers = {};

  void addLayerData(String sourceId, List<MapLayerModel> layerData) {
    if (!loadedLayers.keys.contains(sourceId)) {
      loadedLayers.putIfAbsent(sourceId, () => []);
    }
    final currentLayerData = loadedLayers[sourceId]!;
    // Currently disabled until a proper manager is enabled
    // layerData.retainWhere(
    //   (newLayerItem) => !currentLayerData.any((currentLayerItem) => currentLayerItem.id == newLayerItem.id),
    // );
    currentLayerData.clear();
    currentLayerData.addAll(layerData);
  }

  List<MapLayerModel> getMapLayerData(String sourceId) {
    return loadedLayers[sourceId]!;
  }
}
