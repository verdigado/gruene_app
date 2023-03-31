import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gruene_app/gen/assets.gen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gruene_app/main.dart';
import 'package:gruene_app/net/authentication/authentication.dart';
import 'package:gruene_app/routing/router.dart';
import 'package:gruene_app/routing/routes.dart';
import 'package:gruene_app/widget/modal_top_line.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:vector_graphics/vector_graphics.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  bool showLoadingIndicator = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final panelMinHeight = size.height / 100 * 10;
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: SvgPicture(
                      AssetBytesLoader(Assets.images.grueneTopicEconomySvg),
                      height: size.height / 100 * 60),
                ),
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      textAlign: TextAlign.center,
                      AppLocalizations.of(context)!.introHeadline1,
                      style: Theme.of(context).primaryTextTheme.displayLarge,
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      textAlign: TextAlign.center,
                      AppLocalizations.of(context)!.introHeadline2,
                      style: Theme.of(context).primaryTextTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: panelMinHeight + 10),
            child: AbsorbPointer(
              absorbing: showLoadingIndicator,
              child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      showLoadingIndicator = true;
                    });
                    final success = await startLogin();
                    if (success) {
                      router.go(onboarding);
                    } else {
                      setState(() {
                        showLoadingIndicator = false;
                      });
                      MyApp.scaffoldMessengerKey.currentState
                          ?.showSnackBar(SnackBar(
                              content: Center(
                        child: Text(AppLocalizations.of(context)!.loginFailure),
                      )));
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.login,
                      style: const TextStyle(color: Colors.white))),
            ),
          ),
        ),
        SlidingUpPanel(
          minHeight: panelMinHeight,
          maxHeight: size.height,
          parallaxEnabled: true,
          backdropEnabled: true,
          backdropColor: Theme.of(context).colorScheme.secondary,
          panel: Container(
            color: Theme.of(context).colorScheme.secondary,
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                const ModalTopLine(color: Colors.white),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.tourSliderIntroText,
                    style: Theme.of(context).primaryTextTheme.titleMedium!
                      ..copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showLoadingIndicator) ...[
          Positioned.fill(
              child: Align(
                  alignment: Alignment.center,
                  child: SpinKitThreeBounce(
                    color: Theme.of(context).colorScheme.secondary,
                    size: 50.0,
                  )))
        ]
      ]),
    ));
  }
}
