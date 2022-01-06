import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:samma_tv/presentation/bloc/program_bloc/program_listing_bloc/program_listing_bloc.dart';
import 'package:samma_tv/source/core/exception.dart';
import 'package:samma_tv/source/model/program_response.dart';
import 'package:samma_tv/source/repository/program_repository.dart';

part 'program_episode_event.dart';

part 'program_episode_state.dart';

class ProgramEpisodeBloc
    extends Bloc<ProgramEpisodeEvent, ProgramEpisodeState> {
  ProgramRepository programRepository;

  ProgramEpisodeBloc(this.programRepository) : super(ProgramEpisodeInitial()) {
    on<GetProgramsEpisodeList>((event, emit) async {
      emit(ProgramEpisodeLoading());
      final eitherResponse =
          await programRepository.getProgramsList(url: event.url);
      emit(
        eitherResponse.fold(
            (failure) =>
                ProgramEpisodeError(message: _mapFailureToMessage(failure)),
            (data) => ProgramEpisodeLoaded(programResponse: data)),
      );
    });
    on<GetCurrentProgramsList>((event, emit) async {
      emit(ProgramEpisodeLoaded(programResponse: event.programResponse!));
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
