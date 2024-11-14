import 'package:flutter/material.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/app/widgets/icon.dart';

class SettingsItem extends StatelessWidget {
  final String title;
  final bool isExternal;
  final void Function() onPress;

  const SettingsItem({super.key, required this.title, required this.onPress, this.isExternal = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onPress,
      title: Text(title, style: theme.textTheme.bodyLarge?.apply(color: ThemeColors.text)),
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
