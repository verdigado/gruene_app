import 'package:flutter/material.dart';
import 'package:gruene_app/constants/theme_data.dart';
import 'package:gruene_app/routing/routes.dart';
import 'package:gruene_app/widget/costume_separated_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyBackground,
      body: CostumeSeparatedList(items: getItems(context)),
    );
  }

  getItems(BuildContext context) {
    return [
      CostumeListItem(
          titel: AppLocalizations.of(context)!.theGruenenTools, bold: true),
      CostumeListItem(
          titel: AppLocalizations.of(context)!.travelExpenses,
          iconTralling: Icons.arrow_forward_ios),
      const CostumeListItem(
        titel: "How to's",
        iconTralling: Icons.arrow_forward_ios,
      ),
      CostumeListItem(
        titel: AppLocalizations.of(context)!.applications,
        iconTralling: Icons.arrow_forward_ios,
      ),
      CostumeListItem(
        titel: AppLocalizations.of(context)!.membercardMenuTitel,
        iconTralling: Icons.arrow_forward_ios,
        spaceBetween: true,
        linksTo: memberCard,
      ),
      CostumeListItem(titel: AppLocalizations.of(context)!.account, bold: true),
      CostumeListItem(
        titel: AppLocalizations.of(context)!.profile,
        iconTralling: Icons.arrow_forward_ios,
        linksTo: profileScreenName,
      ),
      CostumeListItem(
        titel: AppLocalizations.of(context)!.settings,
        iconTralling: Icons.arrow_forward_ios,
      )
    ];
  }
}
