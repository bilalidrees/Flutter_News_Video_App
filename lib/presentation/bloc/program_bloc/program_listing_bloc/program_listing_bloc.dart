import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:samma_tv/source/core/exception.dart';
import 'package:samma_tv/source/model/program_response.dart';
import 'package:samma_tv/source/repository/program_repository.dart';

part 'program_listing_event.dart';

part 'program_listing_state.dart';

class ProgramListingBloc
    extends Bloc<ProgramListingEvent, ProgramListingState> {
  ProgramRepository programRepository;

  ProgramListingBloc(this.programRepository) : super(ProgramListingInitial()) {
    on<GetProgramsList>((event, emit) async {
      emit(ProgramListingLoading());
      final eitherResponse = await programRepository.getProgramsList();
      emit(
        eitherResponse.fold(
            (failure) =>
                ProgramListingError(message: _mapFailureToMessage(failure)),
            (data) => ProgramListingLoaded(programResponse: data)),
      );
    });
  }
}

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    default:
      return 'Unexpected error';
  }
}
