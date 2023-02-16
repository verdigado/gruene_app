import 'package:flutter/material.dart';
import 'package:gruene_app/constants/theme_data.dart';
import 'package:gruene_app/routing/router.dart';

void runMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Grüne App',
      routerConfig: router,
      theme: rootTheme,
    );
  }
}
