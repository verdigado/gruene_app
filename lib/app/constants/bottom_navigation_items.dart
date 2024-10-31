import 'package:gruene_app/app/constants/routes.dart';

class BottomNavigationItem {
  final String iconPath;
  final String Function(BuildContext) getTitle;
  final String route;

  BottomNavigationItem({
    required this.iconPath,
    required this.labelKey,
    required this.route,
  });
}

final List<BottomNavigationItem> bottomNavigationItems = [
  BottomNavigationItem(iconPath: 'assets/bottom_navigation/news.svg', labelKey: 'news', route: Routes.news),
  BottomNavigationItem(
    iconPath: 'assets/bottom_navigation/campaigns.svg',
    labelKey: 'campaigns',
    route: Routes.campaigns,
  ),
  BottomNavigationItem(iconPath: 'assets/bottom_navigation/profiles.svg', labelKey: 'profiles', route: Routes.profiles),
  BottomNavigationItem(iconPath: 'assets/bottom_navigation/mfa.svg', labelKey: 'mfa', route: Routes.mfa),
  BottomNavigationItem(iconPath: 'assets/bottom_navigation/apps.svg', labelKey: 'apps', route: Routes.apps),
];
