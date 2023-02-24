import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/link.dart';

class DatImpContainer extends StatelessWidget {
  const DatImpContainer({super.key});
// TODO: Make Links(2) work
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Link(
              target: LinkTarget.blank,
              uri: Uri(
                  scheme: 'https',
                  host: 'www.gruene.de',
                  path: '/service/datenschutz'),
              builder: (context, followLink) {
                return GestureDetector(
                  onTap: followLink,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!.privacyPolicy,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                );
              }),
          const SizedBox(width: 10),
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          const SizedBox(width: 10),
          Link(
            target: LinkTarget.blank,
            uri: Uri(
                scheme: 'https',
                host: 'www.gruene.de',
                path: '/service/impressum'),
            builder: (context, followLink) {
              return GestureDetector(
                onTap: followLink,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.imprint,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
