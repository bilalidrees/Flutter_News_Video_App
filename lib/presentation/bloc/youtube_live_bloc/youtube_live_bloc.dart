import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:samma_tv/source/core/exception.dart';
import 'package:samma_tv/source/model/youtube_live.dart';
import 'package:samma_tv/source/repository/youtube_live_repo.dart';

part 'youtube_live_event.dart';
part 'youtube_live_state.dart';

class YoutubeLiveBloc extends Bloc<YoutubeLiveEvent, YoutubeLiveState> {
  final YouTubeLiveRepository _repository;
  YoutubeLiveBloc(this._repository) : super(YoutubeLiveInitial()) {
    on<GetYoutubeLive>((event, emit)async {
      emit(YoutubeLiveLoading());
      final eitherResponse = await _repository.getYouTubeLive();
      emit(
        eitherResponse.fold(
                (failure) =>
                YoutubeLiveError(message: _mapFailureToMessage(failure)),
                (data) => YoutubeLiveLoaded(youTubeLive:  data)),
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
