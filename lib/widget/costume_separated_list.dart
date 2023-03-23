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
        if (!items[index].divider) return Container();
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
  final String? subtitel;
  final bool divider;
  final WidgetBuilder? modalBuilder;

  final Future Function()? modalSheet;

  const CostumeListItem({
    super.key,
    required this.titel,
    this.modalBuilder,
    this.subtitel,
    this.iconLeading,
    this.iconTralling,
    this.spaceBetween = false,
    this.bold = false,
    this.linksTo,
    this.divider = true,
    this.modalSheet,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: iconLeading != null
          ? Icon(iconLeading, color: Theme.of(context).primaryColor)
          : null,
      title: Text(
        titel,
        style: subtitel == null
            ? TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)
            : const TextStyle(color: Colors.grey),
      ),
      subtitle: subtitel != null
          ? Text(
              subtitel!,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            )
          : null,
      trailing: Icon(iconTralling),
      tileColor: Colors.white,
      onTap: linksTo != null || modalSheet != null
          ? () => navigate(context, linksTo)
          : null,
    );
  }

  void navigate(BuildContext context, String? linksTo) {
    if (modalSheet != null) {
      modalSheet?.call();
      return;
    }
    if (linksTo != null && linksTo.isNotEmpty) {
      context.pushNamed(linksTo);
    }
  }
}
