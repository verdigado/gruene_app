import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gruene_app/common/logger.dart';

enum AccessTokenState { authenticated, unauthenticated, refreshable, expired }

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
    saveTokenValuesInSecureStorage(
      accessToken: res.accessToken,
      accessTokenExpiration: res.accessTokenExpirationDateTime.toString(),
      refreshtoken: res.refreshToken,
      // TODO: Check if value Exist
      refreshExpiresIn: res.tokenAdditionalParameters?['refresh_expires_in'],
    );
    return true;
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
    saveTokenValuesInSecureStorage(
      accessToken: result.accessToken,
      accessTokenExpiration: result.accessTokenExpirationDateTime.toString(),
      refreshtoken: result.refreshToken,
      refreshExpiresIn:
          result.authorizationAdditionalParameters?['refresh_expires_in'],
    );
  } on Exception catch (e, st) {
    logger.d('Fail on Authentication', [e, st]);
    return false;
  }
  return true;
}

void saveTokenValuesInSecureStorage({
  required String? accessToken,
  required String? refreshtoken,
  required String? accessTokenExpiration,
  required String? refreshExpiresIn,
}) {
  authStorage.write(key: SecureStoreKeys.accesToken.name, value: accessToken);
  authStorage.write(
      key: SecureStoreKeys.refreshtoken.name, value: refreshtoken);
  authStorage.write(
      key: SecureStoreKeys.accessTokenExpiration.name,
      value: accessTokenExpiration);
  authStorage.write(
      key: SecureStoreKeys.refreshExpiresIn.name, value: refreshExpiresIn);
}

// Check if the User has a valid Login
Future<bool> checkCurrentAuthState() async {
  final refresh = await authStorage.read(key: SecureStoreKeys.accesToken.name);
  var res = validateAccessToken(
    accessToken: await authStorage.read(key: SecureStoreKeys.accesToken.name),
    accessTokenExpiration:
        await authStorage.read(key: SecureStoreKeys.accesToken.name),
    refreshToken: refresh,
    refreshExpiresIn:
        await authStorage.read(key: SecureStoreKeys.accesToken.name),
  );
  switch (res) {
    case AccessTokenState.authenticated:
      return true;
    case AccessTokenState.unauthenticated:
      return false;
    case AccessTokenState.refreshable:
      return refreshToken(refresh);
    case AccessTokenState.expired:
      return false;
  }
}

AccessTokenState validateAccessToken({
  required String? accessToken,
  required String? accessTokenExpiration,
  required String? refreshToken,
  required String? refreshExpiresIn,
}) {
  if (accessToken == null) {
    return AccessTokenState.unauthenticated;
  } else if (accessTokenExpiration == null) {
    return AccessTokenState.unauthenticated;
  } else if (DateTime.now().isAfter(DateTime.parse(accessTokenExpiration))) {
    if (refreshExpiresIn == null) {
      return AccessTokenState.unauthenticated;
    }
    if (refreshToken == null ||
        DateTime.now().isAfter(DateTime.parse(refreshExpiresIn))) {
      return AccessTokenState.expired;
    } else {
      return AccessTokenState.refreshable;
    }
  } else {
    return AccessTokenState.authenticated;
  }
}
