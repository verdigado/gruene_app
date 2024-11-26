import 'package:flutter/widgets.dart';
import 'package:gruene_app/features/campaigns/widgets/filter_chip_widget.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class PostersScreen extends StatelessWidget {
  PostersScreen({super.key});

  final List<FilterChipModel> postersFilter = [
    FilterChipModel(t.campaigns.filters.routes, false),
    FilterChipModel(t.campaigns.filters.polling_stations, false),
    FilterChipModel(t.campaigns.filters.experience_areas, false),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilterChipCampaign(postersFilter, <String, List<String>>{}),
        Center(child: Text(t.campaigns.posters.label)),
      ],
    );
  }
}
