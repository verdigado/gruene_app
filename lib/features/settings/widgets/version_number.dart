import 'package:flutter/material.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/i18n/translations.g.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionNumber extends StatelessWidget {
  const VersionNumber({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Text(
              t.settings.version(version: '${snapshot.data!.version} (${snapshot.data!.buildNumber})'),
              style: theme.textTheme.bodyMedium!.apply(color: ThemeColors.textDisabled),
            ),
          );
        }
        return Container();
      },
    );
  }
}
