import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_it/get_it.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/app/utils/format_date.dart';
import 'package:gruene_app/app/utils/open_url.dart';
import 'package:gruene_app/features/news/models/news_model.dart';
import 'package:gruene_app/i18n/translations.g.dart';
import 'package:gruene_app/swagger_generated_code/gruene_api.swagger.dart' as api;

class NewsDetailScreen extends StatefulWidget {
  final String newsId;

  const NewsDetailScreen({super.key, required this.newsId});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  late Future<NewsModel?> news;

  @override
  void initState() {
    super.initState();
    news = fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder<NewsModel?>(
      future: news,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: ThemeColors.textWarning),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      news = fetchNews(); // Retry fetching items
                    });
                  },
                  child: Text('Erneut versuchen'),
                ),
              ],
            ),
          );
        } else if (snapshot.hasData && snapshot.data == null) {
          return Center(
            child: Text('Artikel existiert nicht.'),
          );
        } else {
          final news = snapshot.data!;
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
                          child: Image.asset(news.image, fit: BoxFit.cover),
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t.news.writtenBy(author: news.author)),
                              Text(
                                news.title,
                                style: theme.textTheme.titleLarge,
                              ),
                              SizedBox(height: 16),
                              Text(
                                t.news.updatedAt(date: formatDate(news.createdAt)),
                                style: theme.textTheme.labelSmall,
                              ),
                              Text(
                                news.summary,
                                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height: 24),
                              Html(
                                data: news.content,
                                onLinkTap: (url, _, __) => url != null ? openUrl(url, context) : null,
                              ),
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
                      news.bookmarked ? Icons.bookmark_added : Icons.bookmark_add_outlined,
                      color: theme.colorScheme.surface,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<NewsModel?> fetchNews() async {
    final api.GrueneApi client = GetIt.I<api.GrueneApi>();

    final response = await client.v1NewsNewsIdGet(newsId: widget.newsId);
    if (!response.isSuccessful) {
      throw Exception(
        'Fehler beim Laden des Artikels (Status Code: ${response.statusCode})',
      );
    }

    return NewsModel.fromApi(response.body!);
  }
}
