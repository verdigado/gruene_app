import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:gruene_app/app/auth/bloc/auth_bloc.dart';
import 'package:gruene_app/app/auth/repository/auth_repository.dart';
import 'package:gruene_app/app/router.dart';
import 'package:gruene_app/app/services/gruene_api_core.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/features/campaigns/helper/campaign_session_settings.dart';
import 'package:gruene_app/features/mfa/bloc/mfa_bloc.dart';
import 'package:gruene_app/features/mfa/bloc/mfa_event.dart';
import 'package:gruene_app/features/mfa/domain/mfa_factory.dart';
import 'package:gruene_app/i18n/translations.g.dart';
import 'package:gruene_app/swagger_generated_code/gruene_api.swagger.dart';
import 'package:keycloak_authenticator/api.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final locale = await LocaleSettings.useDeviceLocale();

  if (locale.languageCode == 'de') {
    timeago.setLocaleMessages('de', timeago.DeMessages());
  } else {
    timeago.setLocaleMessages('en', timeago.EnMessages());
  }

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }

  GetIt.I.registerSingleton<GrueneApi>(await createGrueneApiClient());
  GetIt.I.registerSingleton<CampaignSessionSettings>(CampaignSessionSettings());
  GetIt.I.registerFactory<AuthenticatorService>(MfaFactory.create);

  runApp(TranslationProvider(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();
    final router = createAppRouter(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(authRepository)..add(CheckTokenRequested()),
        ),
        BlocProvider(
          create: (context) => MfaBloc()..add(InitMfa()),
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          router.refresh();
          if (state is! AuthLoading && state is! AuthInitial) {
            Future.delayed(Duration(seconds: 1), () {
              FlutterNativeSplash.remove();
            });
          }
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
