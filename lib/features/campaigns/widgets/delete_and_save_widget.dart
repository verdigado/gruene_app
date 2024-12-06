import 'package:flutter/material.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class DeleteAndSaveWidget extends StatelessWidget {
  final void Function() onDelete;
  final void Function() onSave;

  const DeleteAndSaveWidget({
    super.key,
    required this.onDelete,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(right: 20),
          child: ElevatedButton(
            onPressed: onDelete,
            style: ElevatedButton.styleFrom(
              foregroundColor: ThemeColors.textWarning,
              backgroundColor: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
                side: BorderSide(
                  color: ThemeColors.textWarning,
                ),
              ),
            ),
            child: Text(
              t.campaigns.deleteEntry.label,
              style: theme.textTheme.titleSmall?.apply(color: ThemeColors.textWarning),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: onSave,
            child: Text(
              t.common.actions.save,
              textAlign: TextAlign.right,
              style: theme.textTheme.titleMedium,
            ),
          ),
        ),
      ],
    );
  }
}
