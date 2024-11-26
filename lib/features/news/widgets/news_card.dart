import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/app/constants/routes.dart';
import 'package:gruene_app/features/news/models/news_model.dart';

class NewsCard extends StatelessWidget {
  final void Function() setFavorite;
  final NewsModel news;
  final bool favorite;

  const NewsCard({
    super.key,
    required this.setFavorite,
    required this.news,
    required this.favorite,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () => context.push('/news/${news.id}'),
        child: Card(
          color: theme.colorScheme.surface,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(news.image),
              ),
              Text(news.title, style: theme.textTheme.titleSmall),
              Text(news.content),
            ],
          ),
        ),
      ),
    );
  }
}
