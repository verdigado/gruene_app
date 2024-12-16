import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get appId => 'de.gruene.wkapp';
  static String get oidcCallbackPath => '${Config.appId}://oauthredirect';
  static String get oidcClientId => dotenv.env['OIDC_CLIENT_ID'] ?? '';
  static String get oidcIssuer => dotenv.env['OIDC_ISSUER'] ?? '';
  static bool get useLogin => dotenv.env['USE_LOGIN'] == 'true';
  static String get maplibreUrl => dotenv.env['MAP_MAPLIBRE_URL'] ?? '';
  static String get addressSearchUrl => dotenv.env['MAP_ADDRESSSEARCH_URL'] ?? '';
  static String get gruenesNetzApiUrl => dotenv.env['GRUENES_NETZ_API_URL'] ?? 'http://localhost:5000';
  static String get gruenesNetzApiKey => dotenv.env['GRUENES_NETZ_API_KEY'] ?? '';
  static bool get androidFloss {
    // may be needed when building for f-droid store
    final configValue = dotenv.env['ANDROID_FLOSS'] ?? 'false';
    final value = bool.tryParse(configValue, caseSensitive: false);
    return value ?? false;
  }
}
