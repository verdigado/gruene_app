import 'package:flutter/material.dart';
import 'package:gruene_app/features/campaigns/helper/campaign_constants.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_detail_model.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class PosterDetail extends StatefulWidget {
  final PosterDetailModel poi;

  const PosterDetail({super.key, required this.poi});

  @override
  State<StatefulWidget> createState() => PosterDetailState();
}

class PosterDetailState extends State<PosterDetail> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
            future: Future.delayed(Duration.zero, () => widget.poi.thumbnailUrl),
            builder: (context, snapshot) {
              if (!snapshot.hasData && !snapshot.hasError) {
                return Image.asset(CampaignConstants.dummyImageAssetName);
              }

              return FadeInImage.assetNetwork(
                placeholder: CampaignConstants.dummyImageAssetName,
                image: snapshot.data!,
              );
            },
          ),
        ),
        Text(
          t.campaigns.info_details,
          style: theme.textTheme.labelSmall?.apply(color: Colors.black, fontWeightDelta: 2),
        ),
      ],
    );
  }
}
