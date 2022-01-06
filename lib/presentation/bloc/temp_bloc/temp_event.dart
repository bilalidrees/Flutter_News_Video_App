part of 'temp_bloc.dart';

@immutable
abstract class TempEvent {
  const TempEvent();
}


class GetJsonData extends TempEvent{
  const GetJsonData();
}
