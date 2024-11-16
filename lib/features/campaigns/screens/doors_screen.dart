import 'package:flutter/material.dart';
import 'package:gruene_app/features/campaigns/widgets/filter_chip_widget.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class DoorsScreen extends StatelessWidget {
  DoorsScreen({super.key});

  final List<FilterChipModel> doorsFilter = [
    FilterChipModel(t.campaigns.filters.visited_areas, false),
    FilterChipModel(t.campaigns.filters.routes, false),
    FilterChipModel(t.campaigns.filters.focusAreas, true),
    FilterChipModel(t.campaigns.filters.experience_areas, false),
  ];
  final Map<String, List<String>> doorsExclusions = <String, List<String>>{
    t.campaigns.filters.focusAreas: [t.campaigns.filters.visited_areas],
    t.campaigns.filters.visited_areas: [t.campaigns.filters.focusAreas],
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilterChipCampaign(doorsFilter, doorsExclusions),
        Center(child: Text(t.campaigns.door.label)),
      ],
    );
  }
}
