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
// ignore: depend_on_referenced_packages
import 'package:vector_graphics/vector_graphics.dart';

import '../../constants/theme_data.dart';

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Flexible(
                    flex: 8,
                    child: SvgPicture(
                      AssetBytesLoader(Assets.images.bicycleMan),
                    ),
                  ),
                  const Spacer(),
                  Flexible(
                    flex: 12,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                              ),
                              child: Text(
                                textAlign: TextAlign.left,
                                AppLocalizations.of(context)!
                                    .customPageHeadline1,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .displayLarge,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                              child: Text(
                                textAlign: TextAlign.left,
                                AppLocalizations.of(context)!
                                    .customPageHeadline2,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: darkGrey,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        ButtonGroupNextPrevious(
                          nextText:
                              AppLocalizations.of(context)!.askForInterest,
                          next: () => {context.push(interestpages)},
                          previousText: AppLocalizations.of(context)!.skip,
                          previous: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool(
                                firstLaunchPreferencesKey, false);
                            context.push(notification);
                          },
                        ),
                      ],
                    ),
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
