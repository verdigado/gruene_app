import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gruene_app/app/theme/theme.dart';

class TextInputField extends StatefulWidget {
  final String labelText;

  final double? width;

  final TextEditingController? textController;

  final Color? borderColor;

  final bool onlyAllowNumbers;

  const TextInputField({
    required this.labelText,
    this.width,
    this.textController,
    this.borderColor,
    this.onlyAllowNumbers = false,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  @override
  Widget build(BuildContext context) {
    List<TextInputFormatter>? formatters;
    TextInputType? inputType;
    if (widget.onlyAllowNumbers) {
      inputType = TextInputType.number;
      formatters = <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ];
    }
    final theme = Theme.of(context);
    final inputBorder = switch (widget.borderColor) {
      (null) => null,
      (_) => Border.all(color: widget.borderColor!, width: 1),
    };
    return Container(
      width: widget.width,
      // padding: EdgeInsets.symmetric(vertical: 6, horizontal: 9),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: inputBorder,
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextFormField(
        controller: widget.textController,
        keyboardType: inputType,
        inputFormatters: formatters,
        style: theme.textTheme.bodyMedium?.apply(color: ThemeColors.text),
        decoration: InputDecoration(
          labelText: widget.labelText,
          border: InputBorder.none,
          labelStyle: theme.textTheme.labelMedium?.apply(color: ThemeColors.textDisabled),
          floatingLabelStyle: theme.textTheme.labelSmall?.apply(color: ThemeColors.textDisabled),
        ),
      ),
    );
  }
}
