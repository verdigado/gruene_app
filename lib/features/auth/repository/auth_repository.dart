import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gruene_app/app/constants/config.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/logger.dart';

class AuthRepository {
  final FlutterAppAuth _appAuth = FlutterAppAuth();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final Logger _logger = Logger();

  Future<bool> signIn() async {
    try {
      final AuthorizationTokenResponse result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          Config.clientId,
          'com.example.grueneapp://oauthredirect',
          issuer: Config.issuer,
          scopes: ['openid', 'profile', 'email'],
        ),
      );

      await _secureStorage.write(key: 'access_token', value: result.accessToken);
      await _secureStorage.write(key: 'id_token', value: result.idToken);
      await _secureStorage.write(key: 'refresh_token', value: result.refreshToken);
      return true;
    } on FlutterAppAuthUserCancelledException catch (e) {
      _logger.w('Sign-in was cancelled: $e');
    } catch (e) {
      _logger.w('Sign-in was not successful: $e');
    }
    return false;
  }

  Future<void> signOut() async {
    await _secureStorage.deleteAll();
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'access_token');
  }

  Future<bool> isTokenValid() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return false;

    return !JwtDecoder.isExpired(accessToken);
  }

  Future<bool> refreshToken() async {
    final refreshToken = await _secureStorage.read(key: 'refresh_token');
    if (refreshToken == null) return false;

    try {
      final TokenResponse result = await _appAuth.token(
        TokenRequest(
          Config.clientId,
          'com.example.grueneapp://oauthredirect',
          refreshToken: refreshToken,
          issuer: Config.issuer,
        ),
      );

      await _secureStorage.write(key: 'access_token', value: result.accessToken);
      await _secureStorage.write(key: 'id_token', value: result.idToken);
      await _secureStorage.write(key: 'refresh_token', value: result.refreshToken);
      return true;
    } catch (e) {
      _logger.w('Token refresh was not successful: $e');
    }
    return false;
  }
}
