part of 'national_feed_bloc.dart';

@immutable
abstract class NationalFeedState {
  const NationalFeedState();
}

class NationalFeedInitial extends NationalFeedState {}

class NationalFeedLoading extends NationalFeedState {}

class NationalFeedLoaded extends NationalFeedState {
  final MyNews myNews;

  const NationalFeedLoaded({required this.myNews}):super();

}

class NationalFeedError extends NationalFeedState {
  final String message;

 const  NationalFeedError({required this.message}):super();
}
