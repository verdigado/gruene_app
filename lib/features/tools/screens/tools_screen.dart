import 'package:flutter/material.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 33, 24, 26),
      child: Center(
        child: Text(
          t.common.notImplementedYet,
          style: theme.textTheme.bodyLarge?.apply(color: ThemeColors.text),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
