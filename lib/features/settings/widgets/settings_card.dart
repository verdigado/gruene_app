import 'package:flutter/material.dart';
import 'package:gruene_app/app/widgets/icon.dart';

class SettingsCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final bool isExternal;
  final void Function() onPress;

  const SettingsCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onPress,
    this.isExternal = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surface,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: onPress,
        title: Text(title, style: theme.textTheme.titleSmall),
        subtitle: Text(subtitle),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(icon, height: 48, width: 48),
        ),
        trailing: CustomIcon(
          path: isExternal ? 'assets/icons/external.svg' : 'assets/icons/chevron.svg',
          color: theme.disabledColor,
          width: 16,
          height: 16,
        ),
      ),
    );
  }
}
