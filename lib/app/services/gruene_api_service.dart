import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:gruene_app/app/constants/config.dart';
import 'package:gruene_app/app/models/campaigns/marker_item_model.dart';
import 'package:gruene_app/app/models/campaigns/posters/poster_create_model.dart';
import 'package:gruene_app/swagger_generated_code/gruene_api.swagger.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:maplibre_gl_platform_interface/maplibre_gl_platform_interface.dart';

class GrueneApiService {
  late GrueneApi grueneApi;

  final PoiServiceType poiType;

  GrueneApiService({required this.poiType}) {
    grueneApi = GrueneApi.create(
      baseUrl: Uri.parse(Config.gruenesNetzApiUrl),
      // httpClient: http.IOClient(
      //   HttpClient()..connectionTimeout = const Duration(seconds: 60),
      // ),
      interceptors: [
        HeadersInterceptor(
          {
            'x-api-key': Config.gruenesNetzApiKey,
          },
        ),
      ],
    );
  }

  Future<HealthCheckResponse> getHealth() async {
    final healthResult = await grueneApi.healthGet();
    return HealthCheckResponse.fromJson(json.decode(healthResult.bodyString) as Map<String, dynamic>);
  }

  Future<List<MarkerItemModel>> loadPoisInRegion(LatLng locationSW, LatLng locationNE) async {
    final getPoisType = getPoiGetType();
    final getPoisResult = await grueneApi.v1CampaignsPoisGet(
      type: getPoisType,
      bbox: [locationSW.latitude, locationSW.longitude, locationNE.latitude, locationNE.longitude].join(','),
    );
    return getPoisResult.body!.data.map(transformToMarkerItem).toList();
  }

  V1CampaignsPoisGetType getPoiGetType() {
    switch (poiType) {
      case PoiServiceType.poster:
        return V1CampaignsPoisGetType.poster;
      case PoiServiceType.door:
        return V1CampaignsPoisGetType.house;
      case PoiServiceType.flyer:
        return V1CampaignsPoisGetType.flyerSpot;
    }
  }

  CreatePoiType getPoiCreateType() {
    switch (poiType) {
      case PoiServiceType.poster:
        return CreatePoiType.poster;
      case PoiServiceType.door:
        return CreatePoiType.house;
      case PoiServiceType.flyer:
        return CreatePoiType.flyerSpot;
    }
  }

  MarkerItemModel transformToMarkerItem(Poi poi) {
    final String statusSuffix = getPosterStatusSuffix(poi.poster!.status);
    return MarkerItemModel(
      id: int.parse(poi.id),
      location: LatLng(poi.coords[0], poi.coords[1]),
      status: '${poiType.name}$statusSuffix',
    );
  }

  Future<MarkerItemModel> createNewPoster(PosterCreateModel newPoster) async {
    final requestParam = CreatePoi(
      coords: [newPoster.location.latitude, newPoster.location.longitude],
      type: getPoiCreateType(),
      address: PoiAddress(
        city: newPoster.city!,
        zip: newPoster.zipCode!,
        street: newPoster.street!,
        houseNumber: newPoster.houseNumber!,
      ),
    );
    // saving POI
    final newPoiResponse = await grueneApi.v1CampaignsPoisPost(body: requestParam);

    if (newPoiResponse.error == null && newPoster.photo != null) {
      // saving Photo along with POI
      // uploadPhoto(newPoiResponse.body!.id, newPoster.photo!);
      // uploadPhotoWithDio(newPoiResponse.body!.id, newPoster.photo!);

      // final bytes = newPoster.photo!.readAsBytesSync();
      // await compressAction;
      // final filename = newPoster.photo!.path.split('/').last;

      var poiId = newPoiResponse.body!.id;
      var timeStamp = DateFormat('yyMMdd_HHmmss').format(DateTime.now());
      // ignore: unused_local_variable
      final savePoiPhotoResponse = await grueneApi.v1CampaignsPoisPoiIdPhotosPost(
        poiId: poiId,
        image: MultipartFile.fromBytes(
          'image',
          newPoster.photo!,
          filename: 'poi_${poiId}_$timeStamp.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    return transformToMarkerItem(newPoiResponse.body!);
  }

  String getPosterStatusSuffix(PoiPosterStatus status) {
    switch (status) {
      case PoiPosterStatus.damaged:
        return '_${status.name}';
      case PoiPosterStatus.removed:
      case PoiPosterStatus.missing:
        return '_taken_down';
      default:
        return '';
    }
  }

  // alternative Method for uploading multipart using Dio
  // void uploadPhotoWithDio(String poiId, Uint8List file) async {
  //   var uri = Uri.parse(
  //     '${Config.gruenesNetzApiUrl.rightStrip('/')}/${'/v1/campaigns/pois/${poiId}/photos'.leftStrip('/')}',
  //   );
  //   FormData formData = FormData.fromMap({
  //     'image': await MultipartFile.fromBytes(
  //       file,
  //       filename: 'image.jpg',
  //       contentType: MediaType('image', 'jpeg'),
  //     ),
  //   });
  //   Dio dio = Dio();
  //   dio.interceptors.add(
  //     InterceptorsWrapper(
  //       onRequest: (options, handler) => options.headers.putIfAbsent('x-api-key', () => Config.gruenesNetzApiKey),
  //     ),
  //   );

  //   var response = await dio.post(
  //     uri.toString(),
  //     data: formData,
  //   );
  //   print(response.statusCode);
  //   print(response.data.toString());
  // }

  // // alternative Method for uploading multipart using http lib
  // void uploadPhotoWithHttp(String poiId, Uint8List file) async {
  //   var uri = Uri.parse(
  //     '${Config.gruenesNetzApiUrl.rightStrip('/')}/${'/v1/campaigns/pois/${poiId}/photos'.leftStrip('/')}',
  //   );
  //   var request = MultipartRequest('POST', uri)
  //     ..headers['x-api-key'] = Config.gruenesNetzApiKey
  //     ..files.add(
  //       await MultipartFile.fromBytes(
  //         'image',
  //         file,
  //         contentType: MediaType('image', 'jpeg'),
  //       ),
  //     );
  //   var response = await request.send();

  //   if (response.statusCode == 200) print('Uploaded!');

  //   // print(await response.stream.bytesToString());
  // }
}

enum PoiServiceType { poster, door, flyer }
