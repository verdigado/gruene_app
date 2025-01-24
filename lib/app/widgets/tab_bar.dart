import 'package:flutter/material.dart';
import 'package:gruene_app/app/theme/theme.dart';

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;
  final List<String> tabs;
  final void Function(int index) onTap;

  const CustomTabBar({super.key, required this.tabController, required this.tabs, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surfaceDim,
      child: TabBar(
        padding: EdgeInsets.symmetric(horizontal: 8),
        indicatorColor: theme.colorScheme.secondary,
        dividerColor: ThemeColors.textLight,
        dividerHeight: 2,
        controller: tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        onTap: onTap,
        tabs: tabs.map((tab) => Tab(child: Text(tab))).toList(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);
}
