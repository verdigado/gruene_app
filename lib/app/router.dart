import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/app/constants/routes.dart';
import 'package:gruene_app/app/utils/build_page_without_animation.dart';
import 'package:gruene_app/app/widgets/main_layout.dart';
import 'package:gruene_app/features/campaigns/screens/campaigns_screen.dart';
import 'package:gruene_app/features/mfa/screens/mfa_screen.dart';
import 'package:gruene_app/features/news/screens/news_screen.dart';
import 'package:gruene_app/features/profiles/screens/profiles_screen.dart';
import 'package:gruene_app/features/settings/screens/settings_screen.dart';
import 'package:gruene_app/features/tools/screens/tools_screen.dart';
import 'package:gruene_app/i18n/translations.g.dart';

GoRoute buildRoute(String path, String name, Widget child) {
  return GoRoute(
    name: name,
    path: path,
    pageBuilder: (BuildContext context, GoRouterState state) => buildPageWithoutAnimation<void>(
      context: context,
      state: state,
      child: MainLayout(child: child),
    ),
  );
}

GoRouter createAppRouter(BuildContext context) {
  return GoRouter(
    initialLocation: Routes.news,
    routes: [
      buildRoute(Routes.news, t.news.news, NewsScreen()),
      buildRoute(Routes.campaigns, t.campaigns.campaigns, CampaignsScreen()),
      buildRoute(Routes.profiles, t.profiles.profiles, ProfilesScreen()),
      buildRoute(Routes.mfa, t.mfa.mfa, MfaScreen()),
      buildRoute(Routes.tools, t.tools.tools, ToolsScreen()),
      buildRoute(Routes.settings, t.settings.settings, SettingsScreen()),
    ],
  );
}
