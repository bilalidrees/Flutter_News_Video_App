part of 'program_listing_bloc.dart';

@immutable
abstract class ProgramListingEvent {}

class GetProgramsList extends ProgramListingEvent {
  GetProgramsList();
}
