import 'package:flutter/material.dart';
import 'package:gruene_app/constants/flavors.dart';
import 'package:gruene_app/main.dart';

import 'common/utils/env_var.dart';

void main() async {
  await loadEnvVars(flavor: Flavors.staging);
  runMain();
}
