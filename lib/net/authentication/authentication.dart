import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gruene_app/common/logger.dart';
import 'package:gruene_app/constants/app_const.dart';

const discoveryUrl =
    'https://saml.gruene.de/realms/gruenes-netz/.well-known/openid-configuration';
const clientId = 'gruene_app';
const redirectUrl = 'grueneapp://appAuth';
const scopes = ["openid", "offline_access", "microprofile-jwt"];

enum AccessTokenState { authenticated, unauthenticated, refreshable, expired }

enum SecureStoreKeys {
  accesToken,
  refreshtoken,
  accessTokenExpiration,
  refreshExpiresIn,
  idToken
}

// refreshWindow in sec. => 3 Days
const refreshWindow = 259200;

const authStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ),
);

Future<bool> signOut() async {
  const appAuth = FlutterAppAuth();
  try {
    await appAuth.endSession(EndSessionRequest(
      idTokenHint: await authStorage.read(key: SecureStoreKeys.idToken.name),
      postLogoutRedirectUrl: redirectUrl,
      discoveryUrl: discoveryUrl,
      preferEphemeralSession: true,
    ));
    await authStorage.deleteAll();
    return true;
  } on Exception catch (e, st) {
    logger.d('Fail on signOut', [e, st]);
    return false;
  }
}

Future<bool> refreshToken(String? refreshToken) async {
  const appAuth = FlutterAppAuth();
  try {
    var res = await appAuth.token(
      TokenRequest(
        clientId,
        redirectUrl,
        discoveryUrl: discoveryUrl,
        refreshToken: refreshToken,
        scopes: scopes,
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
        refreshExpiresIn:
            res.tokenAdditionalParameters?['refresh_expires_in'].toString(),
        idToken: res.idToken);
    return true;
  } on Exception catch (e, st) {
    logger.d('Fail on Authentication', [e, st]);
    return false;
  }
}

Future<bool> startLogin() async {
  if (await checkCurrentAuthState()) return true;

  const appAuth = FlutterAppAuth();
  try {
    final result = await appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        preferEphemeralSession: true,
        clientId,
        redirectUrl,
        discoveryUrl: discoveryUrl,
        scopes: scopes,
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
            result.tokenAdditionalParameters?['refresh_expires_in'].toString(),
        idToken: result.idToken);
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
  required String? idToken,
}) async {
  GruneAppData.values.api.setBearerAuth('bearer', accessToken ?? '');
  await authStorage.write(
      key: SecureStoreKeys.accesToken.name, value: accessToken);
  await authStorage.write(
      key: SecureStoreKeys.refreshtoken.name, value: refreshtoken);
  await authStorage.write(
      key: SecureStoreKeys.accessTokenExpiration.name,
      value: accessTokenExpiration);
  await authStorage.write(
      key: SecureStoreKeys.refreshExpiresIn.name, value: refreshExpiresIn);
  await authStorage.write(key: SecureStoreKeys.idToken.name, value: idToken);
}

// Check if the User has a valid Login
Future<bool> checkCurrentAuthState() async {
  final refresh =
      await authStorage.read(key: SecureStoreKeys.refreshtoken.name);
  String? accessToken =
      await authStorage.read(key: SecureStoreKeys.accesToken.name);
  var res = validateAccessToken(
    accessToken: accessToken,
    accessTokenExpiration:
        await authStorage.read(key: SecureStoreKeys.accessTokenExpiration.name),
    refreshToken: refresh,
    refreshExpiresIn:
        await authStorage.read(key: SecureStoreKeys.refreshExpiresIn.name),
  );
  switch (res) {
    case AccessTokenState.authenticated:
      GruneAppData.values.api.setBearerAuth('bearer', accessToken ?? '');
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
  if (accessToken == null || accessTokenExpiration == null) {
    return AccessTokenState.unauthenticated;
  }
  DateTime? expirationTime = DateTime.tryParse(accessTokenExpiration);
  var refreshExpirationTime = int.tryParse(refreshExpiresIn ?? '') ?? 0;

  if (expirationTime == null || expirationTime.isBefore(DateTime.now())) {
    if (refreshToken == null || refreshExpirationTime <= refreshWindow) {
      return AccessTokenState.expired;
    } else {
      return AccessTokenState.refreshable;
    }
  } else {
    return AccessTokenState.authenticated;
  }
}
