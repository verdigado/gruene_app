import 'package:gruene_app/features/campaigns/models/statistics/campaign_statistics_set.dart';

class CampaignStatistics {
  final CampaignStatisticsSet flyerStats, houseStats, posterStats;

  const CampaignStatistics({
    required this.flyerStats,
    required this.houseStats,
    required this.posterStats,
  });
}
