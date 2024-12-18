import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/features/news/models/news_model.dart';
import 'package:gruene_app/features/news/widgets/news_card.dart';
import 'package:gruene_app/swagger_generated_code/gruene_api.swagger.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<NewsModel>> _news;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _news = fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NewsModel>>(
      future: _news,
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
                      _news = fetchNews(); // Retry fetching items
                    });
                  },
                  child: Text('Erneut versuchen'),
                ),
              ],
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return Center(
            child: Text('Keine Artikel gefunden.'),
          );
        } else {
          final items = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return NewsCard(news: items[index]);
            },
          );
        }
      },
    );
  }

  Future<List<NewsModel>> fetchNews() async {
    final GrueneApi api = GetIt.I<GrueneApi>();

    final response = await api.v1NewsGet();
    if (!response.isSuccessful) {
      throw Exception(
        'Fehler beim Laden der Artikel (Status Code: ${response.statusCode})',
      );
    }
    return response.body!.data
        .map(
          (news) => NewsModel(
            id: news.id,
            title: news.title,
            abstract: news.summary ?? '',
            content: news.body.content,
            author: '',
            image: news.featuredImage?.original.url ??
                'assets/graphics/placeholders/placeholder_1.jpg',
            type: news.division?.shortName ?? '',
            creator: news.categories.isNotEmpty ? news.categories.first.label : null,
            categories: news.categories.map((cat) => cat.label).toList(),
            date: news.createdAt,
            bookmarked: false,
          ),
        )
        .toList();
  }
}
