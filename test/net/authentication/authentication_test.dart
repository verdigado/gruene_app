import 'package:gruene_app/net/authentication/authentication.dart';
import 'package:test/test.dart';

void main() {
  group('Access Token Validation', () {
    test('Valid access token should be authenticated', () {
      const accessToken = 'valid_access_token';
      final expirationTime = DateTime.now().add(const Duration(hours: 1));
      const refreshToken = 'valid_refresh_token';

      expect(
        validateAccessToken(
            accessToken: accessToken,
            accessTokenExpiration: expirationTime.toString(),
            refreshToken: refreshToken,
            refreshExpiresIn: '${refreshWindow + 100}'),
        AccessTokenState.authenticated,
      );
    });

    test('Null access token should be unauthenticated', () {
      const accessToken = null;
      final expirationTime = DateTime.now().add(const Duration(hours: 1));
      const refreshToken = 'valid_refresh_token';
      expect(
        validateAccessToken(
            accessToken: accessToken,
            accessTokenExpiration: expirationTime.toString(),
            refreshToken: refreshToken,
            refreshExpiresIn: '${refreshWindow + 100}'),
        AccessTokenState.unauthenticated,
      );
    });

    test('Expired access token with valid refresh token should be refreshable',
        () {
      const accessToken = 'expired_access_token';
      final expirationTime = DateTime.now().subtract(const Duration(hours: 1));
      const refreshToken = 'valid_refresh_token';

      expect(
        validateAccessToken(
            accessToken: accessToken,
            accessTokenExpiration: expirationTime.toString(),
            refreshToken: refreshToken,
            refreshExpiresIn: '${refreshWindow + 100}'),
        AccessTokenState.refreshable,
      );
    });
    test('access token is authenticated', () {
      final accessTokenExpiration =
          DateTime.now().add(const Duration(hours: 1));
      expect(
          validateAccessToken(
              accessToken: 'my-access-token',
              accessTokenExpiration: accessTokenExpiration.toString(),
              refreshToken: null,
              refreshExpiresIn: null),
          equals(AccessTokenState.authenticated));
    });
    test('access token is unauthenticated', () {
      expect(
          validateAccessToken(
              accessToken: null,
              accessTokenExpiration: null,
              refreshToken: null,
              refreshExpiresIn: null),
          equals(AccessTokenState.unauthenticated));
    });

    test('access token is expired and refresh token is expired', () {
      final accessTokenExpiration =
          DateTime.now().subtract(const Duration(hours: 1));

      expect(
          validateAccessToken(
              accessToken: 'my-access-token',
              accessTokenExpiration: accessTokenExpiration.toString(),
              refreshToken: 'my-refresh-token',
              refreshExpiresIn: '0'),
          equals(AccessTokenState.expired));
    });

    test('no values provided is unauthenticated', () {
      expect(
          validateAccessToken(
              accessToken: null,
              accessTokenExpiration: null,
              refreshToken: null,
              refreshExpiresIn: null),
          equals(AccessTokenState.unauthenticated));
    });
  });
}
