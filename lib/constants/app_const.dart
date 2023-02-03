import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gruene_app/constants/flavors.dart';

class AppConst {
  static final AppConst _instance = AppConst._internal();
  factory AppConst.forEnv(Flavors flavor) {
    assert(!_created, 'AppConstance init twice');
    _instance._flavors = flavor;
    _created = true;
    return _instance;
  }

  AppConst._internal();
  static AppConst get values => _instance;
  static bool _created = false;

  late Flavors _flavors;
  Flavors get falavor => _flavors;
}
