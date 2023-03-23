import 'package:flutter/material.dart';
import 'package:gruene_app/constants/theme_data.dart';

class ButtonGroupNextPrevious extends StatefulWidget {
  final VoidCallback? next;
  final String nextText;
  final VoidCallback? previous;
  final String previousText;

  const ButtonGroupNextPrevious({
    Key? key,
    this.next,
    this.nextText = 'Next',
    this.previous,
    this.previousText = 'Previous',
  }) : super(key: key);

  @override
  State<ButtonGroupNextPrevious> createState() =>
      _ButtonGroupNextPreviousState();
}

class _ButtonGroupNextPreviousState extends State<ButtonGroupNextPrevious> {
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
            onPressed: widget.next,
            child: Text(widget.nextText,
                style: textTheme.labelLarge?.copyWith(color: Colors.white))),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: widget.previous,
          style: grayButtonStyle,
          child: Text(widget.previousText,
              style: textTheme.labelLarge?.copyWith(color: darkGrey)),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}