import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/gen/assets.gen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/link.dart';
import '../../widget/privacy_imprint.dart';
import '../../widget/slider_carousel.dart';
import '../../routing/routes.dart';

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
                  deactiveDotColor: const Color(0xFFD9D9D9),
                  iconColor: Colors.white,
                  rightIcon: Icons.arrow_forward,
                  leftIcon: Icons.arrow_back,
                  iconSize: 35,
                  backgroundImage: SvgPicture.asset(
                      Assets.images.gRUENETopicOekologie,
                      height: size.height / 100 * 60),
                  controlsBackground: Theme.of(context).primaryColor,
                  pages: [
                    SliderCarouselPage(
                      backgroundColorText: Theme.of(context).primaryColor,
                      backgroundColorImage: Colors.blue,
                      preserveImageSpace: false,
                      title: "Business Chat",
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
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => context.go(login),
                      child: Text(AppLocalizations.of(context)!.login,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.white)),
                    ),
                    const SizedBox(height: 20),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              AppLocalizations.of(context)!.registerMemberLabel,
                              style: Theme.of(context).textTheme.bodyLarge),
                          const SizedBox(width: 20),
                          Text(
                            AppLocalizations.of(context)!.registerMember,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    decoration: TextDecoration.underline),
                          ),
                        ]),
                    const SizedBox(height: 10),
                    const DatImpContainer(),
                    const SizedBox(height: 10),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
