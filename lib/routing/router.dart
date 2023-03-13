import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/main.dart';
import 'package:gruene_app/net/profile/bloc/profile_bloc.dart';
import 'package:gruene_app/net/profile/repository/profile_repository.dart';

import 'package:gruene_app/routing/routes.dart';
import 'package:gruene_app/screens/intro/intro_screen.dart';
import 'package:gruene_app/screens/login/login_screen.dart';
import 'package:gruene_app/screens/more/more_screen.dart';
import 'package:gruene_app/screens/more/screens/profile/profile_detail_screen.dart';
import 'package:gruene_app/screens/more/screens/profile/profile_menu.dart';
import 'package:gruene_app/screens/news/news_screen.dart';
import 'package:gruene_app/screens/notification/notification_screen.dart';
import 'package:gruene_app/screens/onboarding/onboarding_screen.dart';
import 'package:gruene_app/screens/search/search_screen.dart';
import 'package:gruene_app/screens/start/start_screen.dart';
import 'package:gruene_app/widget/scaffold_with_navbar.dart';

import 'app_startup.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();
// Global Blocs

bool isSplashRemoved = false;

final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  debugLogDiagnostics: kDebugMode ? true : false,
  initialLocation: startScreen,
  routes: <RouteBase>[
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      pageBuilder: (context, state, child) {
        return CustomNoTransitionPage(
            child: ScaffoldWithNavbar(
          titel: getTitel(state.location),
          child: child,
        ));
      },
      routes: [
        // This screen is displayed on the ShellRoute's Navigator.
        GoRoute(
          path: startScreen,
          pageBuilder: (context, state) {
            return const CustomNoTransitionPage(child: StartScreen());
          },
        ),
        GoRoute(
          path: moreScreen,
          pageBuilder: (context, state) {
            return const CustomNoTransitionPage(child: MoreScreen());
          },
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: newsScreen,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: const NewsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              slideAnimation(animation, child),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: intro,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: const IntroScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity:
                  CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: login,
      pageBuilder: (context, state) {
        return const CustomNoTransitionPage(child: LoginScreen());
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: onboarding,
      pageBuilder: (context, state) {
        return const CustomNoTransitionPage(child: OnboardingScreen());
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: notification,
      pageBuilder: (context, state) {
        return const NoTransitionPage(child: NotfificationScreen());
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: profile,
      pageBuilder: (context, state) {
        return NoTransitionPage(
            child: BlocProvider.value(
          value: context.read<ProfileBloc>(),
          child: const ProfileMenu(),
        ));
      },
      routes: [
        GoRoute(
            path: profileDetail,
            parentNavigatorKey: rootNavigatorKey,
            name: profileDetailScreenName,
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: ProfileDetailScreen(),
              );
            })
      ],
    ),
  ],
  redirect: (context, state) async {
    String? firstRoute;
    firstRoute = await onAppStartup(context, state);

    if (!isSplashRemoved) {
      FlutterNativeSplash.remove();
      isSplashRemoved = true;
    }
    return firstRoute;
  },
);

SlideTransition slideAnimation(Animation<double> animation, Widget child) {
  const begin = Offset(1.0, 0.0);
  const end = Offset.zero;
  const curve = Curves.easeIn;
  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

  return SlideTransition(
    position: animation.drive(tween),
    child: child,
  );
}

class CustomNoTransitionPage<T> extends CustomTransitionPage<T> {
  /// Constructor for a page with no transition functionality.
  const CustomNoTransitionPage({
    required super.child,
    super.name,
    super.arguments,
    super.restorationId,
    super.key,
  }) : super(
            transitionsBuilder: _transitionsBuilder,
            transitionDuration: const Duration(microseconds: 0),
            reverseTransitionDuration: const Duration(microseconds: 0));

  static Widget _transitionsBuilder(
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child) =>
      child;
}
