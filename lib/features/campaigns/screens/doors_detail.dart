import 'package:flutter/material.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/features/campaigns/models/doors/door_detail_model.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class DoorsDetail extends StatelessWidget {
  final DoorDetailModel poi;

  const DoorsDetail({super.key, required this.poi});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelTextStyle = theme.textTheme.labelSmall?.apply(color: Colors.black);
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    t.campaigns.door.openedDoors,
                    style: labelTextStyle,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.only(left: 6),
                    child: Text(
                      poi.openedDoors.toString(),
                      style: labelTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1.5,
            color: ThemeColors.textLight,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    t.campaigns.door.closedDoors,
                    style: labelTextStyle,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.only(left: 6),
                    child: Text(
                      poi.closedDoors.toString(),
                      style: labelTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1.5, color: ThemeColors.textLight),
          Container(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text(
              t.campaigns.posters.info_details,
              style: theme.textTheme.labelSmall?.apply(color: Colors.black, fontWeightDelta: 2),
            ),
          ),
        ],
      ),
    );
  }
}
