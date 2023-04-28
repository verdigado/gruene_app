part of 'news_bloc.dart';

class NewsState extends Equatable {
  final List<NewsPaginationResult> latest;
  final List<NewsPaginationResult> interested;
  final List<NewsPaginationResult> saved;
  final NewsFilters? currentFilter;

  const NewsState({
    required this.latest,
    required this.interested,
    required this.saved,
    this.currentFilter,
  });

  @override
  List<Object?> get props => [latest, interested, saved, currentFilter];
}
