import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:gruene_app/constants/layout.dart';
import 'package:gruene_app/constants/theme_data.dart';
import 'package:gruene_app/gen/assets.gen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gruene_app/routing/app_startup.dart';
import 'package:gruene_app/routing/router.dart';
import 'package:gruene_app/routing/routes.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:vector_graphics/vector_graphics.dart';

class NotfificationScreen extends StatefulWidget {
  const NotfificationScreen({super.key});

  @override
  State<NotfificationScreen> createState() => _NotfificationScreenState();
}

class _NotfificationScreenState extends State<NotfificationScreen> {
  bool permission = true;
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                flex: 12,
                child: SvgPicture(
                  AssetBytesLoader(Assets.images.manSitting),
                ),
              ),
              const Spacer(),
              Flexible(
                flex: 16,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                  ),
                  child: Column(
                    children: [
                      Text(
                          AppLocalizations.of(context)!
                              .notificationPageHeadline1,
                          style:
                              Theme.of(context).primaryTextTheme.displayLarge),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: medium1),
                        child: Text(
                          AppLocalizations.of(context)!
                              .notificationPageHeadline2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: /* FlutterSwitch(
                      value: permission,
                      activeColor: mcgpalette0Secondary,
                      inactiveIcon: const Icon(
                        Icons.close,
                        color: Colors.red,
                      ), */
                      FlutterSwitch(
                    value: permission,
                    activeColor: mcgpalette0Secondary,
                    inactiveIcon: const Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    activeIcon: const Icon(
                      Icons.check,
                      color: mcgpalette0Secondary,
                    ),
                    onToggle: (value) {
                      setState(() {
                        permission = value;
                      });
                    },
                  ),
                ),
              ),
              const Spacer(),
              Flexible(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: ElevatedButton(
                      onPressed: () async => onNext(context, permission),
                      child: Text(AppLocalizations.of(context)!.next,
                          style: const TextStyle(color: Colors.white))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onNext(BuildContext context, bool activ) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(firstLaunchPreferencesKey, false);
    router.go(startScreen);
  }
}
