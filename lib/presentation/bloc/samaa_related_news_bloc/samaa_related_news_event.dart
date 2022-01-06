part of 'samaa_related_news_bloc.dart';

@immutable
abstract class SamaaRelatedNewsEvent {
  const SamaaRelatedNewsEvent();
}
class GetSamaaRelatedNewsById extends SamaaRelatedNewsEvent{
  final int id;
  const GetSamaaRelatedNewsById({required this.id });
}

