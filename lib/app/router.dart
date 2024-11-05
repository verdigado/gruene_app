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

GoRoute buildRoute(String path, Widget child) {
  return GoRoute(
    path: path,
    pageBuilder: (BuildContext context, GoRouterState state) => buildPageWithoutAnimation<void>(
      context: context,
      state: state,
      child: MainLayout(child: child),
    ),
  );
}

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: Routes.news,
    routes: [
      buildRoute(Routes.news, NewsScreen()),
      buildRoute(Routes.campaigns, CampaignsScreen()),
      buildRoute(Routes.profiles, ProfilesScreen()),
      buildRoute(Routes.mfa, MfaScreen()),
      buildRoute(Routes.tools, ToolsScreen()),
      buildRoute(Routes.settings, SettingsScreen()),
    ],
  );
}
