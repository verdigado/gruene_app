import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/app/constants/config.dart';
import 'package:gruene_app/app/constants/routes.dart';
import 'package:gruene_app/app/util/build_page_without_animation.dart';
import 'package:gruene_app/app/widgets/main_layout.dart';
import 'package:gruene_app/features/auth/bloc/auth_bloc.dart';
import 'package:gruene_app/features/auth/screens/login_screen.dart';
import 'package:gruene_app/features/campaigns/screens/campaigns_screen.dart';
import 'package:gruene_app/features/mfa/screens/mfa_screen.dart';
import 'package:gruene_app/features/news/screens/news_screen.dart';
import 'package:gruene_app/features/profiles/screens/profiles_screen.dart';
import 'package:gruene_app/features/tools/screens/tools_screen.dart';

GoRoute buildRoute(String path, Widget child, {bool withMainLayout = true}) {
  return GoRoute(
    path: path,
    pageBuilder: (BuildContext context, GoRouterState state) => buildPageWithoutAnimation<void>(
      context: context,
      state: state,
      child: withMainLayout ? MainLayout(child: child) : child,
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
      buildRoute(Routes.login, LoginScreen(), withMainLayout: false),
    ],
    redirect: (context, state) {
      final authBloc = context.read<AuthBloc>();
      final isLoggedIn = !Config.useLogin || authBloc.state is Authenticated;
      final isLoggingIn = state.uri.toString() == Routes.login;

      if (!isLoggedIn && !isLoggingIn) return Routes.login;
      if (isLoggedIn && isLoggingIn) return Routes.news;

      return null;
    },
  );
}
