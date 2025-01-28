import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gruene_app/features/campaigns/models/statistics/campaign_statistics.dart';
import 'package:gruene_app/features/campaigns/models/statistics/campaign_statistics_set.dart';
import 'package:gruene_app/swagger_generated_code/gruene_api.swagger.dart';

class GrueneApiCampaignsStatisticsService {
  late GrueneApi grueneApi;

  GrueneApiCampaignsStatisticsService() {
    grueneApi = GetIt.I<GrueneApi>();
  }

  Future<CampaignStatistics> getStatistics() async {
    try {
      var statResult = await grueneApi.v1CampaignsStatisticsGet();
      return statResult.body!.asCampaignStatistics();
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      rethrow;
    }
  }
}

extension StatisticsParser on Statistics {
  CampaignStatistics asCampaignStatistics() {
    return CampaignStatistics(
      flyerStats: flyer.asStatisticsSet(),
      houseStats: house.asStatisticsSet(),
      posterStats: poster.asStatisticsSet(),
    );
  }
}

extension PoiStatisticsParser on PoiStatistics {
  CampaignStatisticsSet asStatisticsSet() {
    return CampaignStatisticsSet(
      own: own,
      division: division,
      state: state,
      germany: germany,
    );
  }
}
