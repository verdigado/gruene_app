import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gruene_app/app/auth/bloc/auth_bloc.dart';
import 'package:gruene_app/app/constants/config.dart';
import 'package:gruene_app/app/widgets/section_title.dart';
import 'package:gruene_app/features/settings/widgets/settings_item.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

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
      ],
    );
  }
}
