import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/gen/assets.gen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gruene_app/routing/routes.dart';

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
        SvgPicture.asset(Assets.images.gRUENETopicOekologie,
            height: size.height / 100 * 40),
        Wrap(
          children: [
            Text(
              textAlign: TextAlign.center,
              AppLocalizations.of(context)!.customPageHeadline1,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 50),
              child: Text(
                textAlign: TextAlign.center,
                AppLocalizations.of(context)!.customPageHeadline2,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () => widget.controller.nextPage(
                    duration: const Duration(milliseconds: 500),
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
