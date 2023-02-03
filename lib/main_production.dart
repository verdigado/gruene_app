import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gruene_app/main.dart';

import 'constants/app_const.dart';
import 'constants/flavors.dart';

void main() async {
  await dotenv.load(fileName: ".env.production");
  AppConst.forEnv(Flavors.production);
  runMain();
}
