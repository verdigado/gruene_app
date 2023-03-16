import 'package:flutter/material.dart';
import 'package:gruene_app/routing/routes.dart';
import 'package:gruene_app/widget/costume_separated_list.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  static const items = [
    CostumeListItem(titel: 'Die Grünen Tools', bold: true),
    CostumeListItem(
        titel: 'Reisekosten', iconTralling: Icons.arrow_forward_ios),
    CostumeListItem(
      titel: "How to's",
      iconTralling: Icons.arrow_forward_ios,
    ),
    CostumeListItem(
        titel: 'Anwendungen',
        iconTralling: Icons.arrow_forward_ios,
        spaceBetween: true),
    CostumeListItem(titel: 'Konto', bold: true),
    CostumeListItem(
      titel: 'Profil',
      iconTralling: Icons.arrow_forward_ios,
      linksTo: profileScreenName,
    ),
    CostumeListItem(
      titel: 'Einstellungen',
      iconTralling: Icons.arrow_forward_ios,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromRGBO(247, 247, 247, 1),
      body: CostumeSeparatedList(items: items),
    );
  }
}
