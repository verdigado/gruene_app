import 'package:flutter/material.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class FilterOption {
  final String title;
  final Widget widget;

  const FilterOption({required this.title, required this.widget});
}

class FilterTitle extends StatelessWidget {
  final String title;

  const FilterTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 52,
      color: theme.colorScheme.surfaceDim,
      padding: EdgeInsets.only(left: 24, top: 12, right: 24, bottom: 6),
      alignment: Alignment.centerLeft,
      child: Text(title, style: theme.textTheme.titleMedium),
    );
  }
}

class FilterContainer extends StatelessWidget {
  final Widget child;

  const FilterContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.symmetric(horizontal: BorderSide(color: ThemeColors.textLight, width: 1)),
      ),
      child: child,
    );
  }
}

class ChoiceChipsFilter extends StatelessWidget {
  final void Function(String? selected) selectFilter;
  final List<String> filterOptions;
  final String? selectedFilter;

  const ChoiceChipsFilter({
    super.key,
    required this.selectFilter,
    required this.filterOptions,
    required this.selectedFilter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(width: 16),
          ...filterOptions.map(
            (filter) => Container(
              margin: EdgeInsets.only(right: 16),
              child: ChoiceChip(
                onSelected: (selected) => selectFilter(selected ? filter : null),
                selected: filter == selectedFilter,
                label: Text(
                  filter,
                  style: theme.textTheme.bodyMedium
                      ?.apply(color: filter == selectedFilter ? theme.colorScheme.surface : ThemeColors.text),
                ),
                backgroundColor: theme.colorScheme.surfaceDim,
                selectedColor: theme.colorScheme.secondary,
                checkmarkColor: theme.colorScheme.surface,
                shape: StadiumBorder(),
                side: BorderSide(color: theme.colorScheme.surfaceDim),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DateRangeFilter extends StatelessWidget {
  final void Function(DateTime? set) setStartDate;
  final void Function(DateTime? selected) setEndDate;
  final DateTime? startDate;
  final DateTime? endDate;

  const DateRangeFilter({
    super.key,
    required this.setStartDate,
    required this.setEndDate,
    this.startDate,
    this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        SizedBox(width: 16),
        Text(t.common.dateFrom),
        SizedBox(width: 16),
        // CalendarDatePicker(
        //   initialDate: DateTime(DateTime.now().year),
        //   firstDate: DateTime(1980),
        //   lastDate: DateTime.now(),
        //   onDateChanged: setStartDate,
        // ),
        SizedBox(width: 16),
        Text(t.common.dateUntil),
        SizedBox(width: 16),
        // CalendarDatePicker(
        //   initialDate: DateTime.now(),
        //   firstDate: DateTime(1980),
        //   lastDate: DateTime.now(),
        //   onDateChanged: setStartDate,
        // ),
        SizedBox(width: 16),
      ],
    );
  }
}

class FilterDropdown extends StatelessWidget {
  final List<String> categories;
  final divisions = [
    t.common.divisionBundesverband,
    t.common.divisionLandesverband,
    t.common.divisionKreisverband,
    t.common.divisionOrtsverband,
  ];

  FilterDropdown({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilterTitle(title: t.news.divisions),
        FilterContainer(
          child: ChoiceChipsFilter(selectFilter: (_) => null, filterOptions: divisions, selectedFilter: divisions[1]),
        ),
        FilterTitle(title: t.news.categories),
        FilterContainer(
          child: ChoiceChipsFilter(selectFilter: (_) => null, filterOptions: categories, selectedFilter: categories[2]),
        ),
        FilterTitle(title: t.news.publicationDate),
        FilterContainer(child: DateRangeFilter(setStartDate: (_) => null, setEndDate: (_) => null)),
      ],
    );
  }
}
