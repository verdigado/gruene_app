import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/app/constants/routes.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/app/widgets/icon.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context);
    final theme = Theme.of(context);
    return AppBar(
      title:
          Text(
        currentRoute.name ?? '',
        style: theme.textTheme.displayMedium?.apply(color: theme.colorScheme.surface),
      ),
      foregroundColor: theme.colorScheme.surface,
      backgroundColor: theme.primaryColor,
      centerTitle: true,
      actions: [
        if (currentRoute.path == Routes.campaigns)
          IconButton(
            icon: CustomIcon(
              path: 'assets/icons/refresh.svg',
              color: ThemeColors.background,
            ),
            onPressed: null,
          ),
        if (currentRoute.path != Routes.settings)
          IconButton(
            icon: CustomIcon(
              path: 'assets/icons/settings.svg',
              color: ThemeColors.background,
            ),
            onPressed: () => context.push(Routes.settings),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
