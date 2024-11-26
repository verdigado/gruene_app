class NewsModel {
  int id;
  String title;
  String content;
  String author;
  String image;
  String type;
  String creator;
  List<String> categories;
  DateTime date;

  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.image,
    required this.type,
    required this.creator,
    required this.categories,
    required this.date,
  });
}
