import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:gruene_app/common/logger.dart';

void refreshToken(String? refreshToken) async {
  const appAuth = FlutterAppAuth();
  var res = await appAuth.token(TokenRequest(
    'gruene_app',
    'grueneapp://appAuth?prompt=login',
    discoveryUrl:
        'https://saml.gruene.de/realms/gruenes-netz/.well-known/openid-configuration',
    refreshToken: refreshToken,
    scopes: [
      "openid",
      "address",
      "acr",
      "email",
      "web-origins",
      "oauth-einverstaendniserklaerung",
      "oauth-username",
      "roles",
      "profile",
      "phone",
      "offline_access",
      "microprofile-jwt"
    ],
  ));
  res = res;
}

Future<bool> startLogin() async {
  const appAuth = FlutterAppAuth();
  try {
    final result = await appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        'gruene_app',
        'grueneapp://appAuth',
        discoveryUrl:
            'https://saml.gruene.de/realms/gruenes-netz/.well-known/openid-configuration',
        scopes: [
          "openid",
          "address",
          "acr",
          "email",
          "web-origins",
          "oauth-einverstaendniserklaerung",
          "oauth-username",
          "roles",
          "profile",
          "phone",
          "offline_access",
          "microprofile-jwt"
        ],
      ),
    );
  } on Exception catch (e, st) {
    logger.d('Fail on Authentication', [e, st]);
    return false;
  }
  // Save Token
  return true;
}
