part of 'samaa_related_news_bloc.dart';

@immutable
abstract class SamaaRelatedNewsState {
  const SamaaRelatedNewsState();
}

class SamaaRelatedNewsInitial extends SamaaRelatedNewsState {}
class SamaaRelatedNewsLoading extends SamaaRelatedNewsState {}
class SamaaRelatedNewsLoaded extends SamaaRelatedNewsState {
  final SamaaRelatedNews samaaRelatedNews;
  const SamaaRelatedNewsLoaded({required this.samaaRelatedNews});
}
class SamaaRelatedNewsError extends SamaaRelatedNewsState {
  final String message;
  const SamaaRelatedNewsError({required this.message});
}
