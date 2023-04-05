import 'package:flutter/material.dart';
import 'package:gruene_app/constants/theme_data.dart';

/// ButtonGroupNextPrevious:
/// A group of buttons containing a next and previous button

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
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 16,
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
        if (!onlyNext) ...[
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: previous,
            style: grayButtonStyle,
            child: Text(previousText,
                style: textTheme.labelLarge?.copyWith(color: darkGrey)),
          ),
        ],
        const SizedBox(height: 32),
      ],
    );
  }
}
