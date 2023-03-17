import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/constants/layout.dart';
import 'package:gruene_app/widget/filled_text_field.dart';

class MultiModalSelect extends StatefulWidget {
  final List<String> values;
  final void Function(String value) onAddValue;
  final void Function(int selectedFavItemIndex) onSaveValues;
  final bool Function(String? value) validate;
  final TextInputType? textInputType;
  final String? initalTextinputValue;
  final String inputHeadline;
  final String? inputHint;
  final String? inputLabel;

  const MultiModalSelect({
    super.key,
    required this.values,
    required this.onAddValue,
    required this.onSaveValues,
    this.initalTextinputValue,
    required this.validate,
    this.textInputType,
    required this.inputHeadline,
    this.inputHint,
    this.inputLabel,
  });

  @override
  State<MultiModalSelect> createState() => _MultiModalSelectState();
}

class _MultiModalSelectState extends State<MultiModalSelect> {
  late TextEditingController textEditControler;
  late FixedExtentScrollController scrollController;
  int selectedItem = 0;
  late FocusNode focusNode;
  bool addInitalTextInputValue = true;
  late String? initalTextinputValue;

  @override
  void initState() {
    super.initState();
    textEditControler = TextEditingController();
    focusNode = FocusNode();
    scrollController = FixedExtentScrollController();
    scrollController.addListener(() {
      if (selectedItem != scrollController.selectedItem) {
        setState(() {
          selectedItem = scrollController.selectedItem;
        });
      }
    });

    if (widget.initalTextinputValue != null) {
      initalTextinputValue = '${widget.initalTextinputValue}';
      // Prefill onFocus
      focusNode.addListener(() {
        if (addInitalTextInputValue && focusNode.hasFocus) {
          textEditControler.text = initalTextinputValue!;
          setState(() {
            addInitalTextInputValue = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, con) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                        onTap: () => context.pop(),
                        child: const Icon(
                          Icons.close_outlined,
                          size: medium2,
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: selectedItem > 0
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.start,
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Text(
                      'Wähle dein Favorit',
                      style: Theme.of(context).primaryTextTheme.displaySmall,
                    ),
                    if (selectedItem > 0) ...[
                      TextButton(
                        style: ButtonStyle(
                          textStyle: MaterialStatePropertyAll(
                            Theme.of(context)
                                .primaryTextTheme
                                .labelLarge
                                ?.copyWith(
                                    decoration: TextDecoration.underline),
                          ),
                        ),
                        onPressed: () => widget.onSaveValues(selectedItem),
                        child: const Text(
                          'Als Favorit markieren',
                        ),
                      )
                    ]
                  ],
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
                  widget.inputHeadline,
                  style: Theme.of(context).primaryTextTheme.displaySmall,
                ),
                const SizedBox(
                  height: medium1,
                ),
                FilledTextField(
                  textEditingController: textEditControler,
                  focusNode: focusNode,
                  keyboardType: widget.textInputType,
                  onSubmitted: (value) {
                    submit(value);
                  },
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add_outlined),
                    onPressed: () {
                      submit(textEditControler.text);
                    },
                  ),
                  labelText: widget.inputLabel,
                  hintText: widget.inputHint,
                ),
                const SizedBox(
                  height: medium1,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void submit(String value) {
    if (widget.validate(value)) {
      setState(() {
        selectedItem = 0;
        scrollController.animateTo(0,
            duration: const Duration(milliseconds: 500), curve: Curves.linear);
        addInitalTextInputValue = true;
        focusNode.unfocus();
        textEditControler.clear();
      });
      widget.onAddValue(value);
    }
  }

  bool validate(String value) {
    return value.isNotEmpty &&
        !widget.values.contains(value) &&
        value.startsWith('+') &&
        value.length <= 16;
  }

  @override
  void dispose() {
    scrollController.dispose();
    textEditControler.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
