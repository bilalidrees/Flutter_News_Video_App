part of 'national_feed_bloc.dart';

@immutable
abstract class NationalFeedEvent {
  const NationalFeedEvent();
}

class GetNationalFeed extends NationalFeedEvent{
  const GetNationalFeed();
}

class GetCurrentNationalFeed extends NationalFeedEvent{
  final MyNews myNews;
 const  GetCurrentNationalFeed({required this.myNews});
}