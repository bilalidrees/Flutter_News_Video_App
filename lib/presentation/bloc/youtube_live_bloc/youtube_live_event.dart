part of 'youtube_live_bloc.dart';

@immutable
abstract class YoutubeLiveEvent {
  const YoutubeLiveEvent();
}

class GetYoutubeLive extends YoutubeLiveEvent{
  const GetYoutubeLive();
}
