import 'package:go_router/go_router.dart';
import 'package:gruene_app/common/logger.dart';
import 'package:gruene_app/net/authentication/authentication.dart';
import 'package:gruene_app/routing/routes.dart';
import 'package:gruene_app/screens/intro/intro_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

const String firstLaunchPreferencesKey = 'first_launch_app';

/// Execute on Launch and return the Route first Route to Navigate
Future<String?> onAppStartup(BuildContext context, GoRouterState state) async {
  final prefs = await SharedPreferences.getInstance();
  final isFirstTime = prefs.getBool(firstLaunchPreferencesKey) ?? true;
  if (isFirstTime) {
    // show an onboarding screen
    return intro;
  } else {
    // The app has been launched before
    // Check Auth State
    var authenticated = false;
    try {
      authenticated = await checkCurrentAuthState();
    } on Exception catch (e, st) {
      logger.d('Failure on check AuthStae clear Storage', [e, st]);
      SecureStoreKeys.values.map((e) => authStorage.delete(key: e.name));
    }
    if (authenticated) {
      return startScreen;
    } else {
      return login;
    }
  }
}
