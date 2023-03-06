import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/routing/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScaffoldWithNavbar extends StatefulWidget {
  final Widget child;

  final String titel;
  final appBarItems = [startScreen, moreScreen];

  ScaffoldWithNavbar({
    Key? key,
    required this.child,
    required this.titel,
  }) : super(key: key);

  @override
  State<ScaffoldWithNavbar> createState() => _ScaffoldWithNavbarState();
}

class _ScaffoldWithNavbarState extends State<ScaffoldWithNavbar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.titel),
      ),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.home,
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu),
            label: AppLocalizations.of(context)!.more,
            backgroundColor: Colors.white,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 89, 84, 77),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          context.push(widget.appBarItems[index]);
        },
      ),
    );
  }
}
