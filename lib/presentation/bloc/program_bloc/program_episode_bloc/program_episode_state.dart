part of 'program_episode_bloc.dart';

@immutable
abstract class ProgramEpisodeState {}

class ProgramEpisodeInitial extends ProgramEpisodeState {}

class ProgramEpisodeLoading extends ProgramEpisodeState {}

class ProgramEpisodeLoaded extends ProgramEpisodeState {
  final ProgramResponse programResponse;

  ProgramEpisodeLoaded({required this.programResponse});
}

class ProgramEpisodeError extends ProgramEpisodeState {
  final String message;

  ProgramEpisodeError({required this.message});
}
