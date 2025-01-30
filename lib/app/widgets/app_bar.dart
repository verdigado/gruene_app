import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/app/auth/bloc/auth_bloc.dart';
import 'package:gruene_app/app/constants/routes.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/app/widgets/icon.dart';
import 'package:gruene_app/features/campaigns/helper/campaign_action_cache.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context);
    final authBloc = context.read<AuthBloc>();
    final isLoggedIn = authBloc.state is Authenticated;
    final theme = Theme.of(context);
    return AppBar(
      title: Text(
        currentRoute.name ?? '',
        style: theme.textTheme.displayMedium?.apply(color: isLoggedIn ? theme.colorScheme.surface : ThemeColors.text),
      ),
      foregroundColor: isLoggedIn ? theme.colorScheme.surface : ThemeColors.text,
      backgroundColor: isLoggedIn ? theme.primaryColor : theme.colorScheme.surfaceDim,
      centerTitle: true,
      actions: [
        if (currentRoute.path == Routes.campaigns.path) RefreshButton(),
        if (currentRoute.path != Routes.settings.path && isLoggedIn)
          IconButton(
            icon: CustomIcon(
              path: 'assets/icons/settings.svg',
              color: ThemeColors.background,
            ),
            onPressed: () => context.push(Routes.settings.path),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class RefreshButton extends StatefulWidget {
  const RefreshButton({
    super.key,
  });

  @override
  State<RefreshButton> createState() => _RefreshButtonState();
}

class _RefreshButtonState extends State<RefreshButton> {
  int _currentCount = 0;
  final campaignActionCache = GetIt.I<CampaignActionCache>();

  @override
  void initState() {
    campaignActionCache.getCachedActionCount().then((value) {
      setState(() {
        _currentCount = value;
      });
    });
    campaignActionCache.addListener(_setCurrentCounter);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const maxLabelCount = 99;
    var labelText = _currentCount > maxLabelCount ? '$maxLabelCount+' : _currentCount.toString();
    return IconButton(
      icon: Badge(
        label: Text(labelText),
        isLabelVisible: _currentCount != 0,
        child: CustomIcon(
          path: 'assets/icons/refresh.svg',
          color: ThemeColors.background,
        ),
      ),
      onPressed: _flushCachedData,
    );
  }

  void _setCurrentCounter() async {
    final newCount = await campaignActionCache.getCachedActionCount();
    if (!mounted) return;
    setState(() {
      _currentCount = newCount;
    });
  }

  void _flushCachedData() {
    campaignActionCache.flushCache();
  }
}
