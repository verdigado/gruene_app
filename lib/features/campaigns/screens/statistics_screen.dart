import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/i18n/translations.g.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        color: theme.colorScheme.surfaceDim,
        child: Column(
          children: [
            _getBadgeBox(context, theme),
            SizedBox(height: 12),
            _getCategoryBox(
              theme: theme,
              title: t.campaigns.statistic.recorded_doors,
            ),
            SizedBox(height: 12),
            _getCategoryBox(
              theme: theme,
              title: t.campaigns.statistic.recorded_posters,
              subTitle: t.campaigns.statistic.including_damaged_or_taken_down,
            ),
            SizedBox(height: 12),
            _getCategoryBox(
              theme: theme,
              title: t.campaigns.statistic.recorded_flyer,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Stand: ${DateTime.now().toString()} (${t.campaigns.statistic.update_info})',
                style: theme.textTheme.labelMedium!.apply(color: ThemeColors.textDisabled),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getBadgeBox(BuildContext context, ThemeData theme) {
    var mediaQuery = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.all(16),
      width: mediaQuery.size.width,
      decoration: BoxDecoration(
        color: ThemeColors.primary,
        borderRadius: BorderRadius.circular(19),
        boxShadow: [
          BoxShadow(color: ThemeColors.textDark.withAlpha(10), offset: Offset(2, 4)),
        ],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              t.campaigns.statistic.my_badges,
              style: theme.textTheme.titleMedium!.copyWith(color: theme.colorScheme.surface),
            ),
          ),
          ..._getBadges(),
        ],
      ),
    );
  }

  List<Widget> _getBadges() {
    return <Widget>[];
  }

  Widget _getCategoryBox({required String title, String? subTitle, required ThemeData theme}) {
    var categoryDecoration = BoxDecoration(
      color: ThemeColors.background,
      borderRadius: BorderRadius.circular(19),
      boxShadow: [
        BoxShadow(color: ThemeColors.textDark.withAlpha(10), offset: Offset(2, 4)),
      ],
    );
    var rng = Random();
    return Container(
      padding: EdgeInsets.all(16),
      decoration: categoryDecoration,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
          subTitle != null
              ? Row(
                  children: [
                    Text(
                      subTitle,
                      style: theme.textTheme.labelSmall!.copyWith(color: ThemeColors.textDisabled),
                    ),
                  ],
                )
              : SizedBox(),
          _getDataRow(t.campaigns.statistic.by_me, rng.nextInt(200), theme),
          _getDataRow(t.campaigns.statistic.by_my_KV, rng.nextInt(2000), theme),
          _getDataRow(t.campaigns.statistic.by_my_LV, rng.nextInt(20000), theme),
          _getDataRow(t.campaigns.statistic.in_germany, rng.nextInt(20000), theme),
        ],
      ),
    );
  }

  Widget _getDataRow(String key, int value, ThemeData theme) {
    var formatter = NumberFormat('#,##,##0', t.$meta.locale.languageCode);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ThemeColors.textLight),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(key, style: theme.textTheme.labelLarge!.copyWith(color: ThemeColors.textDark)),
          Text(
            formatter.format(value),
            style: theme.textTheme.labelLarge!.copyWith(color: ThemeColors.textDark),
          ),
        ],
      ),
    );
  }
}
