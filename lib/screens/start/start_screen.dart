import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gruene_app/constants/theme_data.dart';
import 'package:gruene_app/net/news/bloc/news_bloc.dart';
import 'package:gruene_app/net/news/data/news_filters.dart';
import 'package:gruene_app/net/news/repository/news_repositoty.dart';
import 'package:gruene_app/screens/start/tabs/latest_tab.dart';
import 'package:gruene_app/screens/start/tabs/news_card_pagination_list_view.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

void apppend(List<NewsPaginationResult> newItems,
    PagingController<int, News> pagingController) {
  final isLastPage = newItems.last.news.length < LatestTab.pageSize;
  var news = newItems.expand((element) => element.news).toList();
  if (isLastPage) {
    pagingController.value = PagingState<int, News>(
      itemList: news,
      error: null,
      nextPageKey: null,
    );
  } else {
    pagingController.value = PagingState<int, News>(
      itemList: news,
      error: null,
      nextPageKey: newItems.last.next,
    );
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

  late List<Widget> tabChilds;
  int currentTab = 0;
  late TabController tabController;
  @override
  void initState() {
    tabChilds = [
      LatestTab(listViewKey: latestTabKey),
      const InterestTab(),
      SavedTab(listViewKey: savedTabKey)
    ];

    tabController = TabController(length: tabChilds.length, vsync: this);

    tabController.addListener(() {
      if (tabController.index == 0) {
        context
            .read<NewsBloc>()
            .add(const NewsFilterChange(NewsFilters.latest));
      }
      if (tabController.index == 2) {
        context.read<NewsBloc>().add(const NewsFilterChange(NewsFilters.saved));
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
            AppLocalizations.of(context)!.newsTab1,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 16, color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
      Tab(
        child: Text(
          AppLocalizations.of(context)!.newsTab2,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 16, color: Theme.of(context).colorScheme.primary),
        ),
      ),
      Tab(
        child: Text(
          AppLocalizations.of(context)!.newsTab3,
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
      body: TabBarView(controller: tabController, children: tabChilds),
    );
  }
}
