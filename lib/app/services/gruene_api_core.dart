import 'dart:async';
import 'dart:io';

import 'package:chopper/chopper.dart' as chopper;
import 'package:flutter/foundation.dart';
import 'package:gruene_app/app/auth/repository/auth_repository.dart';
import 'package:gruene_app/app/constants/config.dart';
import 'package:gruene_app/swagger_generated_code/gruene_api.swagger.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<GrueneApi> createGrueneApiClient() async {
  final userAgentHeaderValue = await _getUserAgentString();
  List<chopper.Interceptor> interceptors = [UserAgentInterceptor(userAgentHeaderValue)];
  chopper.Authenticator? authenticator;

  if (Config.grueneApiAccessToken.isNotEmpty) {
    interceptors.add(AuthInterceptor.withFixedAccessToken(Config.grueneApiAccessToken));
  } else {
    AuthRepository repo = AuthRepository();
    authenticator = AccessTokenAuthenticator(repo);
    interceptors.add(AuthInterceptor.withAuthenticatorRepository(repo));
  }

  return GrueneApi.create(
    baseUrl: Uri.parse(Config.grueneApiUrl),
    authenticator: authenticator,
    interceptors: interceptors,
  );
}

Future<String> _getUserAgentString() async {
  var packageInfo = await PackageInfo.fromPlatform();

  return '${packageInfo.packageName} ${packageInfo.version}+${packageInfo.buildNumber} (${_getSystemDescription()}, ${packageInfo.installerStore})';
}

String _getSystemDescription() {
  if (Platform.isAndroid) {
    return 'Android';
  } else if (Platform.isIOS) {
    return 'iOS';
  } else {
    return 'unknown_OS';
  }
}

class UserAgentInterceptor implements chopper.Interceptor {
  final String userAgentHeaderValue;

  UserAgentInterceptor(this.userAgentHeaderValue);

  @override
  FutureOr<chopper.Response<BodyType>> intercept<BodyType>(chopper.Chain<BodyType> chain) async {
    final updatedRequest = chopper.applyHeader(
      chain.request,
      HttpHeaders.userAgentHeader,
      userAgentHeaderValue,
      override: true,
    );

    return chain.proceed(updatedRequest);
  }
}

class _AuthConstants {
  static const bearerPrefix = 'Bearer';
}

class AuthInterceptor implements chopper.Interceptor {
  const AuthInterceptor._(this._authRepo, this._accessToken);

  const AuthInterceptor.withFixedAccessToken(String accessToken) : this._(null, accessToken);
  const AuthInterceptor.withAuthenticatorRepository(AuthRepository authRepo) : this._(authRepo, null);

  final AuthRepository? _authRepo;

  final String? _accessToken;

  @override
  FutureOr<chopper.Response<BodyType>> intercept<BodyType>(chopper.Chain<BodyType> chain) async {
    var token = _accessToken ?? await _authRepo?.getAccessToken();
    final updatedRequest = chopper.applyHeader(
      chain.request,
      HttpHeaders.authorizationHeader,
      '${_AuthConstants.bearerPrefix} ${token!}',
      // Do not override existing header
      override: false,
    );

    debugPrint('[AuthInterceptor] accessToken: ${updatedRequest.headers[HttpHeaders.authorizationHeader]}');

    return chain.proceed(updatedRequest);
  }
}

//
// Authenticator
//
class AccessTokenAuthenticator implements chopper.Authenticator {
  AccessTokenAuthenticator(this._repo);

  final AuthRepository _repo;

  @override
  FutureOr<chopper.Request?> authenticate(
    chopper.Request request,
    chopper.Response<dynamic> response, [
    chopper.Request? originalRequest,
  ]) async {
    debugPrint('[MyAuthenticator] response.statusCode: ${response.statusCode}');
    debugPrint('[MyAuthenticator] request Retry-Count: ${request.headers['Retry-Count'] ?? 0}');
    debugPrint('OriginalRequest ${originalRequest.toString()}');
    // 401
    if (response.statusCode == HttpStatus.unauthorized) {
      // Trying to update token only 1 time
      if (request.headers['Retry-Count'] != null) {
        debugPrint(
          '[MyAuthenticator] Unable to refresh token, retry count exceeded',
        );
        return null;
      }

      try {
        final newToken = await _refreshToken();

        var updatedRequest = chopper.applyHeaders(
          request,
          {
            HttpHeaders.authorizationHeader: '${_AuthConstants.bearerPrefix} ${newToken!}',
            // Setting the retry count to not end up in an infinite loop of unsuccessful updates
            'Retry-Count': '1',
          },
        );

        debugPrint(
          '[MyAuthenticator] accessToken: ${updatedRequest.headers[HttpHeaders.authorizationHeader]}',
        );

        return updatedRequest;
      } catch (e) {
        debugPrint('[MyAuthenticator] Unable to refresh token: $e');
        return null;
      }
    }

    return null;
  }

  // Completer to prevent multiple token refreshes at the same time
  Completer<String?>? _completer;

  Future<String?> _refreshToken() {
    var completer = _completer;
    if (completer != null && !completer.isCompleted) {
      debugPrint('[MyAuthenticator] Token refresh is already in progress');
      return completer.future;
    }

    completer = Completer<String?>();
    _completer = completer;

    _repo.refreshToken().then((success) {
      debugPrint('[MyAuthenticator] RefreshStatus: $success');

      if (success) {
        // Completing with a new token
        completer?.complete(_repo.getAccessToken());
      } else {
        completer?.completeError('Refresh token error', StackTrace.current);
      }
    }).onError((error, stackTrace) {
      // Completing with an error
      completer?.completeError(error ?? 'Refresh token error', stackTrace);
    });

    return completer.future;
  }

  @override
  chopper.AuthenticationCallback? get onAuthenticationFailed => null;

  @override
  chopper.AuthenticationCallback? get onAuthenticationSuccessful => null;
}
