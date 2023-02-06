import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gruene_app/common/logger.dart';

import '../../constants/app_const.dart';
import '../../constants/flavors.dart';

Future<void> loadEnvVars({required Flavors flavor}) async {
  try {
    await dotenv.load(fileName: '.env.$flavor');
  } catch (e) {
    logger.i(
        'Failure loading the Env File .env.$flavor. Make sure you have placed the correct Env File in the Root Directory');
  }
  AppConst.forEnv(flavor);
}
