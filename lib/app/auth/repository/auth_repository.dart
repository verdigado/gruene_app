import 'dart:async';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gruene_app/app/constants/config.dart';
import 'package:gruene_app/app/constants/secure_storage_keys.dart';
import 'package:gruene_app/app/utils/logger.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthRepository {
  final FlutterAppAuth _appAuth = FlutterAppAuth();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<bool> login() async {
    try {
      final AuthorizationTokenResponse result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          Config.oidcClientId,
          Config.oidcCallbackPath,
          allowInsecureConnections: Config.isDevelopment,
          issuer: Config.oidcIssuer,
          scopes: ['openid', 'profile', 'email', 'offline_access'],
        ),
      );

      await _secureStorage.write(key: SecureStorageKeys.accessToken, value: result.accessToken);
      await _secureStorage.write(key: SecureStorageKeys.idToken, value: result.idToken);
      await _secureStorage.write(key: SecureStorageKeys.refreshToken, value: result.refreshToken);

      logger.d('Login successful');

      return true;
    } on FlutterAppAuthUserCancelledException catch (e) {
      logger.d('Login cancelled: $e');
    } catch (e) {
      logger.w('SLogin failed: $e');
    }
    return false;
  }

  Future<void> logout() async {
    final idToken = await _secureStorage.read(key: SecureStorageKeys.idToken);

    await _appAuth.endSession(
      EndSessionRequest(
        idTokenHint: idToken,
        postLogoutRedirectUrl: Config.oidcCallbackPath,
        discoveryUrl: '${Config.oidcIssuer}/.well-known/openid-configuration',
        allowInsecureConnections: Config.isDevelopment,
      ),
    );

    logger.d('Logout successful');
    await _deleteTokens();
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: SecureStorageKeys.accessToken);
  }

  Future<bool> isTokenValid() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) {
      logger.d('Access token not found');
      return false;
    }

    final isExpired = JwtDecoder.isExpired(accessToken);
    logger.d('Access token ${isExpired ? 'expired' : 'valid'}');
    return !isExpired;
  }

  Future<bool> refreshToken() async {
    final refreshToken = await _secureStorage.read(key: SecureStorageKeys.refreshToken);
    if (refreshToken == null) {
      logger.d('Refresh token not found');
      return false;
    }

    try {
      final TokenResponse result = await _appAuth.token(
        TokenRequest(
          Config.oidcClientId,
          Config.oidcCallbackPath,
          allowInsecureConnections: Config.isDevelopment,
          refreshToken: refreshToken,
          issuer: Config.oidcIssuer,
        ),
      );

      await _secureStorage.write(key: SecureStorageKeys.accessToken, value: result.accessToken);
      await _secureStorage.write(key: SecureStorageKeys.idToken, value: result.idToken);
      await _secureStorage.write(key: SecureStorageKeys.refreshToken, value: result.refreshToken);
      logger.d('Token refresh successful');
      return true;
    } catch (e) {
      logger.w('Token refresh failed: $e');
    }
    return false;
  }

  Future<void> _deleteTokens() async {
    await _secureStorage.delete(key: SecureStorageKeys.accessToken);
    await _secureStorage.delete(key: SecureStorageKeys.idToken);
    await _secureStorage.delete(key: SecureStorageKeys.refreshToken);
    logger.d('Tokens deleted successfully');
  }
}
