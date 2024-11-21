import 'package:latlong2/latlong.dart';
import 'package:turf/helpers.dart';

class MapMockData {
// List<PosterPOI> pointCoords;
//  = <PosterPOI>[
//   PosterPOI('marker1', LatLng(52.529229, 13.378945)),
//   PosterPOI('marker2', LatLng(52.528599, 13.378070)),
//   PosterPOI('marker3', LatLng(52.528341, 13.379235)),
// ];
  static FeatureCollection getPosterPOIsAsGeoJson(String type) {
    return FeatureCollection(
      features: getPosterPOIs(type)
          .map(
            (x) => Feature<Point>(
              id: x.name,
              properties: <String, dynamic>{
                'type': x.status,
              },
              geometry: Point(coordinates: Position(x.coordinate.longitude, x.coordinate.latitude)),
            ),
          )
          .toList(),
    );
  }

  static List<PosterPOI> getPosterPOIs(String type) {
    List<String> poster_types = <String>{'${type}'}.toList();
    if (type == 'poster') {
      poster_types.addAll(<String>{'${type}_damaged', '${type}_taken_down'}.toList());
    }
    final LatLng start = LatLng(52.5240, 13.3782);
    int rows = 10;
    int columns = 10;
    double currentLat = start.latitude;
    double currentLng = start.longitude;
    List<PosterPOI> pointCoord = <PosterPOI>[];
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < columns; j++) {
        pointCoord.add(PosterPOI('${type}_${i}_$j', LatLng(currentLat, currentLng), (poster_types..shuffle()).first));
        currentLat += 0.001;
      }
      currentLng += 0.001;
      currentLat = start.latitude;
    }
    return pointCoord;
  }

  static final focus_area_fill = {
    'type': 'FeatureCollection',
    'features': [
      {
        'type': 'Feature',
        'id': 'focus_0', // web currently only supports number ids
        'properties': <String, dynamic>{'id': 'focus_0'},
        'geometry': {
          'type': 'Polygon',
          'coordinates': [
            focus_area.map((x) => [x.longitude, x.latitude]).toList(),
          ],
        },
      },
    ],
  };

  static List<LatLng> focus_area = <LatLng>[
    LatLng(52.530468, 13.373963),
    LatLng(52.529147, 13.377550),
    LatLng(52.530572, 13.383050),
    LatLng(52.527152, 13.386936),
    LatLng(52.526134, 13.378946),
    LatLng(52.527740, 13.375017),
    LatLng(52.529515, 13.372483),
  ];
}

class PosterPOI {
  final String name;
  final LatLng coordinate;
  final String status;

  const PosterPOI(this.name, this.coordinate, this.status);
}

// const points = {
//   'type': 'FeatureCollection',
//   'features': [
//     {
//       'type': 'Feature',
//       'id': 2,
//       'properties': {
//         'type': 'restaurant',
//       },
//       'geometry': {
//         'type': 'Point',
//         'coordinates': [13.378945, 52.529229],
//       },
//     },
//     {
//       'type': 'Feature',
//       'id': 3,
//       'properties': {
//         'type': 'airport',
//       },
//       'geometry': {
//         'type': 'Point',
//         'coordinates': [13.378070, 52.528599],
//       },
//     },
//     {
//       'type': 'Feature',
//       'id': 4,
//       'properties': {
//         'type': 'bakery',
//       },
//       'geometry': {
//         'type': 'Point',
//         'coordinates': [13.379235, 52.528341],
//       },
//     },
//   ],
// };
