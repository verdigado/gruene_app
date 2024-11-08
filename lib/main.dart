import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gruene_app/app/router.dart';
import 'package:gruene_app/app/theme.dart';
import 'package:gruene_app/features/auth/bloc/auth_bloc.dart';
import 'package:gruene_app/features/auth/bloc/auth_stream.dart';
import 'package:gruene_app/features/auth/repository/auth_repository.dart';
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

    return BlocProvider(
      create: (context) => AuthBloc(authRepository)..add(CheckTokenRequested()),
      child: Builder(
        builder: (context) {
          final authBloc = context.read<AuthBloc>();
          final authStream = AuthStream(authBloc);
          final router = createAppRouter(authStream);
          return MaterialApp.router(
            locale: TranslationProvider.of(context).flutterLocale,
            supportedLocales: AppLocaleUtils.supportedLocales,
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            routerConfig: router,
            theme: appTheme,
          );
        },
      ),
    );
  }
}
