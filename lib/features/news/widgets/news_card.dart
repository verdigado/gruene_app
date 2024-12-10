import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/app/constants/routes.dart';
import 'package:gruene_app/app/theme/theme.dart';
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
      height: 384,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Card(
        color: theme.colorScheme.surface,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: InkWell(
          onTap: () => context.push('/news/${news.id}'),
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                  image: DecorationImage(
                    image: AssetImage(news.image),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(news.title, style: theme.textTheme.titleLarge),
                      SizedBox(height: 8),
                      Expanded(
                        child: Text(
                          news.content,
                        ),
                      ),
                      Chip(
                        label: Text(news.creator),
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        backgroundColor: theme.colorScheme.surface,
                        shape: StadiumBorder(),
                        side: BorderSide(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
