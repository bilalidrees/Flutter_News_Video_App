part of 'youtube_live_bloc.dart';

@immutable
abstract class YoutubeLiveState {
  const YoutubeLiveState();
}

class YoutubeLiveInitial extends YoutubeLiveState {}
class YoutubeLiveLoading extends YoutubeLiveState {}
class YoutubeLiveLoaded extends YoutubeLiveState {
  final YouTubeLive youTubeLive;
  const YoutubeLiveLoaded({required this.youTubeLive});
}
class YoutubeLiveError extends YoutubeLiveState {
  final String message;
  const YoutubeLiveError({required this.message});
}
