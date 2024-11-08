import 'package:flutter/material.dart';
import 'package:gruene_app/app/theme.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: ThemeColors.background,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image(image: AssetImage('assets/graphics/intro.png')),
                Center(
                  child: Text(t.intro.welcome, style: theme.textTheme.displayLarge?.apply(color: ThemeColors.text)),
                ),
                SizedBox(
                  height: 64,
                  child: FilledButton(
                    onPressed: () => {},
                    child: Text(t.intro.loginMembers, style: theme.textTheme.titleMedium),
                  ),
                ),
                OutlinedButton(
                  onPressed: () => {},
                  child: Text(
                    t.intro.loginNonMembers,
                    style: theme.textTheme.titleMedium?.apply(color: theme.colorScheme.tertiary),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => {},
                      child: Text(
                        t.intro.dataProtection,
                        style: theme.textTheme.labelSmall?.apply(color: ThemeColors.textAccent),
                      ),
                    ),
                    Icon(Icons.circle, size: 4),
                    TextButton(
                      onPressed: () => {},
                      child: Text(
                        t.intro.legalNotice,
                        style: theme.textTheme.labelSmall?.apply(color: ThemeColors.textAccent),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 24,
            top: 32,
            width: 48,
            child: RotatedBox(
              quarterTurns: 3,
              child: OutlinedButton.icon(
                onPressed: () => {},
                icon: Icon(
                  Icons.favorite,
                  color: ThemeColors.tertiary,
                ),
                label: Text(
                  t.intro.support,
                  style: theme.textTheme.titleMedium?.apply(color: ThemeColors.tertiary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
