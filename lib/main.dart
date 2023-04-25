import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gruene_app/constants/theme_data.dart';
import 'package:gruene_app/net/error_observer.dart';
import 'package:gruene_app/net/profile/bloc/profile_bloc.dart';
import 'package:gruene_app/net/profile/repository/profile_repository.dart';
import 'package:gruene_app/routing/router.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:no_screenshot/no_screenshot.dart';

import 'routing/routes.dart';

void runMain() async {
  var widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Bloc.observer = ErrorObserver();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _noScreenshot = NoScreenshot.instance;
  // This widget is the root of your application.
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => ProfileRepositoryImpl()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                ProfileBloc(context.read<ProfileRepositoryImpl>())
                  // TODO: Invoke after Login
                  ..add(const GetProfile()),
          ),
        ],
        child: MaterialApp.router(
          title: 'Grüne App',
          routerConfig: router,
          scaffoldMessengerKey: MyApp.scaffoldMessengerKey,
          theme: rootTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _noScreenshot.screenshotOn();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (router.location.contains(memberCard)) {
      print(router.location);
      if (state == AppLifecycleState.resumed ||
          state == AppLifecycleState.inactive ||
          state == AppLifecycleState.paused) {
        _noScreenshot.screenshotOff();
      } else {
        _noScreenshot.screenshotOn();
      }
    } else {
      _noScreenshot.screenshotOn();
    }
    super.didChangeAppLifecycleState(state);
  }
}
