import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        return Column(
          children: [
            const Divider(
              height: 0,
            ),
            if (items[index].spaceBetween) ...[
              const SizedBox(
                height: 20,
              )
            ]
          ],
        );
      },
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            if (index == 0) ...[header ?? Container()],
            items[index]
          ],
        );
      },
    );
  }
}

class CostumeListItem extends StatelessWidget {
  final String titel;
  final IconData? iconLeading;
  final bool spaceBetween;
  final IconData? iconTralling;
  final bool bold;
  final String? linksTo;

  const CostumeListItem({
    super.key,
    required this.titel,
    this.iconLeading,
    this.iconTralling,
    this.spaceBetween = false,
    this.bold = false,
    this.linksTo,
  });

  @override
  Widget build(BuildContext context) {
    if (iconLeading != null) {
      return ListTile(
        leading: Icon(iconLeading, color: Theme.of(context).primaryColor),
        title: Text(titel),
        trailing: Icon(iconTralling),
        tileColor: Colors.white,
        onTap: () => navigate(context, linksTo),
      );
    } else {
      return ListTile(
        title: Text(
          titel,
          style:
              TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal),
        ),
        trailing: Icon(iconTralling),
        tileColor: Colors.white,
        onTap: () => navigate(context, linksTo),
      );
    }
  }

  void navigate(BuildContext context, String? linksTo) {
    if (linksTo != null && linksTo.isNotEmpty) {
      context.push(linksTo);
    }
  }
}
