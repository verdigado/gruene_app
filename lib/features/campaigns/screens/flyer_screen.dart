import 'package:flutter/widgets.dart';
import 'package:gruene_app/features/campaigns/widgets/filter_chip_widget.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class FlyerScreen extends StatelessWidget {
  FlyerScreen({super.key});

  final List<FilterChipModel> flyerFilter = [
    FilterChipModel(t.campaigns.filters.visited_areas, false),
    FilterChipModel(t.campaigns.filters.routes, false),
    FilterChipModel(t.campaigns.filters.experience_areas, false),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilterChipCampaign(flyerFilter, <String, List<String>>{}),
        Center(child: Text(t.campaigns.flyer.label)),
      ],
    );
  }
}
