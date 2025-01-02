import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/app/constants/bottom_navigation_items.dart';
import 'package:gruene_app/app/theme/theme.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final route = GoRouter.of(context).routerDelegate.currentConfiguration.matches[0].route as GoRoute;
    final currentRoute = route.path;
    final currentRouteIndex = bottomNavigationItems.indexWhere((item) => item.route == currentRoute);
    final theme = Theme.of(context);

    return currentRouteIndex >= 0
        ? SizedBox(
            height: 64.0,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: theme.colorScheme.surface,
              items: bottomNavigationItems.map((item) {
                final isSelected = currentRoute == item.route;
                return BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: SizedBox(
                      height: 26.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            item.iconPath,
                            colorFilter: ColorFilter.mode(
                              isSelected ? theme.colorScheme.primary : ThemeColors.textDisabled,
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  label: item.getLabel(context),
                );
              }).toList(),
              currentIndex: currentRouteIndex,
              onTap: (index) {
                context.go(bottomNavigationItems[index].route);
              },
            ),
          )
        : SizedBox.shrink();
  }
}
