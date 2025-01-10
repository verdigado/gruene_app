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
    final supportEnabled = false;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 24),
          child: Text(
            t.settings.support.contacts,
            style: theme.textTheme.titleLarge,
          ),
        ),
        SettingsCard(
          title: t.settings.support.generalFeedback,
          subtitle: supportEnabled ? grueneSupportMail : '',
          icon: 'assets/icons/gruene.png',
          onPress: () => openMail(grueneSupportMail, context),
          isExternal: true,
          isEnabled: supportEnabled,
        ),
        SettingsCard(
          title: t.settings.support.campaignSupport,
          subtitle: supportEnabled ? pollionSupportMail : '',
          icon: 'assets/icons/pollion.png',
          onPress: () => openMail(pollionSupportMail, context),
          isExternal: true,
          isEnabled: supportEnabled,
        ),
        SettingsCard(
          title: t.settings.support.otherSupport,
          subtitle: supportEnabled ? verdigadoSupportMail : '',
          icon: 'assets/icons/verdigado.png',
          onPress: () => openMail(verdigadoSupportMail, context),
          isExternal: true,
          isEnabled: supportEnabled,
        ),
        ...supportEnabled
            ? []
            : [
                Container(
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 24),
                  child: Text(
                    'Aufgrund der hohen Anzahl an Anfragen bitten wir darum keine Anfragen per E-Mail zu senden.\nMehr Informationen zum Prozess "Feedback & Fehlermeldungen" findest Du im Wissenswerk-Artikel zur App. Danke für Dein Verständnis!',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: OutlinedButton(
                    onPressed: () => openUrl(
                      'https://netz.gruene.de/de/wissenswerk/2025-01/b90die-gruenen-die-app-von-buendnis-90die-gruenen',
                      context,
                    ),
                    child: Text(
                      'zum Wissenswerk-Artikel',
                      style: theme.textTheme.titleMedium?.apply(color: theme.colorScheme.tertiary),
                    ),
                  ),
                ),
              ],
      ],
    );
  }
}
