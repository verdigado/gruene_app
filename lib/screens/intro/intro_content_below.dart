import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/constants/app_const.dart';
import 'package:gruene_app/constants/flavors.dart';
import 'package:gruene_app/gen/assets.gen.dart';
import 'package:vector_graphics/vector_graphics.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gruene_app/constants/theme_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gruene_app/main.dart';
import 'package:gruene_app/net/authentication/authentication.dart';
import 'package:gruene_app/routing/router.dart';
import 'package:gruene_app/routing/routes.dart';
import 'package:gruene_app/widget/privacy_imprint.dart';

class IntroContentBelow extends StatefulWidget {
  const IntroContentBelow({super.key});

  @override
  State<IntroContentBelow> createState() => _IntroContentBelowState();
}

class _IntroContentBelowState extends State<IntroContentBelow> {
  bool showLoadingIndicator = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: InkWell(
                    onLongPress: GruneAppData.values.flavor == Flavors.staging
                        ? () => context.go(startScreen)
                        : null,
                    child: SvgPicture(
                      AssetBytesLoader(Assets.images.user),
                    ),
                  ),
                ),
                const Spacer(),
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
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      textAlign: TextAlign.center,
                      AppLocalizations.of(context)!.introHeadline2,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .displaySmall
                          ?.copyWith(color: darkGrey),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
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
                                child: Text(
                                    AppLocalizations.of(context)!.loginFailure),
                              )));
                            }
                          },
                          child: Text(AppLocalizations.of(context)!.login,
                              style: const TextStyle(color: Colors.white))),
                    ),
                  ),
                ),
                DatImpContainer()
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
        ],
      ],
    );
  }
}
