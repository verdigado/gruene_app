import 'package:flutter/material.dart';
import 'package:gruene_app/app/theme.dart';
import 'package:gruene_app/app/widgets/bottom_sheet_handle.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Spacer(),
        SizedBox(
          height: 256,
          child: Image(image: AssetImage('assets/graphics/intro.png')),
        ),
        Center(
          child: Text(t.intro.welcome, style: theme.textTheme.displayLarge?.apply(color: ThemeColors.text)),
        ),
        Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          height: 64,
          child: FilledButton(
            onPressed: () => {},
            child: Text(t.intro.loginMembers, style: theme.textTheme.titleMedium),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: OutlinedButton(
            onPressed: () => {},
            child: Text(
              t.intro.loginNonMembers,
              style: theme.textTheme.titleMedium?.apply(color: theme.colorScheme.tertiary),
            ),
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
        BottomSheetHandle(),
      ],
    );
  }
}
