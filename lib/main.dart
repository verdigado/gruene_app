import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gruene_app/constants/theme_data.dart';
import 'package:gruene_app/net/profile/bloc/profile_bloc.dart';
import 'package:gruene_app/net/profile/bloc/repository/profile_repository.dart';
import 'package:gruene_app/routing/router.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void runMain() async {
  var widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

final ProfileBloc profileBloc = ProfileBloc(ProfileRepositoryImpl());

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => ProfileRepositoryImpl()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) {
            var bloc = ProfileBloc(context.read<ProfileRepositoryImpl>());
            bloc.add(const GetProfile());
            return bloc;
          }),
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
  void dispose() {
    profileBloc.close();
    super.dispose();
  }
}
