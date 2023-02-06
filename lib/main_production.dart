import 'package:gruene_app/main.dart';

import 'common/utils/env_var.dart';
import 'constants/flavors.dart';

void main() async {
  await loadEnvVars(flavor: Flavors.production);
  runMain();
}
