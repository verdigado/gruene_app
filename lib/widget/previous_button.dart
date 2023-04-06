import 'package:flutter/material.dart';

import '../constants/theme_data.dart';

class PreviousButton extends StatelessWidget {
  // click event function
  final VoidCallback onClick;

  // button is hidden
  final bool isHidden;

  // constructor
  const PreviousButton({
    super.key,
    required this.onClick,
    this.isHidden = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: !isHidden,
          child: IconButton(
            icon: const Icon(
              Icons.keyboard_backspace,
              color: darkGrey,
              size: 50,
            ),
            onPressed: onClick,
          ),
        ),
      ],
    );
  }
}
