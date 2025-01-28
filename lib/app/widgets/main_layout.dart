import 'package:flutter/material.dart';
import 'package:gruene_app/app/widgets/app_bar.dart';
import 'package:gruene_app/app/widgets/bottom_navigation.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final Widget? appBarAction;

  const MainLayout({super.key, required this.child, this.appBarAction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const BottomNavigation(),
      appBar: MainAppBar(appBarAction: appBarAction),
    );
  }
}
