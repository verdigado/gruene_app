import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/app/auth/bloc/auth_bloc.dart';
import 'package:gruene_app/app/constants/config.dart';
import 'package:gruene_app/app/constants/routes.dart';
import 'package:gruene_app/app/constants/urls.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/app/utils/open_inappbrowser.dart';
import 'package:gruene_app/app/widgets/section_title.dart';
import 'package:gruene_app/features/settings/widgets/settings_item.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authBloc = context.read<AuthBloc>();
    final isLoggedIn = !Config.useLogin || authBloc.state is Authenticated;
    return ListView(
      padding: const EdgeInsets.only(top: 32),
      children: [
        SectionTitle(title: t.settings.campaignsSettings),
        SettingsItem(title: t.settings.inviteNonMember, onPress: () => {}),
        SettingsItem(title: t.settings.offlineMaps, onPress: () => {}),
        SectionTitle(title: t.settings.generalSettings),
        SettingsItem(title: t.settings.pushNotifications, onPress: () => {}),
        SettingsItem(title: t.settings.accessibility, onPress: () => {}),
        SettingsItem(
          title: t.settings.supportAndFeedback,
          onPress: () => context.pushNamed(t.settings.supportAndFeedback),
        ),
        SettingsItem(
          title: t.settings.actionNetwork,
          onPress: () => {},
          isExternal: true,
        ),
        SettingsItem(title: t.settings.newsletter, onPress: () => {}, isExternal: true),
        SectionTitle(title: t.settings.legalSettings),
        SettingsItem(
          title: t.settings.legalNotice,
          onPress: () => openInAppBrowser(legalNoticeUrl, context),
          isExternal: true,
        ),
        SettingsItem(
          title: t.settings.dataProtectionStatement,
          onPress: () => openInAppBrowser(dataProtectionStatementUrl, context),
          isExternal: true,
        ),
        SettingsItem(
          title: t.settings.termsOfUse,
          onPress: () => openInAppBrowser(termsOfUseUrl, context),
          isExternal: true,
        ),
        isLoggedIn
            ? Container(
                padding: const EdgeInsets.only(top: 48),
                child: TextButton(
                  onPressed: () => context.read<AuthBloc>().add(SignOutRequested()),
                  child: Text(
                    t.settings.logout,
                    style: theme.textTheme.bodyMedium!
                        .apply(color: ThemeColors.text, decoration: TextDecoration.underline),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
