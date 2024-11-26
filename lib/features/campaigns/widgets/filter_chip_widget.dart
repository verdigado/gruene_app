import 'package:flutter/material.dart';
import 'package:gruene_app/app/theme/theme.dart';

class FilterChipModel {
  final String _text;
  final bool _isEnabled;

  const FilterChipModel(this._text, this._isEnabled);
}

class FilterChipCampaign extends StatefulWidget {
  final List<FilterChipModel> filterOptions;
  final Map<String, List<String>> filterExclusions;

  const FilterChipCampaign(
    this.filterOptions,
    this.filterExclusions, {
    super.key,
  });

  @override
  State<FilterChipCampaign> createState() => _FilterChipCampaignState();
}

class _FilterChipCampaignState extends State<FilterChipCampaign> {
  Set<FilterChipModel> currentFilters = <FilterChipModel>{};

  void unselect(String itemLabel) {
    currentFilters.removeWhere((z) => z._text == itemLabel);
  }

  void unselectExclusions(FilterChipModel item) {
    var filterExclusions = widget.filterExclusions;
    filterExclusions.entries.where((x) => x.key == item._text).map((x) => x.value).forEach((x) => x.forEach(unselect));
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Wrap(
              spacing: 15.0,
              children: widget.filterOptions.map((filterItem) {
                return FilterChip(
                  label: Text(filterItem._text),
                  backgroundColor: ThemeColors.background,
                  selectedColor: ThemeColors.primary,
                  padding: EdgeInsets.zero,
                  side: filterItem._isEnabled
                      ? BorderSide(color: ThemeColors.primary, width: 2)
                      : BorderSide(color: ThemeColors.textDisabled, width: 1),
                  shape: StadiumBorder(),
                  selected: currentFilters.contains(filterItem),
                  showCheckmark: false,
                  labelStyle: TextStyle(
                    color: filterItem._isEnabled ? ChipLabelColor() : ThemeColors.textDisabled,
                  ),
                  onSelected: (bool selected) {
                    setState(() {
                      if (!filterItem._isEnabled) return;
                      if (selected) {
                        unselectExclusions(filterItem);
                        currentFilters.add(filterItem);
                      } else {
                        currentFilters.remove(filterItem);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class ChipLabelColor extends Color implements WidgetStateColor {
  const ChipLabelColor() : super(_default);

  static const int _default = 0xFF000000;

  @override
  Color resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return Colors.white; // Selected text color
    }
    return Colors.black; // normal text color
  }
}
