import 'package:flutter/widgets.dart';

class ModalTopLine extends StatelessWidget {
  final Color color;

  const ModalTopLine({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 5,
      decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(12.0))),
    );
  }
}
