import 'package:flutter/material.dart';
import 'package:gruene_app/features/campaigns/widgets/custom_app_bar.dart';

class ContentPage extends StatelessWidget {
  final String title;
  final Widget child;

  const ContentPage({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.secondary,
      body: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(child: child),
      ),
      appBar: CustomAppBar(
        title: title,
      ),
    );
  }
}
