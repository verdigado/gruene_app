import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/app/constants/bottom_navigation_items.dart';
import 'package:gruene_app/app/theme.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  BottomNavigationState createState() => BottomNavigationState();
}

class BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentRoute = GoRouterState.of(context).path;
    final index = bottomNavigationItems.indexWhere((item) => item.route == currentRoute);
    if (index != -1) {
      _currentIndex = index;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return SizedBox(
      height: 64.0,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: ThemeColors.white,
        items: bottomNavigationItems.map((item) {
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
                        _currentIndex == bottomNavigationItems.indexOf(item)
                            ? ThemeColors.stateHoverGreen
                            : ThemeColors.middleGrey,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            label: item.getTitle(context),
          );
        }).toList(),
        currentIndex: _currentIndex,
        onTap: (index) {
          context.go(bottomNavigationItems[index].route);
        },
      ),
    );
  }
}
