import 'package:gruene_app/app/constants/routes.dart';

class BottomNavigationItem {
  final String iconPath;
  final String label;
  final String route;

  BottomNavigationItem({
    required this.iconPath,
    required this.label,
    required this.route,
  });
}

final List<BottomNavigationItem> bottomNavigationItems = [
  BottomNavigationItem(
      iconPath: 'assets/bottom_navigation/news.svg',
      label: 'News',
      route: Routes.news),
  BottomNavigationItem(
      iconPath: 'assets/bottom_navigation/campaigns.svg',
      label: 'Campaigns',
      route: Routes.campaigns),
  BottomNavigationItem(
      iconPath: 'assets/bottom_navigation/profiles.svg',
      label: 'Profiles',
      route: Routes.profiles),
  BottomNavigationItem(
      iconPath: 'assets/bottom_navigation/mfa.svg',
      label: 'MFA',
      route: Routes.mfa),
  BottomNavigationItem(
      iconPath: 'assets/bottom_navigation/apps.svg',
      label: 'Apps',
      route: Routes.apps),
];
