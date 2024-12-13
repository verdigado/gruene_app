import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/app/utils/format_date.dart';
import 'package:gruene_app/app/utils/utils.dart';
import 'package:gruene_app/features/news/models/mock_news.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class NewsDetailScreen extends StatelessWidget {
  const NewsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final newsId = int.parse(GoRouterState.of(context).pathParameters['newsId']!);
    final newsItem = news.firstWhereOrNull((item) => item.id == newsId);

    if (newsItem == null) {
      return Text('Nothing found');
    }

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 288,
                    child: Image.asset(newsItem.image, fit: BoxFit.cover),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.news.writtenBy(author: newsItem.author)),
                        Text(newsItem.title, style: theme.textTheme.titleLarge),
                        SizedBox(height: 16),
                        Text(t.news.updatedAt(date: formatDate(newsItem.date)), style: theme.textTheme.labelSmall),
                        Text(
                          newsItem.abstract,
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 24),
                        Text(newsItem.content),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: IconButton(
              // TODO: Add bookmarking functionality
              onPressed: () {},
              icon: Icon(
                newsItem.bookmarked ? Icons.bookmark_added : Icons.bookmark_add_outlined,
                color: theme.colorScheme.surface,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
