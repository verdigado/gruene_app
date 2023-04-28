import 'package:flutter/material.dart';
import 'package:gruene_app/constants/theme_data.dart';

/// ButtonGroupNextPrevious:
/// A group of buttons containing a next and previous button

class ButtonGroupNextPrevious extends StatelessWidget {
  final VoidCallback? next;
  final String nextText;
  final VoidCallback? previous;
  final String previousText;
  final bool onlyNext;

  const ButtonGroupNextPrevious({
    Key? key,
    this.next,
    this.nextText = 'Next',
    this.previous,
    this.previousText = 'Previous',
    this.onlyNext = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
            key: const Key('ButtonGroupNextButton'),
            onPressed: next,
            child: Text(nextText,
                style: textTheme.labelLarge?.copyWith(color: Colors.white))),
        const SizedBox(height: 10),
        if (!onlyNext) ...[
          ElevatedButton(
            key: const Key('ButtonGroupPreviousButton'),
            onPressed: previous,
            style: grayButtonStyle,
            child: Text(previousText,
                style: textTheme.labelLarge?.copyWith(color: darkGrey)),
          ),
        ],
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
