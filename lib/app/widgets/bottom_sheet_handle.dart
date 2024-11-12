import 'package:flutter/material.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/features/login/widgets/discover_app_bottom_sheet.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class BottomSheetHandle extends StatefulWidget {
  const BottomSheetHandle({super.key});

  @override
  State<BottomSheetHandle> createState() => _BottomSheetHandleState();
}

class _BottomSheetHandleState extends State<BottomSheetHandle> {
  bool _isOpened = false;

  void closeBottomSheet() {
    setState(() {
      _isOpened = false;
    });
  }

  void openBottomSheet(BuildContext context) {
    Scaffold.of(context).showBottomSheet((BuildContext context) => DiscoverAppBottomSheet(),
      constraints: BoxConstraints(minHeight: 0.25),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 48,
              height: 6,
              decoration: BoxDecoration(
                color: ThemeColors.textLight,
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () => openBottomSheet(context),
                  child: Text(
                    t.login.discover,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                Text(t.login.discoverDescription, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
