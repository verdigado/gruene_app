import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:gruene_app/constants/theme_data.dart';

class DefaultSwitch extends FlutterSwitch {
  const DefaultSwitch({
    super.key,
    required value,
    required onToggle,
    width = 48.0,
    height = 29.0,
    toggleSize = 25.0,
    valueFontSize = 16.0,
    borderRadius = 20.0,
    padding = 4.0,
  }) : super(
          value: value,
          onToggle: onToggle,
          width: width,
          height: height,
          toggleSize: toggleSize,
          valueFontSize: valueFontSize,
          borderRadius: borderRadius,
          padding: padding,
          activeColor: mcgpalette0Secondary,
          activeIcon: const Icon(
            Icons.check,
            color: mcgpalette0Secondary,
          ),
          inactiveIcon: const Icon(
            Icons.close,
            color: Colors.red,
          ),
        );
}
