import 'package:gruene_app/swagger_generated_code/gruene_api.swagger.dart';

class NewsModel {
  String id;
  String title;
  String abstract;
  String content;
  String author;
  String image;
  String type;
  String? creator;
  List<String> categories;
  DateTime date;
  bool bookmarked;

  NewsModel({
    required this.id,
    required this.title,
    required this.abstract,
    required this.content,
    required this.author,
    required this.image,
    required this.type,
    required this.creator,
    required this.categories,
    required this.date,
    required this.bookmarked,
  });

  static NewsModel fromApi(News news) {
    return NewsModel(
      id: news.id,
      title: news.title,
      abstract: news.summary ?? '',
      content: news.body.content,
      author: '',
      // image: news.featuredImage?.original.url ?? 'assets/graphics/placeholders/placeholder_1.jpg',
      // use placeholder as long as drupal blocks image access
      image: 'assets/graphics/placeholders/placeholder_2.jpg',
      type: news.division?.shortName ?? '',
      creator: news.categories.isNotEmpty ? news.categories.first.label : null,
      categories: news.categories.map((cat) => cat.label).toList(),
      date: news.createdAt,
      bookmarked: false,
    );
  }
}
