import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/app/constants/routes.dart';
import 'package:gruene_app/app/util/build_page_without_animation.dart';
import 'package:gruene_app/app/widgets/main_layout.dart';
import 'package:gruene_app/features/apps/screens/apps_screen.dart';
import 'package:gruene_app/features/campaigns/screens/campaigns_screen.dart';
import 'package:gruene_app/features/mfa/screens/mfa_screen.dart';
import 'package:gruene_app/features/news/screens/news_screen.dart';
import 'package:gruene_app/features/profiles/screens/profiles_screen.dart';

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
      buildRoute(Routes.apps, AppsScreen()),
    ],
  );
}
