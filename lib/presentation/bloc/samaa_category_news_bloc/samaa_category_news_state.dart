part of 'samaa_category_news_bloc.dart';

@immutable
abstract class SamaaCategoryNewsState {
  const SamaaCategoryNewsState();
}

class SamaaCategoryNewsInitial extends SamaaCategoryNewsState {}

class SamaaCategoryNewsLoading extends SamaaCategoryNewsState {}

class SamaaCategoryNewsLoaded extends SamaaCategoryNewsState {
  final SamaaCategoryNews samaaCategoryNews;

  const SamaaCategoryNewsLoaded({required this.samaaCategoryNews});
}

class SamaaCategoryNewsError extends SamaaCategoryNewsState {
  final String message;

  const SamaaCategoryNewsError({required this.message});
}
