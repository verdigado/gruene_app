import 'package:flutter/material.dart';
import 'package:gruene_app/constants/theme_data.dart';
import 'package:gruene_app/screens/start/tabs/interest_tab.dart';
import 'package:gruene_app/screens/start/tabs/lastes_tab.dart';
import 'package:gruene_app/screens/start/tabs/news_card_pagination_list_view.dart';
import 'package:gruene_app/screens/start/tabs/saved_tab.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final GlobalKey<NewsCardPaginationListViewState> latestTabKey = GlobalKey();
  int currentTab = 0;
  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = <Tab>[
      Tab(
        child: GestureDetector(
          child: Text(
            'Aktuelles',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 16, color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
      Tab(
        child: Text(
          'Interessen',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 16, color: Theme.of(context).colorScheme.primary),
        ),
      ),
      Tab(
        child: Text(
          'Gespeichert',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 16, color: Theme.of(context).colorScheme.primary),
        ),
      ),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: TabBar(
            onTap: (value) {
              if (value == 0 && currentTab == 0) {
                latestTabKey.currentState?.scrollTop();
              }
              currentTab = value;
            },
            tabs: tabs,
            indicatorColor: const Color(mcgpalette0PrimaryValue)),
        body: TabBarView(children: [
          LatestTab(listViewKey: latestTabKey),
          const InterestTab(),
          SavedTab()
        ]),
      ),
    );
  }
}
