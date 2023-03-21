import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/gen/assets.gen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gruene_app/routing/routes.dart';
import 'package:vector_graphics/vector_graphics.dart';

class IntroPage extends StatefulWidget {
  final PageController controller;

  const IntroPage(this.controller, {super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SvgPicture(AssetBytesLoader(Assets.images.gruenenTopicOekologieSvg),
            height: size.height / 100 * 40),
        Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                textAlign: TextAlign.center,
                AppLocalizations.of(context)!.customPageHeadline1,
                style: Theme.of(context).primaryTextTheme.displayLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 50),
              child: Text(
                textAlign: TextAlign.center,
                AppLocalizations.of(context)!.customPageHeadline2,
                style: Theme.of(context).primaryTextTheme.bodyMedium,
              ),
            ),
          ],
        ),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton(
                key: const Key('intro_page_next_step'),
                onPressed: () => widget.controller.nextPage(
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeIn),
                child: Text(AppLocalizations.of(context)!.askForInterest,
                    style: const TextStyle(color: Colors.white))),
            TextButton(
                onPressed: () => context.go(startScreen),
                child: Text(AppLocalizations.of(context)!.skipCustomText))
          ],
        ),
      ],
    );
  }
}
