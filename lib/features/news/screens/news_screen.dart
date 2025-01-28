import 'package:flutter/material.dart';
import 'package:gruene_app/app/screens/error_screen.dart';
import 'package:gruene_app/app/screens/future_loading_screen.dart';
import 'package:gruene_app/app/widgets/app_bar.dart';
import 'package:gruene_app/app/widgets/main_layout.dart';
import 'package:gruene_app/features/news/domain/news_api_service.dart';
import 'package:gruene_app/features/news/models/news_model.dart';
import 'package:gruene_app/features/news/widgets/news_card.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appBar: MainAppBar(),
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
