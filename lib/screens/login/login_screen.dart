import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/constants/theme_data.dart';

import 'package:gruene_app/gen/assets.gen.dart';

import 'package:gruene_app/routing/routes.dart';
import 'package:gruene_app/widget/privacy_imprint.dart';
import 'package:gruene_app/widget/slider_carousel.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:vector_graphics/vector_graphics.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
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
                  backgroundImage: SvgPicture(
                      AssetBytesLoader(Assets.images.gruenenTopicOekologieSvg),
                      height: size.height / 100 * 60),
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
                      body: "No two content marketing teams look the same.",
                    ),
                  ],
                )),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async => startLogin(),
                  child: Text(AppLocalizations.of(context)!.login,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.white)),
                ),
                const SizedBox(height: 20),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!.registerMemberLabel,
                          style: Theme.of(context).primaryTextTheme.bodyLarge),
                      const SizedBox(width: 20),
                      Text(
                        AppLocalizations.of(context)!.registerMember,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .bodyMedium
                            ?.copyWith(decoration: TextDecoration.underline),
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
    );
  }

  void refreshToken(String? refreshToken) async {
    const appAuth = FlutterAppAuth();
    var res = await appAuth.token(TokenRequest(
      'gruene_app',
      'grueneapp://appAuth?prompt=login',
      discoveryUrl:
          'https://saml.gruene.de/realms/gruenes-netz/.well-known/openid-configuration',
      refreshToken: refreshToken,
      scopes: [
        "openid",
        "address",
        "acr",
        "email",
        "web-origins",
        "oauth-einverstaendniserklaerung",
        "oauth-username",
        "roles",
        "profile",
        "phone",
        "offline_access",
        "microprofile-jwt"
      ],
    ));
    res = res;
  }

  void startLogin() async {
    const appAuth = FlutterAppAuth();
    final result = await appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        'gruene_app',
        'grueneapp://appAuth',
        discoveryUrl:
            'https://saml.gruene.de/realms/gruenes-netz/.well-known/openid-configuration',
        scopes: [
          "openid",
          "address",
          "acr",
          "email",
          "web-origins",
          "oauth-einverstaendniserklaerung",
          "oauth-username",
          "roles",
          "profile",
          "phone",
          "offline_access",
          "microprofile-jwt"
        ],
      ),
    );
  }
}
