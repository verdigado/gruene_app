import 'dart:async';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:gruene_app/app/auth/repository/auth_repository.dart';
import 'package:gruene_app/app/constants/config.dart';
import 'package:gruene_app/app/services/access_token_authenticator.dart';
import 'package:gruene_app/app/utils/user_agent.dart';
import 'package:gruene_app/swagger_generated_code/gruene_api.swagger.dart';

const bearerPrefix = 'Bearer';

Future<GrueneApi> createGrueneApiClient() async {
  List<Interceptor> interceptors = [UserAgentInterceptor(), AuthInterceptor(Config.grueneApiAccessToken)];

  return GrueneApi.create(
    baseUrl: Uri.parse(Config.grueneApiUrl),
    authenticator: Config.grueneApiAccessToken == null ? AccessTokenAuthenticator() : null,
    interceptors: interceptors,
  );
}

class AuthInterceptor implements Interceptor {
  final AuthRepository _authRepository = AuthRepository();
  final String? _accessToken;

  AuthInterceptor(this._accessToken);

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) async {
    final accessToken = _accessToken ?? await _authRepository.getAccessToken();
    final updatedRequest = applyHeader(
      chain.request,
      HttpHeaders.authorizationHeader,
      '$bearerPrefix ${accessToken!}',
      override: false,
    );

    return chain.proceed(updatedRequest);
  }
}
