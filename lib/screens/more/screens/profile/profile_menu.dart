import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/net/profile/bloc/profile_bloc.dart';
import 'package:gruene_app/routing/routes.dart';
import 'package:gruene_app/screens/more/more_screen.dart';
import 'package:gruene_app/screens/more/screens/profile/member_profil_screen.dart';
import 'package:gruene_app/widget/costume_separated_list.dart';
import 'package:gruene_app/screens/more/screens/profile/profile_list_view_header.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});

  static const items = [
    CostumeListItem(
      titel: 'Mitgliedsprofil',
      iconLeading: Icons.person_outlined,
      iconTralling: Icons.arrow_forward_ios,
      linksTo: memberprofilScreenName,
    ),
    CostumeListItem(
        titel: 'Sichtbarkeit Profil',
        iconLeading: Icons.policy_outlined,
        iconTralling: Icons.arrow_forward_ios),
    CostumeListItem(
        titel: 'Mitgliederdaten',
        iconLeading: Icons.face_outlined,
        iconTralling: Icons.arrow_forward_ios),
    CostumeListItem(
        titel: 'Gruppen',
        spaceBetween: true,
        iconLeading: Icons.group_outlined,
        iconTralling: Icons.arrow_forward_ios),
    CostumeListItem(
        titel: 'Anleitung',
        iconLeading: Icons.explore_outlined,
        iconTralling: Icons.arrow_forward_ios),
    CostumeListItem(
        titel: 'Hilfe und Kontakt',
        spaceBetween: true,
        iconLeading: Icons.help_outline,
        iconTralling: Icons.arrow_forward_ios),
    CostumeListItem(
        titel: 'Impressum',
        iconLeading: Icons.plagiarism_outlined,
        iconTralling: Icons.arrow_forward_ios),
    CostumeListItem(
        titel: 'Datenschutz',
        iconLeading: Icons.privacy_tip_outlined,
        iconTralling: Icons.arrow_forward_ios),
    CostumeListItem(
        titel: 'Passwort und Benutzername',
        spaceBetween: true,
        iconLeading: Icons.lock_outline,
        iconTralling: Icons.arrow_forward_ios),
    CostumeListItem(
        titel: 'Ausloggen',
        spaceBetween: true,
        iconLeading: Icons.logout_outlined,
        iconTralling: Icons.arrow_forward_ios),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(247, 247, 247, 1),
        appBar: AppBar(),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state.status == ProfileStatus.ready) {
              return CostumeSeparatedList(
                  items: items,
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
