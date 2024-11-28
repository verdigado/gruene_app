import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get appId => 'de.gruene.wkapp';
  static String get oidcCallbackPath => '${Config.appId}://oauthredirect';
  static String get oidcClientId => dotenv.env['OIDC_CLIENT_ID'] ?? '';
  static String get oidcIssuer => dotenv.env['OIDC_ISSUER'] ?? '';
  static bool get useLogin => dotenv.env['USE_LOGIN'] == 'true';
}
