import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gruene_app/constants/app_const.dart';
import 'package:gruene_app/constants/flavors.dart';
import 'package:gruene_app/main.dart';

import 'common/logger.dart';

void main() async {
  await loadEnvVars();
  runMain();
}

Future<void> loadEnvVars() async {
  try {
    await dotenv.load(fileName: ".env.staging");
  } catch (e) {
    logger.i(
        'Failure loading the Env File. Make sure you have placed the correct Env File in the Root Directory');
  }

  AppConst.forEnv(Flavors.staging);
}
