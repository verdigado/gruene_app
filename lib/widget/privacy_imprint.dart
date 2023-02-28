import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gruene_app/common/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class DatImpContainer extends StatelessWidget {
  DatImpContainer({super.key});

  final Uri _urlImprint = Uri.parse('https://www.gruene.de/service/impressum');
  final Uri _urlPrivacy =
      Uri.parse('https://www.gruene.de/service/datenschutz');

  Future<void> _launchUrl(BuildContext context, Uri url) async {
    if (!await launchUrl(url)) {
      logger.e('Fail to Launch Url $url');
    }
  }

  /// TODO: refactior TextButton to Link
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () => _launchUrl(context, _urlPrivacy),
            child: Text(AppLocalizations.of(context)!.privacyPolicy,
                style: Theme.of(context).primaryTextTheme.bodySmall),
          ),
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
          TextButton(
            onPressed: () => _launchUrl(context, _urlImprint),
            child: Text(AppLocalizations.of(context)!.imprint,
                style: Theme.of(context).primaryTextTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}
