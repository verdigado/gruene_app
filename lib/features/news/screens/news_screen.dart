import 'package:flutter/material.dart';
import 'package:gruene_app/app/widgets/app_bar.dart';
import 'package:gruene_app/app/widgets/main_layout.dart';
import 'package:gruene_app/app/widgets/rounded_icon_button.dart';
import 'package:gruene_app/app/widgets/tab_bar.dart';
import 'package:gruene_app/features/news/widgets/news_list.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class NewsScreen extends StatefulWidget {
  final tabs = [
    TabModel(label: t.news.latest, view: NewsList()),
    TabModel(label: t.news.bookmarked, view: NewsList(bookmarked: true)),
  ];

  NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with SingleTickerProviderStateMixin {
  bool _showFilters = false;
  String? division;
  String? search;
  String? category;
  DateTime? start;
  DateTime? end;
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
      child: TabBarView(
        controller: _tabController,
        children: widget.tabs.map((tab) => tab.view).toList(),
      ),
    );
  }
}
