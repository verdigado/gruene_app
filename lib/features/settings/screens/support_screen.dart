import 'package:flutter/material.dart';
import 'package:gruene_app/app/constants/urls.dart';
import 'package:gruene_app/app/utils/open_url.dart';
import 'package:gruene_app/features/settings/widgets/settings_card.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 24),
          child: Text(t.settings.support.contacts, style: theme.textTheme.titleLarge),
        ),
        SettingsCard(
          title: t.settings.support.generalFeedback,
          subtitle: grueneSupportMail,
          icon: 'assets/icons/gruene.png',
          onPress: () => openMail(grueneSupportMail),
          isExternal: true,
        ),
        SettingsCard(
          title: t.settings.support.campaignSupport,
          subtitle: pollionSupportMail,
          icon: 'assets/icons/pollion.png',
          onPress: () => openMail(pollionSupportMail),
          isExternal: true,
        ),
        SettingsCard(
          title: t.settings.support.otherSupport,
          subtitle: verdigadoSupportMail,
          icon: 'assets/icons/verdigado.png',
          onPress: () => openMail(verdigadoSupportMail),
          isExternal: true,
        ),
      ],
    );
  }
}
