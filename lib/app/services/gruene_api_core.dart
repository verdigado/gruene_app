part of 'gruene_api_campaigns_service.dart';

class _GrueneApiCore {
  late GrueneApi _grueneApiService;

  _GrueneApiCore() {
    _grueneApiService = GrueneApi.create(
      baseUrl: Uri.parse(Config.gruenesNetzApiUrl),
      interceptors: [
        HeadersInterceptor(
          {
            'x-api-key': Config.gruenesNetzApiKey,
          },
        ),
      ],
    );
  }

  GrueneApi getService() {
    return _grueneApiService;
  }
}
