import 'package:flutter/material.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      color: Colors.red,
      child: Center(
        child: Text(
          t.campaigns.statistic.label,
          style: TextStyle(fontSize: 20, color: ThemeColors.primary),
        ),
      ),
    );
  }
}
