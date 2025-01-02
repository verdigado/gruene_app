import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/app/constants/routes.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/i18n/translations.g.dart';
import 'package:url_launcher/url_launcher_string.dart';

class IntroView extends StatelessWidget {
  const IntroView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 33, 24, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            t.mfa.intro.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.displayLarge,
          ),
          const SizedBox(height: 48),
          Text(
            t.mfa.intro.info.easyLogin,
            style: theme.textTheme.bodyMedium?.apply(fontWeightDelta: 3),
          ),
          Text(
            t.mfa.intro.info.noShortMessageNeeded,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Text(
            t.mfa.intro.info.scanQRCode,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Text(
            t.mfa.intro.info.notificationOnLogin,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Spacer(),
          FilledButton(
            onPressed: () => {
              context.push(
                '${Routes.mfa.path}/${Routes.mfaTokenScan.path}',
              ),
            },
            style: ButtonStyle(
              minimumSize: WidgetStateProperty.all<Size>(Size.fromHeight(56)),
            ),
            child: Text(
              t.mfa.intro.startSetup,
              style: theme.textTheme.titleMedium?.apply(color: theme.colorScheme.surface),
            ),
          ),
          const SizedBox(height: 22),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: t.mfa.intro.moreInformation.text,
              style: theme.textTheme.labelSmall,
              children: [
                TextSpan(
                  text: ' ',
                  style: theme.textTheme.labelSmall,
                ),
                TextSpan(
                  text: t.mfa.intro.moreInformation.link,
                  style: theme.textTheme.labelSmall?.apply(
                    color: ThemeColors.primary,
                    decoration: TextDecoration.underline,
                    fontWeightDelta: 3,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchUrlString(
                        'https://netz.gruene.de/de/wissenswerk/2024-02/2-faktor-authentifizierung-mit-einer-app-anleitung',
                        mode: LaunchMode.externalApplication,
                      );
                    },
                ),
                TextSpan(
                  text: t.mfa.intro.moreInformation.point,
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
