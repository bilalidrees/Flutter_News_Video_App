part of 'samaa_category_news_bloc.dart';

@immutable
abstract class SamaaCategoryNewsEvent {
  const SamaaCategoryNewsEvent();
}

class GetSamaaCategoryNewsByName extends SamaaCategoryNewsEvent {
  final String categoryName;

  const GetSamaaCategoryNewsByName({required this.categoryName});
}

class GetSamaaCategoryNewsUrdu extends SamaaCategoryNewsEvent {
  final SamaaCategoryNews samaaCategoryNews;

  const GetSamaaCategoryNewsUrdu({required this.samaaCategoryNews});
}
