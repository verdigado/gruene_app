import 'package:flutter/material.dart';

class AppRoute extends MaterialPageRoute {
  AppRoute({required WidgetBuilder builder, super.settings})
      : super(
          builder: (BuildContext context) {
            final theme = Theme.of(context);
            return Material(child: builder(context));
          },
        );
}
