import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:gruene_api_client/gruene_api_client.dart';
import 'package:gruene_app/net/authentication/authentication.dart';
import 'package:gruene_app/routing/router.dart';
import 'package:gruene_app/routing/routes.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class MyGrueneApiClient extends GrueneApiClient {
  MyGrueneApiClient(
      {super.basePathOverride,
      super.dio,
      super.interceptors,
      super.serializers});

  factory MyGrueneApiClient.withRetry(
      {basePathOverride, dio, interceptors, serializers}) {
    final client = MyGrueneApiClient(
      basePathOverride: basePathOverride,
      dio: dio,
      interceptors: interceptors,
      serializers: serializers,
    );
    client.dio.interceptors.add(RetryInterceptor(
      dio: client.dio,
      logPrint: print, // specify log function (optional)
      retries: 3, // retry count (optional)
      retryableExtraStatuses: {401},
      retryDelays: const [
        // set delays between retries (optional)
        Duration(seconds: 1), // wait 1 sec before first retry
        Duration(seconds: 2), // wait 2 sec before second retry
        Duration(seconds: 3), // wait 3 sec before third retry
      ],
    ));
    return client;
  }
}

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
        super.onError(err, handler);
        router.go(login);
      }
    }
    super.onError(err, handler);
  }
}
