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
   BottomNavigationItem(iconPath: 'assets/bottom_navigation/news.svg', getTitle: (BuildContext context) => t.news.news, route: Routes.news),
  BottomNavigationItem(
    iconPath: 'assets/bottom_navigation/campaigns.svg',
    getTitle: (BuildContext context) => t.campaigns.campaigns,
    route: Routes.campaigns,
  ),
  BottomNavigationItem(iconPath: 'assets/bottom_navigation/profiles.svg', getTitle: (BuildContext context) => t.profiles.profiles, route: Routes.profiles),
  BottomNavigationItem(iconPath: 'assets/bottom_navigation/mfa.svg', getTitle: (BuildContext context) => t.mfa.mfa, route: Routes.mfa),
  BottomNavigationItem(iconPath: 'assets/bottom_navigation/apps.svg', getTitle: (BuildContext context) => t.apps.apps, route: Routes.apps),
];
