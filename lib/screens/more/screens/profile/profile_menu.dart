import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/net/profile/bloc/profile_bloc.dart';
import 'package:gruene_app/routing/routes.dart';
import 'package:gruene_app/screens/more/more_screen.dart';
import 'package:gruene_app/widget/costume_separated_list.dart';
import 'package:gruene_app/screens/more/screens/profile/profile_list_view_header.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});

  static const items = [
    CostumeListItem(
        titel: 'Persönliches Mitgliedsprofil',
        iconLeading: Icons.star_border_outlined,
        iconTralling: Icons.arrow_forward_ios),
    CostumeListItem(
        titel: 'Sichtbarkeit Deines öffentlichen Profils',
        iconLeading: Icons.star_border_outlined,
        iconTralling: Icons.arrow_forward_ios),
    CostumeListItem(
        titel: 'Mitgliederdaten',
        iconLeading: Icons.star_border_outlined,
        iconTralling: Icons.arrow_forward_ios),
    CostumeListItem(
        titel: 'Gruppen',
        spaceBetween: true,
        iconLeading: Icons.star_border_outlined,
        iconTralling: Icons.arrow_forward_ios),
    CostumeListItem(
        titel: 'Anleitung',
        iconLeading: Icons.star_border_outlined,
        iconTralling: Icons.arrow_forward_ios),
    CostumeListItem(
        titel: 'Hilfe und Kontakt',
        spaceBetween: true,
        iconLeading: Icons.star_border_outlined,
        iconTralling: Icons.arrow_forward_ios),
    CostumeListItem(
        titel: 'Impressum',
        iconLeading: Icons.star_border_outlined,
        iconTralling: Icons.arrow_forward_ios),
    CostumeListItem(
        titel: 'Datenschutz',
        iconLeading: Icons.star_border_outlined,
        iconTralling: Icons.arrow_forward_ios),
    CostumeListItem(
        titel: 'Passwort und Benutzername ändern',
        spaceBetween: true,
        iconLeading: Icons.star_border_outlined,
        iconTralling: Icons.arrow_forward_ios),
    CostumeListItem(
        titel: 'Ausloggen',
        spaceBetween: true,
        iconLeading: Icons.star_border_outlined,
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
