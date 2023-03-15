import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/constants/layout.dart';
import 'package:gruene_app/net/profile/bloc/profile_bloc.dart';

class MultiModalSelect extends StatefulWidget {
  final List<String> values;
  final void Function(String value) onAddValue;
  final void Function(int selectedFavItemIndex) onSaveValues;

  const MultiModalSelect({
    super.key,
    required this.values,
    required this.onAddValue,
    required this.onSaveValues,
  });

  @override
  State<MultiModalSelect> createState() => _MultiModalSelectState();
}

class _MultiModalSelectState extends State<MultiModalSelect> {
  late TextEditingController textEditControler;
  late FixedExtentScrollController scrollController;
  int selectedItem = 0;

  @override
  void initState() {
    super.initState();
    textEditControler = TextEditingController();
    scrollController = FixedExtentScrollController();
    scrollController.addListener(() {
      if (selectedItem != scrollController.selectedItem) {
        setState(() {
          selectedItem = scrollController.selectedItem;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, con) {
      return Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () => context.pop(),
                      child: const Icon(
                        Icons.close_outlined,
                        size: medium2,
                      )),
                  TextButton(
                    style: ButtonStyle(
                      textStyle: MaterialStatePropertyAll(
                        Theme.of(context)
                            .primaryTextTheme
                            .labelLarge
                            ?.copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
                    onPressed: () => widget.onSaveValues(selectedItem),
                    child: const Text(
                      'Speichern',
                    ),
                  )
                ],
              ),
              Text(
                'Wähle dein Favorit',
                style: Theme.of(context).primaryTextTheme.displaySmall,
              ),
              SizedBox(
                height: con.maxHeight / 100 * 16,
                child: ListWheelScrollView(
                    itemExtent: 40,
                    controller: scrollController,
                    clipBehavior: Clip.antiAlias,
                    diameterRatio: 1.8,
                    children: [
                      ...widget.values.map(
                        (text) {
                          final isSelected =
                              widget.values.indexOf(text) == selectedItem;
                          final color = isSelected
                              ? Theme.of(context).colorScheme.secondary
                              : Colors.black;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isSelected) ...[
                                Icon(Icons.check_outlined,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ],
                              Text(
                                text,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .displaySmall
                                    ?.copyWith(color: color),
                              ),
                            ],
                          );
                        },
                      ),
                    ]),
              ),
              const Divider(),
              Text(
                'Neue Nummer eintragen',
                style: Theme.of(context).primaryTextTheme.displaySmall,
              ),
              const SizedBox(
                height: medium1,
              ),
              TextField(
                controller: textEditControler,
                keyboardType: TextInputType.number,
                onSubmitted: (value) {
                  setState(() {
                    selectedItem = 0;
                    scrollController.animateTo(0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.linear);
                    textEditControler.clear();
                  });
                  widget.onAddValue(value);
                },
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: 'Telefonnummer',
                  border: OutlineInputBorder(),
                  hintText: 'Enter a search term',
                ),
              ),
              const SizedBox(
                height: medium1,
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    textEditControler.dispose();
    super.dispose();
  }
}
