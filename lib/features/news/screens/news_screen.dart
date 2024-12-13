import 'package:flutter/material.dart';
import 'package:gruene_app/features/news/models/mock_news.dart';
import 'package:gruene_app/features/news/widgets/news_card.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: news.map((item) => NewsCard(news: item)).toList(),
    );
  }
}
