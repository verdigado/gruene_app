import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:gruene_app/screens/customization/data/subject.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

class SubjectList extends StatefulWidget {
  const SubjectList({Key? key, required this.subjectList}) : super(key: key);

  final List<Subject> subjectList;

  @override
  _SubjectListState createState() => _SubjectListState();
}

class _SubjectListState extends State<SubjectList> {
  ItemScrollController? itemScrollController;
  List<String> index = [];

  @override
  void initState() {
    super.initState();
    itemScrollController = ItemScrollController();
    index = widget.subjectList.map((e) => e.name).toList();
    // short alphabetically
    SuspensionUtil.sortListBySuspensionTag(widget.subjectList);
    // create first letter entry
    SuspensionUtil.setShowSuspensionStatus(widget.subjectList);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
                style: DefaultTextStyle.of(context)
                    .style
                    .copyWith(fontStyle: FontStyle.italic),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    hintText: 'Suche',
                    suffixIcon: IconButton(
                        onPressed: () => print('HIHIHI'),
                        icon: const Icon(Icons.search)),
                    hintStyle: Theme.of(context).textTheme.bodyMedium!
                      ..copyWith(color: Colors.grey))),
            suggestionsCallback: (pattern) {
              if (pattern.isEmpty || pattern.length < 2) return [];
              return extractTop(
                query: pattern,
                choices: index,
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
              itemScrollController?.jumpTo(
                index: widget.subjectList.indexWhere(
                  (element) =>
                      element.name.toLowerCase() == "$suggestion".toLowerCase(),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: AzListView(
            itemScrollController: itemScrollController,
            data: widget.subjectList,
            hapticFeedback: true,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.subjectList.length,
            susItemBuilder: (context, index) {
              var model = widget.subjectList[index];
              return getSusItem(context, model.getSuspensionTag());
            },
            susItemHeight: 36,
            itemBuilder: (context, index) {
              var name = widget.subjectList[index].name;
              return ListTile(title: Text(name));
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
