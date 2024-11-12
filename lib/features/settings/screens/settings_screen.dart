import 'package:flutter/material.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/app/widgets/section_title.dart';
import 'package:gruene_app/features/settings/widgets/settings_item.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.only(top: 32),
      children: [
        SectionTitle(title: t.settings.campaignsSettings),
        SettingsItem(title: t.settings.inviteNonMember, onPress: () => {}),
        SettingsItem(title: t.settings.offlineMaps, onPress: () => {}),
        SectionTitle(title: t.settings.generalSettings),
        SettingsItem(title: t.settings.pushNotifications, onPress: () => {}),
        SettingsItem(title: t.settings.accessibility, onPress: () => {}),
        SettingsItem(title: t.settings.supportAndFeedback, onPress: () => {}),
        SettingsItem(
          title: t.settings.actionNetwork,
          onPress: () => {},
          isExternal: true,
        ),
        SettingsItem(title: t.settings.newsletter, onPress: () => {}, isExternal: true),
        SectionTitle(title: t.settings.legalSettings),
        SettingsItem(title: t.settings.legalNotice, onPress: () => {}),
        SettingsItem(title: t.settings.dataProtectionStatement, onPress: () => {}),
        SettingsItem(title: t.settings.termsOfUse, onPress: () => {}),
        Container(
          padding: const EdgeInsets.only(top: 48),
          child: TextButton(
            onPressed: () => {},
            child: Text(
              t.settings.logout,
              style: theme.textTheme.bodyMedium!.apply(color: ThemeColors.text, decoration: TextDecoration.underline),
            ),
          ),
        ),
      ],
    );
  }
}
