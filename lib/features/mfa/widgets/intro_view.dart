import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/app/constants/routes.dart';
import 'package:gruene_app/app/constants/urls.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/app/utils/open_url.dart';
import 'package:gruene_app/i18n/translations.g.dart';

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
          Text.rich(
            t.mfa.intro.info.scanQRCode(
              openMfaSettings: (text) => TextSpan(
                text: text,
                style: theme.textTheme.bodyMedium?.apply(
                  color: ThemeColors.primary,
                  decoration: TextDecoration.underline,
                  fontWeightDelta: 3,
                ),
                recognizer: TapGestureRecognizer()..onTap = () => openUrl(mfaSettingsUrl, context),
              ),
            ),
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
          Center(
            child: Text.rich(
              t.mfa.intro.moreInformation(
                openMfaInformation: (text) => TextSpan(
                  text: text,
                  style: theme.textTheme.labelSmall?.apply(
                    color: ThemeColors.primary,
                    decoration: TextDecoration.underline,
                    fontWeightDelta: 3,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () => openUrl(mfaInformationUrl, context),
                ),
              ),
              style: theme.textTheme.labelSmall,
            ),
          ),
        ],
      ),
    );
  }
}
