import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/app/constants/routes.dart';
import 'package:gruene_app/app/theme.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).path;
    final theme = Theme.of(context);
    return AppBar(
      title: Text(t.common.appName, style: theme.textTheme.displayMedium?.apply(color: ThemeColors.background)),
      foregroundColor: ThemeColors.background,
      backgroundColor: theme.primaryColor,
      centerTitle: true,
      actions: [
        if (currentRoute != Routes.settings)
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Show Snackbar',
            onPressed: () => context.push(Routes.settings),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
