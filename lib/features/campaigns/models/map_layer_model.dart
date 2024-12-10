import 'package:turf/transform.dart';

class MapLayerModel {
  final String id;
  final List<List<Position>> coords;

  const MapLayerModel({required this.id, required this.coords});
}
