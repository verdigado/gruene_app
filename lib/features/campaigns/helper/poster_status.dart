import 'package:gruene_app/features/campaigns/models/posters/poster_detail_model.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class PosterStatusHelper {
  static List<(PosterStatus, String, String)> getPosterStatusOptions = <(PosterStatus, String, String)>[
    (
      PosterStatus.damaged,
      t.campaigns.poster.status.damaged.label,
      t.campaigns.poster.status.damaged.hint,
    ),
    (
      PosterStatus.missing,
      t.campaigns.poster.status.missing.label,
      t.campaigns.poster.status.missing.hint,
    ),
    (
      PosterStatus.removed,
      t.campaigns.poster.status.removed.label,
      t.campaigns.poster.status.removed.hint,
    ),
  ];
}
