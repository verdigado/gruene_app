part of 'news_bloc.dart';

class NewsState extends Equatable {
  final NewsPaginationResult latest;
  final NewsPaginationResult interested;
  final NewsPaginationResult saved;

  final bool dirty;
  final NewsFilters index;
  const NewsState({
    required this.latest,
    required this.interested,
    required this.saved,
    this.dirty = false,
    this.index = NewsFilters.none,
  });

  @override
  List<Object> get props => [latest, interested, saved, dirty];
}
