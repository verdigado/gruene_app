import 'dart:async';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gruene_app/app/constants/config.dart';
import 'package:gruene_app/app/constants/secure_storage_keys.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/logger.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthRepository {
  final FlutterAppAuth _appAuth = FlutterAppAuth();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final Logger _logger = Logger();

  Future<bool> signIn() async {
    try {
      final AuthorizationTokenResponse result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          Config.oidcClientId,
          '${Config.appId}://${Config.oidcCallbackPath}',
          issuer: Config.oidcIssuer,
          scopes: ['openid', 'profile', 'email'],
        ),
      );

      await _secureStorage.write(key: SecureStorageKeys.accessToken, value: result.accessToken);
      await _secureStorage.write(key: SecureStorageKeys.idToken, value: result.idToken);
      await _secureStorage.write(key: SecureStorageKeys.refreshToken, value: result.refreshToken);
      return true;
    } on FlutterAppAuthUserCancelledException catch (e) {
      _logger.w('Sign-in was cancelled: $e');
    } catch (e) {
      _logger.w('Sign-in was not successful: $e');
    }
    return false;
  }

  Future<void> signOut() async {
    final idToken = await _secureStorage.read(key: SecureStorageKeys.idToken);
    final postLogoutRedirectUrl = '${Config.appId}://${Config.oidcCallbackPath}';
    final endSessionUrl =
        '${Config.oidcIssuer}/protocol/openid-connect/logout?id_token_hint=$idToken&post_logout_redirect_uri=$postLogoutRedirectUrl';

    final Completer<void> completer = Completer<void>();
    final webViewController = WebViewController();

    webViewController.setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (String url) {
          if (url.startsWith(postLogoutRedirectUrl)) {
            completer.complete();
          }
        },
      ),
    );

    webViewController.loadRequest(Uri.parse(endSessionUrl));
    await completer.future;
    await _secureStorage.deleteAll();
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: SecureStorageKeys.accessToken);
  }

  Future<bool> isTokenValid() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return false;

    return !JwtDecoder.isExpired(accessToken);
  }

  Future<bool> refreshToken() async {
    final refreshToken = await _secureStorage.read(key: SecureStorageKeys.refreshToken);
    if (refreshToken == null) return false;

    try {
      final TokenResponse result = await _appAuth.token(
        TokenRequest(
          Config.oidcClientId,
          '${Config.appId}://${Config.oidcCallbackPath}',
          refreshToken: refreshToken,
          issuer: Config.oidcIssuer,
        ),
      );

      await _secureStorage.write(key: SecureStorageKeys.accessToken, value: result.accessToken);
      await _secureStorage.write(key: SecureStorageKeys.idToken, value: result.idToken);
      await _secureStorage.write(key: SecureStorageKeys.refreshToken, value: result.refreshToken);
      return true;
    } catch (e) {
      _logger.w('Token refresh was not successful: $e');
    }
    return false;
  }
}
