import 'package:flutter/material.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/app/widgets/icon.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class SettingsItem extends StatelessWidget {
  final String title;
  final bool isExternal;
  final bool isImplemented;
  final void Function() onPress;

  const SettingsItem({
    super.key,
    required this.title,
    required this.onPress,
    this.isExternal = false,
    this.isImplemented = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      enabled: isImplemented,
      onTap: onPress,
      title: Text(
        isImplemented ? title : '$title ${t.settings.notImplemented}',
        style: theme.textTheme.bodyLarge?.apply(color: isImplemented ? ThemeColors.text : ThemeColors.textDisabled),
      ),
      trailing: CustomIcon(
        path: isExternal ? 'assets/icons/external.svg' : 'assets/icons/chevron.svg',
        color: theme.disabledColor,
        width: 16,
        height: 16,
      ),
      tileColor: theme.colorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }
}
