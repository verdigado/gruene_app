import 'package:flutter/material.dart';
import 'package:gruene_app/app/constants/urls.dart';
import 'package:gruene_app/app/utils/open_inappbrowser.dart';
import 'package:gruene_app/app/widgets/icon.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class SupportButton extends StatelessWidget {
  const SupportButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned(
      right: 24,
      top: 32,
      width: 48,
      child: RotatedBox(
        quarterTurns: 3,
        child: OutlinedButton.icon(
          onPressed: () => openInAppBrowser(supportUrl, context),
          icon: CustomIcon(
            path: 'assets/icons/heart.svg',
            color: theme.colorScheme.tertiary,
            width: 16,
            height: 16,
          ),
          label: Text(
            t.login.support,
            style: theme.textTheme.titleMedium?.apply(color: theme.colorScheme.tertiary),
          ),
        ),
      ),
    );
  }
}
