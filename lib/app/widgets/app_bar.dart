import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/app/constants/routes.dart';
import 'package:gruene_app/app/theme.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context);
    final theme = Theme.of(context);
    return AppBar(
      title: Text(currentRoute.name ?? '', style: theme.textTheme.displayMedium?.apply(color: ThemeColors.background)),
      foregroundColor: ThemeColors.background,
      backgroundColor: theme.primaryColor,
      centerTitle: true,
      actions: [
        if (currentRoute.path != Routes.settings)
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(Routes.settings),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
