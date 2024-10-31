import 'package:flutter/material.dart';
import 'package:gruene_app/app/constants/routes.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class BottomNavigationItem {
  final String iconPath;
  final String Function(BuildContext) getTitle;
  final String route;

  BottomNavigationItem({
    required this.iconPath,
    required this.getTitle,
    required this.route,
  });
}

final List<BottomNavigationItem> bottomNavigationItems = [
  BottomNavigationItem(
    iconPath: 'assets/bottom_navigation/news.svg',
    getTitle: (BuildContext context) => t.bottomNavigation.news,
    route: Routes.news,
  ),
  BottomNavigationItem(
    iconPath: 'assets/bottom_navigation/campaigns.svg',
    getTitle: (BuildContext context) => t.bottomNavigation.campaigns,
    route: Routes.campaigns,
  ),
  BottomNavigationItem(
    iconPath: 'assets/bottom_navigation/profiles.svg',
    getTitle: (BuildContext context) => t.bottomNavigation.profiles,
    route: Routes.profiles,
  ),
  BottomNavigationItem(
    iconPath: 'assets/bottom_navigation/mfa.svg',
    getTitle: (BuildContext context) => t.bottomNavigation.mfa,
    route: Routes.mfa,
  ),
  BottomNavigationItem(
    iconPath: 'assets/bottom_navigation/apps.svg',
    getTitle: (BuildContext context) => t.bottomNavigation.apps,
    route: Routes.apps,
  ),
];
