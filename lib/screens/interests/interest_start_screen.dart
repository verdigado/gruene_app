import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/gen/assets.gen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gruene_app/routing/app_startup.dart';
import 'package:gruene_app/routing/routes.dart';
import 'package:gruene_app/widget/buttons/button_group.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_graphics/vector_graphics.dart';

class InterestStartScreen extends StatelessWidget {
  const InterestStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (ctx, con) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SvgPicture(
                      AssetBytesLoader(Assets.images.gruenenTopicOekologieSvg),
                      height: con.maxHeight / 100 * 40),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Text(
                            textAlign: TextAlign.center,
                            AppLocalizations.of(context)!.customPageHeadline1,
                            style:
                                Theme.of(context).primaryTextTheme.displayLarge,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                          child: Text(
                            textAlign: TextAlign.left,
                            AppLocalizations.of(context)!.customPageHeadline2,
                            style:
                                Theme.of(context).primaryTextTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ButtonGroupNextPrevious(
                    buttonNextKey: const Key('ButtonGroupNextIntro'),
                    nextText: AppLocalizations.of(context)!.askForInterest,
                    next: () => {context.go(interestpages)},
                    previousText: AppLocalizations.of(context)!.skip,
                    previous: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool(firstLaunchPreferencesKey, false);
                      context.push(notification);
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
