import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/constants/app_const.dart';
import 'package:gruene_app/constants/flavors.dart';
import 'package:gruene_app/constants/theme_data.dart';

import 'package:gruene_app/gen/assets.gen.dart';
import 'package:gruene_app/main.dart';
import 'package:gruene_app/net/authentication/authentication.dart';
import 'package:gruene_app/routing/app_startup.dart';
import 'package:gruene_app/routing/router.dart';

import 'package:gruene_app/routing/routes.dart';
import 'package:gruene_app/widget/privacy_imprint.dart';
import 'package:gruene_app/widget/slider_carousel.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_graphics/vector_graphics.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showLoadingIndicator = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              child: Column(
                children: [
                  Flexible(
                      flex: 3,
                      child: SliderCarousel(
                        showPrevNextButton: true,
                        showIndicator: true,
                        backgroundColor: Colors.transparent,
                        activeDotColor: Theme.of(context).colorScheme.primary,
                        deactiveDotColor: lightGrey,
                        iconColor: Colors.white,
                        rightIcon: Icons.arrow_forward,
                        leftIcon: Icons.arrow_back,
                        iconSize: 35,
                        // TODO: Remove this navigation on Release, just Dev purpose !
                        backgroundImage: InkWell(
                          onLongPress:
                              AppConst.values.falavor == Flavors.staging
                                  ? () => context.go(startScreen)
                                  : null,
                          child: SvgPicture(
                              AssetBytesLoader(
                                  Assets.images.gruenenTopicOekologieSvg),
                              height: size.height / 100 * 60),
                        ),
                        controlsBackground: Theme.of(context).primaryColor,
                        pages: [
                          SliderCarouselPage(
                            backgroundColorText: Theme.of(context).primaryColor,
                            backgroundColorImage: Colors.blue,
                            preserveImageSpace: false,
                            title: "Schau Dir Deine neue Mitglieder-App an",
                            titleFontWeight: FontWeight.bold,
                            titleFontSize: 33,
                            body:
                                "First impressions are everything in business, even in chat service. It’s important to show professionalism and courtesy from the start",
                          ),
                          SliderCarouselPage(
                            backgroundColorText: Theme.of(context).primaryColor,
                            preserveImageSpace: false,
                            title: "Coffee With Friends",
                            body:
                                "When your morning starts with a cup of coffee and you are used to survive the day with the same, then all your Instagram stories and snapchat streaks would stay filled up with coffee pictures",
                          ),
                          SliderCarouselPage(
                            backgroundColorText: Theme.of(context).primaryColor,
                            preserveImageSpace: false,
                            title: "Mobile Application",
                            body:
                                "Mobile content marketing has also been found to enhance quick online actions and make follow-ups easier.",
                          ),
                          SliderCarouselPage(
                            backgroundColorText: Theme.of(context).primaryColor,
                            preserveImageSpace: false,
                            title: "Content Team",
                            body:
                                "No two content marketing teams look the same.",
                          ),
                        ],
                      )),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IgnorePointer(
                        ignoring: showLoadingIndicator,
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              showLoadingIndicator = true;
                            });
                            final success = await startLogin();
                            if (success) {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              if (prefs.getBool(firstLaunchPreferencesKey) ??
                                  true) {
                                router.go(onboarding);
                              } else {
                                router.go(startScreen);
                              }
                            } else {
                              setState(() {
                                showLoadingIndicator = false;
                              });
                              MyApp.scaffoldMessengerKey.currentState
                                  ?.showSnackBar(const SnackBar(
                                      content: Center(
                                child: Text('Fehler beim Login '),
                              )));
                            }
                          },
                          child: Text(AppLocalizations.of(context)!.login,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyLarge
                                  ?.copyWith(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                AppLocalizations.of(context)!
                                    .registerMemberLabel,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyLarge),
                            const SizedBox(width: 20),
                            Text(
                              AppLocalizations.of(context)!.registerMember,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      decoration: TextDecoration.underline),
                            ),
                          ]),
                      Flexible(
                        flex: 2,
                        child: DatImpContainer(),
                      ),
                    ],
                  ))
                ],
              ),
            ),
            if (showLoadingIndicator) ...[
              const Positioned.fill(
                  child: Align(
                      alignment: Alignment.center,
                      child: SpinKitThreeBounce(
                        color: Colors.white,
                        size: 50.0,
                      )))
            ],
          ],
        ),
      ),
    );
  }
}
