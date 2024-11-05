import 'package:flutter/material.dart';
import 'package:gruene_app/app/constants/routes.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class BottomNavigationItem {
  final String iconPath;
  final String Function(BuildContext) getLabel;
  final String route;

  BottomNavigationItem({
    required this.iconPath,
    required this.getLabel,
    required this.route,
  });
}

final List<BottomNavigationItem> bottomNavigationItems = [
  BottomNavigationItem(
    iconPath: 'assets/bottom_navigation/news.svg',
    getLabel: (BuildContext context) => t.news.label,
    route: Routes.news,
  ),
  BottomNavigationItem(
    iconPath: 'assets/bottom_navigation/campaigns.svg',
    getLabel: (BuildContext context) => t.campaigns.label,
    route: Routes.campaigns,
  ),
  BottomNavigationItem(
    iconPath: 'assets/bottom_navigation/profiles.svg',
    getLabel: (BuildContext context) => t.profiles.label,
    route: Routes.profiles,
  ),
  BottomNavigationItem(
    iconPath: 'assets/bottom_navigation/mfa.svg',
    getLabel: (BuildContext context) => t.mfa.label,
    route: Routes.mfa,
  ),
  BottomNavigationItem(
    iconPath: 'assets/bottom_navigation/tools.svg',
    getLabel: (BuildContext context) => t.tools.label,
    route: Routes.tools,
  ),
];
