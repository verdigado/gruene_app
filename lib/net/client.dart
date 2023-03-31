import 'package:dio/dio.dart';
import 'package:gruene_api_client/gruene_api_client.dart';
import 'package:gruene_app/net/authentication/authentication.dart';
import 'package:gruene_app/routing/router.dart';
import 'package:gruene_app/routing/routes.dart';

final api = GrueneApiClient(interceptors: [BearerAuthInterceptor()]);

class BearerAuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    var token =
        await authStorage.read(key: SecureStoreKeys.accesToken.name) ?? '';

    options.headers['authorization'] = 'Bearer $token';
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      if (!await checkCurrentAuthState()) {
        router.go(login);
      }
    }
    super.onError(err, handler);
  }
}
