import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/constants/theme_data.dart';
import 'package:gruene_app/gen/assets.gen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gruene_app/routing/routes.dart';

class NotfificationScreen extends StatefulWidget {
  const NotfificationScreen({super.key});

  @override
  State<NotfificationScreen> createState() => _NotfificationScreenState();
}

class _NotfificationScreenState extends State<NotfificationScreen> {
  bool permission = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (ctx, con) {
          return SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: SvgPicture.asset(Assets.images.grueneTopicEuropa1,
                      height: con.maxHeight / 100 * 45),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                  child: Wrap(
                    children: [
                      Text(
                          AppLocalizations.of(context)!
                              .notificationPageHeadline1,
                          style:
                              Theme.of(context).primaryTextTheme.displayLarge),
                      Text(
                        AppLocalizations.of(context)!.notificationPageHeadline2,
                        style: const TextStyle(height: 2),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: FlutterSwitch(
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
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: ElevatedButton(
                      onPressed: () => handlePermission(context, permission),
                      child: Text(AppLocalizations.of(context)!.next,
                          style: const TextStyle(color: Colors.white))),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void handlePermission(BuildContext context, bool activ) {
    context.go(startScreen);
  }
}
