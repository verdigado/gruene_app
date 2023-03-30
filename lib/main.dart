import 'package:dio/dio.dart';
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

void runMain() async {
  var widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Bloc.observer = ErrorObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  static final dio = Dio();

  // This widget is the root of your application.
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
          scaffoldMessengerKey: scaffoldMessengerKey,
          theme: rootTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }
}
