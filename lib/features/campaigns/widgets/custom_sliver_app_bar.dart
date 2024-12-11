import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/app/constants/routes.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/app/widgets/icon.dart';

class CustomSliverAppBar extends StatelessWidget {
  final String title;

  const CustomSliverAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foregroundColor = theme.primaryColor;
    return SliverAppBar(
      backgroundColor: foregroundColor,
      leading: BackButton(color: foregroundColor),
      iconTheme: IconThemeData(color: foregroundColor),
      title: Text(title, style: theme.textTheme.titleMedium?.apply(color: theme.appBarTheme.foregroundColor)),
      centerTitle: true,
      actions: [
        IconButton(
          icon: CustomIcon(
            path: 'assets/icons/settings.svg',
            color: ThemeColors.background,
          ),
          onPressed: () => context.push(Routes.settings.path),
        ),
      ],
      pinned: true,
    );
  }
}
