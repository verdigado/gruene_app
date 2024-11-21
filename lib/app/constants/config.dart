import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get clientId => dotenv.env['CLIENT_ID'] ?? '';
  static String get issuer => dotenv.env['ISSUER'] ?? '';
  static bool get useLogin => dotenv.env['USE_LOGIN'] == 'true';
  static String get maplibreUrl => dotenv.env['MAP_MAPLIBRE_URL'] ?? '';
  static String get fluttermapVectorUrl => dotenv.env['MAP_FLUTTERMAP_VECTOR_URL'] ?? '';
  static String get fluttermapTileUrl => dotenv.env['MAP_FLUTTERMAP_TILE_URL'] ?? '';
}
