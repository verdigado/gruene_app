import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/gen/assets.gen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gruene_app/routing/routes.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../constants/theme_data.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(Assets.images.grueneTopicEconomy),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    textAlign: TextAlign.center,
                    AppLocalizations.of(context)!.introHeadline1,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    textAlign: TextAlign.center,
                    AppLocalizations.of(context)!.introHeadline2,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                ElevatedButton(
                    onPressed: () => context.go(login),
                    child: Text(AppLocalizations.of(context)!.loginButtonText,
                        style: const TextStyle(color: Colors.white))),
              ],
            ),
          ),
        ),
        SlidingUpPanel(
          minHeight: 50,
          maxHeight: MediaQuery.of(context).size.height,
          parallaxEnabled: true,
          backdropEnabled: true,
          backdropColor: Color(0xFFFF495D),
          panel: Container(
            color: Color(0xFFFF495D),
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: 45,
                  height: 5,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    "This is the sliding Widget",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    ));
  }
}
