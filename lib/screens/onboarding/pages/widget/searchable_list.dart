import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

import 'package:gruene_app/constants/theme_data.dart';
// ignore: depend_on_referenced_packages
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SearchableList extends StatefulWidget {
  final void Function(SearchableListItem item, bool check) onSelect;

  final List<SearchableListItem> searchableItemList;

  final bool showIndexbar;

  const SearchableList({
    Key? key,
    required this.searchableItemList,
    required this.onSelect,
    this.showIndexbar = true,
  }) : super(key: key);

  @override
  State<SearchableList> createState() => _SearchableListState();
}

class _SearchableListState extends State<SearchableList> {
  late ItemScrollController itemScrollController;
  String searchPattern = '';
  // Size of Indexbar
  final int factor = 28;
  bool clearable = false;

  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    itemScrollController = ItemScrollController();
    textEditingController = TextEditingController();
    textEditingController.addListener(() {
      setState(() {
        clearable = textEditingController.text.length > 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              controller: textEditingController,
              style: DefaultTextStyle.of(context)
                  .style
                  .copyWith(fontStyle: FontStyle.italic),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0),
                enabledBorder:
                    const OutlineInputBorder(borderSide: BorderSide.none),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                filled: true,
                fillColor: unfocusedGrey,
                hintText: AppLocalizations.of(context)!.subjectSearchHint,
                prefixIcon: IconButton(
                  onPressed: () {
                    var suggestion = extractTop(
                      query: searchPattern,
                      choices:
                          widget.searchableItemList.map((e) => e.name).toList(),
                      limit: 4,
                      cutoff: 50,
                    ).map((e) => e.choice);
                    var res = widget.searchableItemList.indexWhere((element) =>
                        element.name.toLowerCase() ==
                        suggestion.first.toLowerCase());
                    FocusScope.of(context).unfocus();
                    itemScrollController.jumpTo(index: res);
                  },
                  icon: const Icon(Icons.search),
                ),
                suffixIcon: Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: clearable,
                  child: InkWell(
                    onTap: () {
                      textEditingController.clear();
                      searchPattern = '';
                    },
                    child: Transform.rotate(
                      angle: 0.8,
                      child: const Icon(Icons.add_circle),
                    ),
                  ),
                ),
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.grey),
              ),
            ),
            suggestionsCallback: (pattern) {
              if (pattern.isEmpty || pattern.length < 2) return [];

              return extractTop(
                query: pattern,
                choices: widget.searchableItemList.map((e) => e.name).toList(),
                limit: 4,
                cutoff: 50,
              ).map((e) => e.choice);
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text("$suggestion"),
              );
            },
            hideOnEmpty: true,
            onSuggestionSelected: (suggestion) {
              var matchIndex = widget.searchableItemList.indexWhere(
                (element) =>
                    element.name.toLowerCase() == "$suggestion".toLowerCase(),
              );
              itemScrollController.jumpTo(
                index: matchIndex,
              );
              textEditingController.text = '$suggestion';
            },
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (ctx, con) {
              double fontSize =
                  con.maxHeight / factor > 12 ? 12 : con.maxHeight / factor;
              return AzListView(
                itemScrollController: itemScrollController,
                data: widget.searchableItemList,
                hapticFeedback: true,
                indexBarItemHeight: con.maxHeight / factor,
                indexBarAlignment: Alignment.topRight,
                indexBarOptions:
                    IndexBarOptions(textStyle: TextStyle(fontSize: fontSize)),
                physics: const BouncingScrollPhysics(),
                itemCount: widget.searchableItemList.length,
                indexBarData: widget.showIndexbar ? kIndexBarData : [],
                susItemBuilder: widget.showIndexbar
                    ? (context, index) {
                        var model = widget.searchableItemList[index];
                        return getSusItem(context, model.getSuspensionTag());
                      }
                    : null,
                susItemHeight: 36,
                itemBuilder: (context, index) {
                  var item = widget.searchableItemList[index];
                  var name = item.name;
                  return ListTile(
                    title: Text(name),
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: item.checked
                          ? Icon(
                              Icons.check_circle,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 30,
                            )
                          : Icon(
                              Icons.add,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 30,
                            ),
                    ),
                    onTap: () {
                      if (item.checked) {
                        widget.onSelect(item, false);
                      } else {
                        widget.onSelect(item, true);
                      }
                    },
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }

  Widget getSusItem(BuildContext context, String tag, {double susHeight = 40}) {
    return Container(
      height: susHeight,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 16.0),
      color: Theme.of(context).primaryColorLight,
      alignment: Alignment.centerLeft,
      child: Text(
        tag,
        softWrap: false,
        style: const TextStyle(
            fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}

class SearchableListItem extends ISuspensionBean {
  final String id;
  final String name;
  final bool checked;

  SearchableListItem({
    required this.id,
    required this.name,
    required this.checked,
  });

  @override
  String getSuspensionTag() {
    if (name.isEmpty) return '#';
    return name.characters.first.toUpperCase();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchableListItem &&
        other.id == id &&
        other.name == name &&
        other.checked == checked;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ checked.hashCode;
}
