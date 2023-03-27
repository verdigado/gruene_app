import 'package:flutter/material.dart';
import 'package:gruene_app/constants/theme_data.dart';

class ButtonGroupNextPrevious extends StatelessWidget {
  final VoidCallback? next;
  final String nextText;
  final VoidCallback? previous;
  final String previousText;

  final Key? buttonNextKey;
  final bool onlyNext;

  const ButtonGroupNextPrevious({
    Key? key,
    this.next,
    this.nextText = 'Next',
    this.previous,
    this.previousText = 'Previous',
    this.buttonNextKey,
    this.onlyNext = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 1),
        Container(
          height: 10,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                  width: 1, color: lightGrey, style: BorderStyle.solid),
            ),
          ),
        ),
        ElevatedButton(
            key: buttonNextKey,
            onPressed: next,
            child: Text(nextText,
                style: textTheme.labelLarge?.copyWith(color: Colors.white))),
        const SizedBox(height: 10),
        if (!onlyNext) ...[
          ElevatedButton(
            onPressed: previous,
            style: grayButtonStyle,
            child: Text(previousText,
                style: textTheme.labelLarge?.copyWith(color: darkGrey)),
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}
