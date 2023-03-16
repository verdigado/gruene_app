import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/constants/layout.dart';
import 'package:gruene_app/net/profile/bloc/profile_bloc.dart';
import 'package:gruene_app/net/profile/data/member_profil.dart';
import 'package:gruene_app/widget/costume_separated_list.dart';
import 'package:gruene_app/widget/modal_top_line.dart';
import 'package:gruene_app/widget/multi_modal_select.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MemberProfilScreen extends StatefulWidget {
  const MemberProfilScreen({super.key});

  @override
  State<MemberProfilScreen> createState() => _MemberProfilScreenState();
}

class _MemberProfilScreenState extends State<MemberProfilScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: const Color.fromRGBO(247, 247, 247, 1),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return CostumeSeparatedList(
            items: getProfileEntries(context, state.profile.memberProfil),
          );
        },
      ),
    );
  }

  List<CostumeListItem> getProfileEntries(
      BuildContext context, MemberProfil memberProfil) {
    return [
      CostumeListItem(
        titel: 'Mitgliedsprofil',
        bold: true,
        divider: false,
      ),
      CostumeListItem(
        titel: 'Vorname',
        subtitel: memberProfil.givenName,
      ),
      CostumeListItem(
        titel: 'Nachname',
        subtitel: memberProfil.surname,
        spaceBetween: true,
      ),
      CostumeListItem(
        titel: 'E-Mail-Adresse',
        subtitel: memberProfil.email
            .where((element) => element.isFavourite == true)
            .first
            .value,
      ),
      CostumeListItem(
        titel: 'Telefonnummer',
        subtitel: memberProfil.telefon
            .where((element) => element.isFavourite == true)
            .first
            .value,
        spaceBetween: true,
        iconTralling: Icons.edit_outlined,
        modalSheet: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          enableDrag: false,
          builder: (context) {
            return BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                return MultiModalSelect(
                  onAddValue: (String value) => context
                      .read<ProfileBloc>()
                      .add(MemberProfileAddValue('telefon', value)),
                  onSaveValues: (favItemIndex) {
                    context.read<ProfileBloc>().add(DispatchProfile(
                        favTelfonnumberItemIndex: favItemIndex));
                    context.pop();
                  },
                  values: [
                    ...state.profile.memberProfil.telefon.map((e) => e.value)
                  ],
                  initalTextinputValue: '+49',
                );
              },
            );
          },
        ),
      ),
      CostumeListItem(
        titel: 'Mitgliedschaften',
        bold: true,
        divider: false,
      ),
      CostumeListItem(
        titel: 'Partei',
        subtitel: memberProfil.politicalParty,
      ),
      CostumeListItem(
        titel: 'Gliederung',
        subtitel: memberProfil.division,
      ),
    ];
  }
}
