import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/screens/search/search_screen.dart';
import 'package:gruene_app/widget/scaffold_with_navbar.dart';

import '../screens/start/start_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: routes['startScreen'] ?? '',
    routes: <RouteBase>[
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithNavbar(
            titel: 'Titel',
            child: child,
          );
        },
        routes: [
          // This screen is displayed on the ShellRoute's Navigator.
          GoRoute(
            path: routes['startScreen'] ?? '',
            builder: (context, state) {
              return const StartScreen();
            },
          ),
          GoRoute(
            path: routes['searchScreen'] ?? '',
            builder: (context, state) {
              return const SearchScreen();
            },
          ),
        ],
      )
    ]);

final routes = {'startScreen': '/', 'searchScreen': '/search'};
