import 'package:gruene_app/features/news/models/news_model.dart';

List<NewsModel> news = [
  NewsModel(
    id: 1,
    title: 'Webinar: Windenergie vom Meer mit langem Titel',
    abstract:
        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.',
    content:
        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.',
    author: 'Stefan Laak',
    image: 'assets/graphics/placeholders/placeholder_1.jpg',
    type: 'Veranstaltung',
    creator: 'Kreisverband',
    categories: ['education'],
    date: DateTime(2022, 12, 12),
    bookmarked: false,
  ),
  NewsModel(
    id: 2,
    title: 'Webinar: Arbeit im Kreisverband',
    abstract:
        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore. Test abstractLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore. Test abstract',
    content:
        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.\n\nLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.',
    author: 'Stefan Laak',
    image: 'assets/graphics/placeholders/placeholder_2.jpg',
    type: 'Weiterbildung',
    creator: 'Landesverband',
    categories: ['campaign'],
    date: DateTime(2022, 1, 14),
    bookmarked: true,
  ),
  NewsModel(
    id: 3,
    title: 'Gemeinsam haben wir unseren Rekord gebrochen',
    abstract:
        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.',
    content:
        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.',
    author: 'Stefan Laak',
    image: 'assets/graphics/placeholders/placeholder_3.jpg',
    type: 'Argumentationshilfe',
    creator: 'Bundesverband',
    categories: ['argumentation'],
    date: DateTime(2024, 10, 2),
    bookmarked: false,
  ),
  NewsModel(
    id: 4,
    title: 'Webinar: Windenergie vom Meer',
    abstract:
        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.',
    content:
        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.',
    author: 'Stefan Laak',
    image: 'assets/graphics/placeholders/placeholder_1.jpg',
    type: 'Weiterbildung',
    creator: 'Bundesverband',
    categories: ['education'],
    date: DateTime(2022, 12, 12),
    bookmarked: true,
  ),
];
