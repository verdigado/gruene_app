import 'package:flutter/material.dart';
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
            onPressed: () => {},
            icon: Icon(
              Icons.favorite,
              color: theme.colorScheme.tertiary,
            ),
            label: Text(
              t.intro.support,
              style: theme.textTheme.titleMedium?.apply(color: theme.colorScheme.tertiary),
            ),
          ),
        ),
      );
  }
}
