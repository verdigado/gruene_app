import 'package:gruene_app/app/services/nominatim_service.dart';
import 'package:gruene_app/features/campaigns/models/statistics/campaign_statistics.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class CampaignSessionSettings {
  LatLng? lastPosition;
  double? lastZoomLevel;

  CampaignStatistics? recentStatistics;
  DateTime? recentStatisticsFetchTimestamp;

  bool imageConsentConfirmed = false;

  String? searchString;
  List<SearchResultItem>? searchResult = [];
}
