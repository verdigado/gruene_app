import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gruene_app/app/router.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/features/login/bloc/auth_bloc.dart';
import 'package:gruene_app/features/login/repository/auth_repository.dart';
import 'package:gruene_app/i18n/translations.g.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  runApp(TranslationProvider(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();
    final router = createAppRouter(context);

    return BlocProvider(
      create: (context) => AuthBloc(authRepository)..add(CheckTokenRequested()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          router.refresh();
        },
        child: Builder(
          builder: (context) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              locale: TranslationProvider.of(context).flutterLocale,
              supportedLocales: AppLocaleUtils.supportedLocales,
              localizationsDelegates: GlobalMaterialLocalizations.delegates,
              routeInformationParser: router.routeInformationParser,
              routerDelegate: router.routerDelegate,
              routeInformationProvider: router.routeInformationProvider,
              theme: appTheme,
            );
          },
        ),
      ),
    );
  }
}
