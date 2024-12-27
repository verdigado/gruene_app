import 'package:flutter/material.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/features/campaigns/helper/campaign_constants.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_detail_model.dart';

class PosterDetail extends StatelessWidget {
  final PosterDetailModel poi;

  const PosterDetail({super.key, required this.poi});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final addressTextStyle = theme.textTheme.labelSmall?.apply(color: ThemeColors.secondary, fontWeightDelta: 3);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  poi.address.street,
                  style: addressTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                poi.address.houseNumber,
                style: addressTextStyle,
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: Future.delayed(Duration.zero, () => poi.thumbnailUrl),
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
      ],
    );
  }
}
