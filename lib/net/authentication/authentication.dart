import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gruene_app/common/logger.dart';

enum SecureStoreKeys {
  accesToken,
  refreshtoken,
  accessTokenExpiration,
  refreshExpiresIn
}

const authStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ),
);

Future<bool> refreshToken(String? refreshToken) async {
  const appAuth = FlutterAppAuth();
  try {
    var res = await appAuth.token(
      TokenRequest(
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
      ),
    );
    if (res == null) {
      return false;
    }
    saveTokensInSecureStorage(res);
  } on Exception catch (e, st) {
    logger.d('Fail on Authentication', [e, st]);
    return false;
  }
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
    if (result == null) {
      return false;
    }
    saveTokensInSecureStorage(result);
  } on Exception catch (e, st) {
    logger.d('Fail on Authentication', [e, st]);
    return false;
  }
  return true;
}

void saveTokensInSecureStorage(AuthorizationTokenResponse tokenResponse) {
  authStorage.write(
      key: SecureStoreKeys.accesToken.name, value: tokenResponse.accessToken);
  authStorage.write(
      key: SecureStoreKeys.refreshtoken.name,
      value: tokenResponse.refreshToken);
  authStorage.write(
      key: SecureStoreKeys.accessTokenExpiration.name,
      value: tokenResponse.accessTokenExpirationDateTime.toString());
  authStorage.write(
      key: SecureStoreKeys.refreshExpiresIn.name,
      value: tokenResponse
          .authorizationAdditionalParameters?['refresh_expires_in']);
}

Future<bool> checkCurrentAuthState() async {
  validateCurrentAuthState(
    accessToken: await authStorage.read(key: SecureStoreKeys.accesToken.name),
    accessTokenExpiration:
        await authStorage.read(key: SecureStoreKeys.accesToken.name),
    refreshtoken: await authStorage.read(key: SecureStoreKeys.accesToken.name),
    refreshExpiresIn:
        await authStorage.read(key: SecureStoreKeys.accesToken.name),
  );

  return true;
}

Future<bool> validateCurrentAuthState({
  required String? accessToken,
  required String? accessTokenExpiration,
  required String? refreshtoken,
  required String? refreshExpiresIn,
}) async {
  return true;
}

bool isExpired(String? expiration) {
  return true;
}
