import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/routing/routes.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  static const items = [
    CostumeListItem(titel: 'Persönliches Mitgliedsprofil'),
    CostumeListItem(titel: 'Sichtbarkeit Deines öffentlichen Profils'),
    CostumeListItem(titel: 'Mitgliederdaten'),
    CostumeListItem(titel: 'Gruppen', density: true),
    CostumeListItem(titel: 'Anleitung'),
    CostumeListItem(titel: 'Hilfe und Kontakt', density: true),
    CostumeListItem(titel: 'Impressum'),
    CostumeListItem(titel: 'Datenschutz'),
    CostumeListItem(titel: 'Passwort und Benutzername ändern', density: true),
    CostumeListItem(titel: 'Ausloggen', density: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(247, 247, 247, 1),
        body: CostumeSeparatedList(
          items: items,
          header:
              ProfileListViewHeader(onTap: () => context.push(profileDetail)),
        ));
  }
}

class ProfileListViewHeader extends StatelessWidget {
  final void Function() onTap;

  const ProfileListViewHeader({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8, top: 8),
          child: Text(
            'Profil',
            style: Theme.of(context).primaryTextTheme.displaySmall,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: InkWell(
            onTap: () => onTap(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 24,
                  child: Text('DP'),
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dominik Peters',
                        style: Theme.of(context).primaryTextTheme.displaySmall),
                    TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () => onTap(),
                        child: Column(
                          children: const [Text('Profil anzeigen')],
                        )),
                    const SizedBox(
                      height: 16,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CostumeSeparatedList extends StatelessWidget {
  final Widget? header;

  const CostumeSeparatedList({
    super.key,
    required this.items,
    this.header,
  });

  final List<CostumeListItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        final item = items[index];

        return Column(
          children: [
            const Divider(
              height: 0,
            ),
            if (item.density) ...[
              const SizedBox(
                height: 20,
              )
            ]
          ],
        );
      },
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return Column(
          children: [
            if (index == 0) ...[header ?? Container()],
            ListTile(
              leading:
                  Icon(item.iconLeading, color: Theme.of(context).primaryColor),
              title: Text(item.titel),
              trailing: Icon(item.iconTralling),
              tileColor: Colors.white,
            ),
          ],
        );
      },
    );
  }
}

class CostumeListItem {
  final String titel;
  final IconData iconLeading;
  final bool density;
  final IconData iconTralling;

  const CostumeListItem(
      {required this.titel,
      this.iconLeading = Icons.star_border_outlined,
      this.iconTralling = Icons.arrow_forward_ios,
      this.density = false});
}
