import 'package:flutter/foundation.dart';
import 'package:gruene_app/constants/flavors.dart';
import 'package:gruene_app/net/client.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class GruneAppData {
  static final GruneAppData _instance = GruneAppData._internal();
  factory GruneAppData.forEnv(Flavors flavor) {
    assert(!_created, 'GruneAppDataance init twice');
    _instance._flavors = flavor;
    _created = true;
    _instance._api = MyGrueneApiClient.withRetry(interceptors: [
      BearerAuthInterceptor(),
      PrettyDioLogger(
        requestBody: kDebugMode,
        requestHeader: kDebugMode,
        request: kDebugMode,
        responseBody: kDebugMode,
        responseHeader: kDebugMode,
        error: kDebugMode,
      ),
    ]);
    return _instance;
  }

  GruneAppData._internal();
  static GruneAppData get values => _instance;
  static bool _created = false;
  late MyGrueneApiClient _api;

  late Flavors _flavors;
  Flavors get falavor => _flavors;
  MyGrueneApiClient get api => _api;
}
