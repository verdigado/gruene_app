import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gruene_app/constants/theme_data.dart';
import 'package:gruene_app/net/profile/bloc/profile_bloc.dart';
import 'package:gruene_app/net/profile/data/member_profil.dart';
import 'package:gruene_app/widget/costume_separated_list.dart';
import 'package:gruene_app/widget/multi_modal_select.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      backgroundColor: greyBackground,
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
        titel: AppLocalizations.of(context)!.memberProfil,
        bold: true,
        divider: false,
      ),
      CostumeListItem(
        titel: AppLocalizations.of(context)!.givenName,
        subtitel: memberProfil.givenName,
      ),
      CostumeListItem(
        titel: AppLocalizations.of(context)!.surename,
        subtitel: memberProfil.surname,
        spaceBetween: true,
      ),
      CostumeListItem(
        titel: AppLocalizations.of(context)!.emailAdress,
        subtitel: memberProfil.email
            .where((element) => element.isFavourite == true)
            .first
            .value,
        iconTralling: Icons.edit_outlined,
        modalSheet: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                return MultiModalSelect(
                  inputHeadline: AppLocalizations.of(context)!.emailAsFav,
                  inputHint: AppLocalizations.of(context)!.emailAdress,
                  inputLabel: AppLocalizations.of(context)!.emailAdress,
                  onAddValue: (String value) => context
                      .read<ProfileBloc>()
                      .add(MemberProfileAddValue('email', value)),
                  onAddFavouriteValue: (favItemIndex) {
                    context
                        .read<ProfileBloc>()
                        .add(DispatchProfile(favEmailItemIndex: favItemIndex));
                  },
                  values: [
                    ...state.profile.memberProfil.email.map((e) => e.value)
                  ],
                  textInputType: TextInputType.emailAddress,
                  validate: (value) {
                    return value != null &&
                        value.isNotEmpty &&
                        !state.profile.memberProfil.email
                            .map((e) => e.value)
                            .contains(value) &&
                        value.contains('@');
                  },
                );
              },
            );
          },
        ),
      ),
      CostumeListItem(
        titel: AppLocalizations.of(context)!.telefonnumber,
        subtitel: memberProfil.telefon
            .where((element) => element.isFavourite == true)
            .first
            .value,
        spaceBetween: true,
        iconTralling: Icons.edit_outlined,
        modalSheet: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                return MultiModalSelect(
                  inputHint: AppLocalizations.of(context)!.telefonnumber,
                  inputLabel: AppLocalizations.of(context)!.telefonnumber,
                  inputHeadline:
                      AppLocalizations.of(context)!.telefonnumberAsFav,
                  onAddValue: (String value) => context
                      .read<ProfileBloc>()
                      .add(MemberProfileAddValue('telefon', value)),
                  onAddFavouriteValue: (favItemIndex) {
                    context.read<ProfileBloc>().add(DispatchProfile(
                        favTelfonnumberItemIndex: favItemIndex));
                  },
                  values: [
                    ...state.profile.memberProfil.telefon.map((e) => e.value)
                  ],
                  initalTextinputValue: '+49',
                  textInputType: TextInputType.phone,
                  validate: (value) {
                    return value != null &&
                        value.isNotEmpty &&
                        !state.profile.memberProfil.telefon
                            .map((e) => e.value)
                            .contains(value) &&
                        value.startsWith('+') &&
                        value.length <= 16;
                  },
                );
              },
            );
          },
        ),
      ),
      CostumeListItem(
        titel: AppLocalizations.of(context)!.memberships,
        bold: true,
        divider: false,
      ),
      CostumeListItem(
        titel: AppLocalizations.of(context)!.politicalParty,
        subtitel: memberProfil.politicalParty,
      ),
      CostumeListItem(
        titel: AppLocalizations.of(context)!.division,
        subtitel: memberProfil.division,
      ),
    ];
  }
}
