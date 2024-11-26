import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get appId => dotenv.env['APP_ID'] ?? '';
  static String get oidcCallbackPath => dotenv.env['OIDC_CALLBACK_PATH'] ?? '';
  static String get oidcClientId => dotenv.env['OIDC_CLIENT_ID'] ?? '';
  static String get oidcIssuer => dotenv.env['OIDC_ISSUER'] ?? '';
  static bool get useLogin => dotenv.env['USE_LOGIN'] == 'true';
}
