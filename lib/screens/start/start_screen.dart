import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gruene_app/constants/theme_data.dart';
import 'package:gruene_app/net/news/bloc/news_bloc.dart';
import 'package:gruene_app/net/news/data/news_filters.dart';
import 'package:gruene_app/net/news/repository/news_repositoty.dart';
import 'package:gruene_app/screens/start/tabs/lastes_tab.dart';
import 'package:gruene_app/screens/start/tabs/news_card_pagination_list_view.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'tabs/interest_tab.dart';
import 'tabs/saved_tab.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      // ignore: unnecessary_cast
      create: (context) => NewsRepositoryImpl() as NewsRepository,
      child: BlocProvider(
          create: (context) => NewsBloc(context.read<NewsRepository>()),
          child: const NewsTabView()),
    );
  }
}

void apppend(NewsPaginationResult newItems,
    PagingController<int, News> pagingController) {
  final isLastPage = newItems.news.length < LatestTab.pageSize;
  if (isLastPage) {
    pagingController.appendLastPage(newItems.news);
  } else {
    pagingController.appendPage(newItems.news, newItems.next);
  }
}

class NewsTabView extends StatefulWidget {
  const NewsTabView({super.key});

  @override
  State<NewsTabView> createState() => _NewsTabViewState();
}

class _NewsTabViewState extends State<NewsTabView>
    with SingleTickerProviderStateMixin {
  final GlobalKey<NewsCardPaginationListViewState> latestTabKey = GlobalKey();
  final GlobalKey<NewsCardPaginationListViewState> savedTabKey = GlobalKey();
  int currentTab = 0;
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      var bookMarked = context.read<NewsBloc>().state;

      if (bookMarked.dirty) {
        if (bookMarked.index == NewsFilters.latest) {
          savedTabKey.currentState?.refresh();
        }

        if (bookMarked.index == NewsFilters.saved) {
          latestTabKey.currentState?.refresh();
        }

        context.read<NewsBloc>().add(Clean());
        setState(() {
          currentTab = tabController.index;
        });
      }
    });
    super.initState();
  }

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
    return Scaffold(
      appBar: TabBar(
          controller: tabController,
          onTap: (value) {
            if (currentTab == value) {
              if (value == 0) {
                latestTabKey.currentState?.scrollTop();
              }
              if (value == 2) {
                savedTabKey.currentState?.scrollTop();
              }
            }
            currentTab = value;
          },
          tabs: tabs,
          indicatorColor: const Color(mcgpalette0PrimaryValue)),
      body: TabBarView(controller: tabController, children: [
        LatestTab(listViewKey: latestTabKey),
        const InterestTab(),
        SavedTab(listViewKey: savedTabKey)
      ]),
    );
  }
}
