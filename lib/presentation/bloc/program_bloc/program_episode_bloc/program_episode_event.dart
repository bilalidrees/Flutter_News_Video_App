part of 'program_episode_bloc.dart';

@immutable
abstract class ProgramEpisodeEvent {}

class GetProgramsEpisodeList extends ProgramEpisodeEvent {
  String? url;

  GetProgramsEpisodeList({this.url});
}

class GetCurrentProgramsList extends ProgramEpisodeEvent {
  final ProgramResponse? programResponse;

  GetCurrentProgramsList({this.programResponse});
}
