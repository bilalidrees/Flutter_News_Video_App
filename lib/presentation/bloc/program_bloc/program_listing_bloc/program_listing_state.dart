part of 'program_listing_bloc.dart';

@immutable
abstract class ProgramListingState {}

class ProgramListingInitial extends ProgramListingState {}

class ProgramListingLoading extends ProgramListingState {}

class ProgramListingLoaded extends ProgramListingState {
  final ProgramResponse programResponse;

  ProgramListingLoaded({required this.programResponse});
}

class ProgramListingError extends ProgramListingState {
  final String message;

  ProgramListingError({required this.message});
}
