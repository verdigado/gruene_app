import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/app/auth/bloc/auth_bloc.dart';
import 'package:gruene_app/app/constants/config.dart';
import 'package:gruene_app/app/constants/routes.dart';

GoRouter createAppRouter(BuildContext context) {
  return GoRouter(
    initialLocation: Routes.news.path,
    routes: [
      Routes.news,
      Routes.campaigns,
      Routes.profiles,
      Routes.mfa,
      Routes.tools,
      Routes.settings,
      Routes.login,
    ],
    redirect: (context, state) {
      final authBloc = context.read<AuthBloc>();
      final isLoggedIn = !Config.useLogin || authBloc.state is Authenticated;
      final isLoggingIn = state.uri.toString() == Routes.login.path;
      final isMfa = state.uri.toString() == Routes.mfa.path;

      if (!isLoggedIn && !isLoggingIn && !isMfa) return Routes.login.path;
      if (isLoggedIn && isLoggingIn) return Routes.news.path;

      return null;
    },
  );
}
