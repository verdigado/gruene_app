import 'package:chopper/chopper.dart';
import 'package:gruene_app/app/constants/config.dart';
import 'package:gruene_app/features/campaigns/models/marker_item_model.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_create_model.dart';
import 'package:gruene_app/swagger_generated_code/gruene_api.swagger.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:maplibre_gl_platform_interface/maplibre_gl_platform_interface.dart';

part 'gruene_api_core.dart';

class GrueneApiCampaignsService {
  late GrueneApi grueneApi;

  final PoiServiceType poiType;

  GrueneApiCampaignsService({required this.poiType}) {
    grueneApi = _GrueneApiCore().getService();
  }

  Future<List<MarkerItemModel>> loadPoisInRegion(LatLng locationSW, LatLng locationNE) async {
    final getPoisType = _getPoiGetType();
    final getPoisResult = await grueneApi.v1CampaignsPoisGet(
      type: getPoisType,
      bbox: [locationSW.latitude, locationSW.longitude, locationNE.latitude, locationNE.longitude].join(','),
    );
    return getPoisResult.body!.data.map(_transformToMarkerItem).toList();
  }

  V1CampaignsPoisGetType _getPoiGetType() {
    switch (poiType) {
      case PoiServiceType.poster:
        return V1CampaignsPoisGetType.poster;
      case PoiServiceType.door:
        return V1CampaignsPoisGetType.house;
      case PoiServiceType.flyer:
        return V1CampaignsPoisGetType.flyerSpot;
    }
  }

  CreatePoiType _getPoiCreateType() {
    switch (poiType) {
      case PoiServiceType.poster:
        return CreatePoiType.poster;
      case PoiServiceType.door:
        return CreatePoiType.house;
      case PoiServiceType.flyer:
        return CreatePoiType.flyerSpot;
    }
  }

  MarkerItemModel _transformToMarkerItem(Poi poi) {
    final String statusSuffix = _getPosterStatusSuffix(poi.poster!.status);
    return MarkerItemModel(
      id: int.parse(poi.id),
      location: LatLng(poi.coords[0], poi.coords[1]),
      status: '${poiType.name}$statusSuffix',
    );
  }

  Future<MarkerItemModel> createNewPoster(PosterCreateModel newPoster) async {
    final requestParam = CreatePoi(
      coords: [newPoster.location.latitude, newPoster.location.longitude],
      type: _getPoiCreateType(),
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

    return _transformToMarkerItem(newPoiResponse.body!);
  }

  String _getPosterStatusSuffix(PoiPosterStatus status) {
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
}

enum PoiServiceType { poster, door, flyer }
