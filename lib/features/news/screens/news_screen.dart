import 'package:flutter/material.dart';
import 'package:gruene_app/app/screens/error_screen.dart';
import 'package:gruene_app/app/screens/future_loading_screen.dart';
import 'package:gruene_app/app/widgets/app_bar.dart';
import 'package:gruene_app/app/widgets/main_layout.dart';
import 'package:gruene_app/app/widgets/rounded_icon_button.dart';
import 'package:gruene_app/app/widgets/tab_bar.dart';
import 'package:gruene_app/features/news/domain/news_api_service.dart';
import 'package:gruene_app/features/news/models/news_model.dart';
import 'package:gruene_app/features/news/widgets/news_card.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class NewsScreen extends StatefulWidget {
  final tabs = [t.news.latest, t.news.bookmarked];

  NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with SingleTickerProviderStateMixin {
  bool _showFilters = false;
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: widget.tabs.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MainLayout(
      appBar: MainAppBar(
        appBarAction: RoundedIconButton(
          onPressed: () => setState(() => _showFilters = !_showFilters),
          icon: Icons.filter_list_rounded,
          iconColor: theme.colorScheme.surface,
          backgroundColor: theme.colorScheme.primary,
          selected: _showFilters,
        ),
        tabBar: CustomTabBar(
          tabController: _tabController,
          tabs: widget.tabs,
          onTap: (index) => setState(() => _tabController.index = index),
        ),
      ),
      child: FutureLoadingScreen(
        load: fetchNews,
        buildChild: (List<NewsModel>? data) {
          if (data == null || data.isEmpty) {
            return ErrorScreen(error: t.news.noResults, retry: fetchNews);
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) => NewsCard(news: data[index]),
          );
        },
      ),
    );
  }
}
