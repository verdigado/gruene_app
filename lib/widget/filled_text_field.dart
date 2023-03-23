import 'package:flutter/material.dart';

// Costume TextField for our design needs
class FilledTextField extends StatefulWidget {
  const FilledTextField(
      {Key? key,
      required this.textEditingController,
      this.style,
      this.hintText,
      this.hintTextStyle,
      this.label,
      this.labelText,
      this.labelTextStyle,
      this.floatingLabelBehavior,
      this.suffix,
      this.suffixIcon,
      this.prefix,
      this.height,
      this.contentPadding,
      this.borderRadius,
      this.fillColor,
      this.keyboardType,
      this.onSubmitted,
      this.focusNode})
      : super(key: key);

  final TextEditingController textEditingController;

  /// The style to use for the text being edited.
  final TextStyle? style;

  final Widget? label;

  /// Optional text that describes the input field.
  final String? labelText;

  /// If null, defaults to a value derived from the base TextStyle for the input
  /// field and the current Theme.
  final TextStyle? labelTextStyle;

  /// Text that suggests what sort of input the field accepts.
  final String? hintText;

  /// If null, defaults to a value derived from the base TextStyle for the input
  /// field and the current Theme.
  final TextStyle? hintTextStyle;

  /// If null, InputDecorationTheme.floatingLabelBehavior will be used.
  final FloatingLabelBehavior? floatingLabelBehavior;

  /// Optional widget to place on the line before the input.
  final Widget? prefix;

  /// Optional widget to place on the line after the input.
  final Widget? suffix;

  /// If null, defaults to 48px in order to comply with Material spec's minimum
  /// interactive size guideline
  final double? height;

  /// The padding for the input decoration's container. Defaults to 10px horizontally
  /// and 10px vertically
  final EdgeInsetsGeometry? contentPadding;

  /// If non-null, the corners of this box are rounded by this [BorderRadius]
  /// A [borderRadius] can only be given for a uniform Border.
  ///
  /// Default border radius is 8px
  final BorderRadiusGeometry? borderRadius;

  /// The color for the container background
  final Color? fillColor;

  final TextInputType? keyboardType;
  final void Function(String value)? onSubmitted;

  final Widget? suffixIcon;
  final FocusNode? focusNode;

  @override
  State<FilledTextField> createState() => _FilledTextField();
}

class _FilledTextField extends State<FilledTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.fillColor,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).colorScheme.secondary),
          ),
          child: TextField(
            focusNode: widget.focusNode,
            controller: widget.textEditingController,
            keyboardType: widget.keyboardType,
            textAlignVertical: TextAlignVertical.center,
            style: widget.style,
            onSubmitted: widget.onSubmitted,
            decoration: InputDecoration(
              suffixIcon: widget.suffixIcon,
              suffix: widget.suffix,
              prefix: widget.prefix,
              contentPadding: widget.contentPadding ??
                  const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
              labelText: widget.labelText,
              labelStyle: widget.labelTextStyle,
              hintText: widget.hintText,
              hintStyle: widget.hintTextStyle,
              floatingLabelBehavior: widget.floatingLabelBehavior,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
