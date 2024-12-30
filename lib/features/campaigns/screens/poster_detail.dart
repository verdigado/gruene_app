import 'package:flutter/material.dart';
import 'package:gruene_app/features/campaigns/helper/campaign_constants.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_detail_model.dart';
import 'package:gruene_app/features/campaigns/widgets/address_field_detail.dart';

class PosterDetail extends StatelessWidget {
  final PosterDetailModel poi;

  const PosterDetail({super.key, required this.poi});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AddressFieldDetail(
          street: poi.address.street,
          houseNumber: poi.address.houseNumber,
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
