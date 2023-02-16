import 'package:gruene_app/routing/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Execute on Launch and return the Route first Route to Navigate
Future<String?> onAppStartup() async {
  final prefs = await SharedPreferences.getInstance();
  final bool? isFirstLaunched = prefs.getBool('firstLaunched');
  if (isFirstLaunched == null || !isFirstLaunched) {
    return intro;
  }
  var isLogin = prefs.getBool('login');
  if (!doLoginAutoLogin(isLogin)) {
    return login;
  }
  return null;
}

bool doLoginAutoLogin(isLogin) {
  // if  login try with refreshToken if valid else do new flow
  return false;
}
