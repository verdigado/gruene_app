import 'dart:math';

import 'package:faker/faker.dart';
import 'package:gruene_app/net/news/data/news_filters.dart';
import 'package:gruene_app/screens/start/tabs/news_card_pagination_list_view.dart';

abstract class NewsRepository {
  NewsPaginationResult getNews(int pageSize, int pageKey, NewsFilters filters);
  bool bookmarked(String id, bool action);
}

class NewsRepositoryImpl extends NewsRepository {
  @override
  NewsPaginationResult getNews(int pageSize, int pageKey, NewsFilters filters) {
    if (pageKey > 100) {
      return NewsPaginationResult(news: [
        News(
          id: '465f54sgf5',
          imageUrl:
              'https://picsum.photos/seed/${Random().nextInt(10000000)}/1000/500',
          newsUrl: 'https://dominikp30.github.io/',
          typ: 'Veranstaltung',
          titel: faker.lorem.sentences(1).join(),
          subtitel: faker.lorem.sentences(3).join(),
          chipLabel: 'Kreisverband',
          bookmarked: false,
        ),
        News(
          id: 'fs54fs544522e',
          imageUrl:
              'https://picsum.photos/seed/${Random().nextInt(10000000)}/1000/500',
          newsUrl: 'https://dominikp30.github.io/',
          typ: 'Veranstaltung',
          titel: faker.lorem.sentences(3).join(),
          subtitel: faker.lorem.sentences(30).join(),
          chipLabel: 'Kreisverband',
          bookmarked: false,
        ),
        News(
          id: 'f4654feqq3dc3v',
          imageUrl:
              'https://picsum.photos/seed/${Random().nextInt(10000000)}/1000/500',
          newsUrl: 'https://dominikp30.github.io/',
          typ: 'Veranstaltung',
          titel: faker.lorem.sentences(3).join(),
          subtitel: faker.lorem.sentences(30).join(),
          chipLabel: 'Kreisverband',
          bookmarked: false,
        )
      ], self: pageKey, next: pageKey + pageSize, prev: pageKey - pageSize);
    }
    return NewsPaginationResult(
        news: [
          ...positiveIntegers.skip(1).take(pageSize).map((e) => News(
                id: e.toString(),
                imageUrl:
                    'https://picsum.photos/seed/${Random().nextInt(10000000)}/1000/500',
                typ: 'Veranstaltung',
                titel: faker.lorem.sentences(1).join(),
                subtitel: faker.lorem.sentences(3).join(),
                chipLabel: 'Kreisverband',
                newsUrl: 'https://dominikp30.github.io/',
                bookmarked: false,
              ))
        ],
        self: pageKey,
        next: pageKey + 1 + pageSize,
        prev: pageKey - pageSize - 1);
  }

  @override
  bool bookmarked(String id, bool action) {
    return action;
  }
}
