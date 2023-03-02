import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:gruene_app/net/onboarding/data/subject.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    hintText: AppLocalizations.of(context)!.subjectSearchHint,
                    suffixIcon: IconButton(
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
                        icon: const Icon(Icons.search)),
                    hintStyle: Theme.of(context).textTheme.bodyMedium!
                      ..copyWith(color: Colors.grey))),
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
              double fontSize =
                  con.maxHeight / factor > 12 ? 12 : con.maxHeight / factor;
              return AzListView(
                itemScrollController: itemScrollController,
                data: subjectList,
                hapticFeedback: true,
                indexBarItemHeight: con.maxHeight / factor,
                indexBarAlignment: Alignment.topRight,
                indexBarOptions:
                    IndexBarOptions(textStyle: TextStyle(fontSize: fontSize)),
                physics: const BouncingScrollPhysics(),
                itemCount: subjectList.length,
                susItemBuilder: (context, index) {
                  var model = subjectList[index];
                  return getSusItem(context, model.getSuspensionTag());
                },
                susItemHeight: 36,
                itemBuilder: (context, index) {
                  var subject = subjectList[index];
                  var name = subject.name;
                  return ListTile(
                    title: Text(name),
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: subject.checked
                          ? const Icon(Icons.check)
                          : const Icon(Icons.add),
                    ),
                    onTap: () {
                      setState(() {
                        if (subject.checked) {
                          widget.onSelect(subject, false);
                        } else {
                          widget.onSelect(subject, true);
                        }
                      });
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
}
