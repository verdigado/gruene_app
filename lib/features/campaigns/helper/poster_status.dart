import 'package:gruene_app/features/campaigns/models/posters/poster_detail_model.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class PosterStatusHelper {
  static List<(PosterStatus, String, String)> getPosterStatusOptions = <(PosterStatus, String, String)>[
    (
      PosterStatus.damaged,
      t.campaigns.posters.status.damaged.label,
      t.campaigns.posters.status.damaged.hint,
    ),
    (
      PosterStatus.missing,
      t.campaigns.posters.status.missing.label,
      t.campaigns.posters.status.missing.hint,
    ),
    (
      PosterStatus.removed,
      t.campaigns.posters.status.removed.label,
      t.campaigns.posters.status.removed.hint,
    ),
  ];
}
