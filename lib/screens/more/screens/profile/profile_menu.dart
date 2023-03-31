import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/constants/theme_data.dart';
import 'package:gruene_app/net/authentication/authentication.dart';
import 'package:gruene_app/net/profile/bloc/profile_bloc.dart';
import 'package:gruene_app/routing/router.dart';
import 'package:gruene_app/routing/routes.dart';
import 'package:gruene_app/widget/costume_separated_list.dart';
import 'package:gruene_app/screens/more/screens/profile/profile_list_view_header.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: greyBackground,
        appBar: AppBar(),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state.status == ProfileStatus.ready) {
              return CostumeSeparatedList(
                  items: getItems(context),
                  header: ProfileListViewHeader(
                    profile: state.profile,
                    onTap: () => context.pushNamed(profileDetailScreenName),
                  ));
            } else {
              return Container();
            }
          },
        ));
  }
}

List<CostumeListItem> getItems(BuildContext context) {
  return [
    CostumeListItem(
      titel: AppLocalizations.of(context)!.memberProfil,
      iconLeading: Icons.person_outlined,
      iconTralling: Icons.arrow_forward_ios,
      linksTo: memberprofilScreenName,
    ),
    CostumeListItem(
        titel: AppLocalizations.of(context)!.visibilityProfil,
        iconLeading: Icons.policy_outlined,
        iconTralling: Icons.arrow_forward_ios),
    CostumeListItem(
        titel: AppLocalizations.of(context)!.memberData,
        iconLeading: Icons.face_outlined,
        iconTralling: Icons.arrow_forward_ios),
    CostumeListItem(
        titel: AppLocalizations.of(context)!.groups,
        spaceBetween: true,
        iconLeading: Icons.group_outlined,
        iconTralling: Icons.arrow_forward_ios),
    CostumeListItem(
        titel: AppLocalizations.of(context)!.guide,
        iconLeading: Icons.explore_outlined,
        iconTralling: Icons.arrow_forward_ios),
    CostumeListItem(
        titel: AppLocalizations.of(context)!.supportAndContact,
        spaceBetween: true,
        iconLeading: Icons.help_outline,
        iconTralling: Icons.arrow_forward_ios),
    CostumeListItem(
        titel: AppLocalizations.of(context)!.imprint,
        iconLeading: Icons.plagiarism_outlined,
        iconTralling: Icons.arrow_forward_ios),
    CostumeListItem(
        titel: AppLocalizations.of(context)!.privacyPolicy,
        iconLeading: Icons.privacy_tip_outlined,
        iconTralling: Icons.arrow_forward_ios),
    CostumeListItem(
        titel: AppLocalizations.of(context)!.usernameAndPassword,
        spaceBetween: true,
        iconLeading: Icons.lock_outline,
        iconTralling: Icons.arrow_forward_ios),
    CostumeListItem(
      titel: AppLocalizations.of(context)!.logout,
      spaceBetween: true,
      iconLeading: Icons.logout_outlined,
      iconTralling: Icons.arrow_forward_ios,
      onTap: () async {
        var res = await showOkCancelAlertDialog(
            context: context, message: AppLocalizations.of(context)!.logout);
        if (res.name == OkCancelResult.ok.name) {
          await signOut();
          router.go(login);
        }
      },
    ),
  ];
}
