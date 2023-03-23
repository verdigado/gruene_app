import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:gruene_app/constants/layout.dart';
import 'package:gruene_app/net/onboarding/data/subject.dart';
// ignore: depend_on_referenced_packages
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:gruene_app/constants/theme_data.dart';


class SubjectList extends StatefulWidget {
  final void Function(Subject sub, bool check) onSelect;

  final List<Subject> subjectList;

  const SubjectList({
    Key? key,
    required this.subjectList,
    required this.onSelect,
  }) : super(key: key);

  @override
  State<SubjectList> createState() => _SubjectListState();
}

class _SubjectListState extends State<SubjectList> {
  ItemScrollController? itemScrollController;
  List<String> subjectNames = [];
  String searchPattern = '';
  List<Subject> subjectList = [];
  // Size of Indexbar
  final int factor = 28;

  TextEditingController? textEditingController;

  @override
  void initState() {
    super.initState();
    itemScrollController = ItemScrollController();
    textEditingController = TextEditingController();
    subjectList = List.from(widget.subjectList);

    subjectNames = subjectList.map((e) => e.name).toList();
    // short alphabetically
    SuspensionUtil.sortListBySuspensionTag(subjectList);
    // create first letter entry
    SuspensionUtil.setShowSuspensionStatus(subjectList);
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
                      choices: subjectNames,
                      limit: 4,
                      cutoff: 50,
                    ).map((e) => e.choice);
                    var res = subjectList.indexWhere((element) =>
                        element.name.toLowerCase() ==
                        suggestion.first.toLowerCase());
                    FocusScope.of(context).unfocus();
                    itemScrollController?.jumpTo(index: res);
                  },
                  icon: const Icon(Icons.search),
                ),
                suffixIcon: Transform.rotate(
                  angle: 0.8,
                  child: const Icon(Icons.add_circle),
                ),
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.grey),
              ),
            ),
            suggestionsCallback: (pattern) {
              if (pattern.isEmpty || pattern.length < 2) return [];
              searchPattern = pattern;
              return extractTop(
                query: pattern,
                choices: subjectNames,
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
              var matchIndex = subjectList.indexWhere(
                (element) =>
                    element.name.toLowerCase() == "$suggestion".toLowerCase(),
              );
              itemScrollController?.jumpTo(
                index: matchIndex,
              );
              textEditingController?.text = '$suggestion';
            },
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (ctx, con) {
              return ListView(
                children: subjectList
                    .map((e) => ListTile(
                          title: Text(e.name),
                          trailing: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: e.checked
                                ? Icon(
                                    Icons.check_circle,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    size: 30,
                                  )
                                : Icon(
                                    Icons.add,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    size: 30,
                                  ),
                          ),
                          onTap: () {
                            setState(() {
                              if (e.checked) {
                                widget.onSelect(e, false);
                              } else {
                                widget.onSelect(e, true);
                              }
                            });
                          },
                        ))
                    .toList(),
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
}
