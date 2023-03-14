import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gruene_app/constants/layout.dart';
import 'package:gruene_app/net/profile/bloc/profile_bloc.dart';
import 'package:gruene_app/net/profile/data/member_profil.dart';
import 'package:gruene_app/widget/costume_separated_list.dart';
import 'package:gruene_app/widget/modal_top_line.dart';
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
          final memberProfil = state.profile.memberProfil;
          return CostumeSeparatedList(
            items: getProfileEntries(context, memberProfil),
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
            return modalContent(context);
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

  Widget modalContent(BuildContext context) {
    return LayoutBuilder(builder: (ctx, con) {
      return Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () => print('close'),
                      child: const Icon(
                        Icons.close_outlined,
                        size: medium2,
                      )),
                  TextButton(
                    style: ButtonStyle(
                      textStyle: MaterialStatePropertyAll(Theme.of(context)
                          .primaryTextTheme
                          .labelLarge
                          ?.copyWith(decoration: TextDecoration.underline)),
                    ),
                    onPressed: () => print('Save'),
                    child: const Text(
                      'Speichern',
                    ),
                  )
                ],
              ),
              Text(
                'Wähle dein Favorit',
                style: Theme.of(context).primaryTextTheme.displaySmall,
              ),
              SizedBox(
                height: con.maxHeight / 100 * 18,
                child: ListWheelScrollView(
                  children: [
                    Text(
                      '01726584554',
                      style: Theme.of(context).primaryTextTheme.displaySmall,
                    ),
                    Text(
                      '1548531354',
                      style: Theme.of(context).primaryTextTheme.displaySmall,
                    ),
                    Text(
                      '121343543',
                      style: Theme.of(context).primaryTextTheme.displaySmall,
                    ),
                    Text(
                      '121343543',
                      style: Theme.of(context).primaryTextTheme.displaySmall,
                    )
                  ],
                  itemExtent: 65,
                ),
              ),
              Divider(),
              Text(
                'Neue Nummer eintragen',
                style: Theme.of(context).primaryTextTheme.displaySmall,
              ),
              SizedBox(
                height: medium1,
              ),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Telefonnummer',
                  border: OutlineInputBorder(),
                  hintText: 'Enter a search term',
                ),
              ),
              SizedBox(
                height: medium1,
              ),
            ],
          ),
        ),
      );
    });
  }
}
