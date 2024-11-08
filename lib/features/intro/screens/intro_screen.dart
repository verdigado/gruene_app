import 'package:flutter/material.dart';
import 'package:gruene_app/features/intro/widgets/support_button.dart';
import 'package:gruene_app/features/intro/widgets/welcome_view.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(backgroundColor: theme.colorScheme.surface, toolbarHeight: 0),
      body: Container(
        color: theme.colorScheme.surface,
        child: Stack(
          children: [
            WelcomeView(),
            SupportButton(),
          ],
        ),
      ),
    );
  }
}
