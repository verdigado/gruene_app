import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/src/state.dart';
import 'package:gruene_app/routing/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Execute on Launch and return the Route first Route to Navigate
Future<String?> onAppStartup(BuildContext context, GoRouterState state) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('firstLaunched', true);
  final bool? isFirstLaunched = prefs.getBool('firstLaunched');
  if ((isFirstLaunched == null || isFirstLaunched)) {
    prefs.setBool('firstLaunched', true);
    return null;
  }
  var isLogin = prefs.getBool('login');
  if (!doLoginAutoLogin(isLogin)) {
    return null;
  }
  return null;
}

bool doLoginAutoLogin(isLogin) {
  // if  login try with refreshToken if valid else do new flow
  return false;
}