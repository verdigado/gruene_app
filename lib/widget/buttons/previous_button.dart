import 'package:flutter/material.dart';

import 'package:gruene_app/constants/theme_data.dart';

class PreviousButton extends StatelessWidget {
  // click event function
  final VoidCallback onClick;

  // constructor
  const PreviousButton({
    super.key,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        IconButton(
          icon: const Icon(
            Icons.keyboard_backspace,
            color: darkGrey,
            size: 50,
          ),
          onPressed: onClick,
        ),
      ],
    );
  }
}
