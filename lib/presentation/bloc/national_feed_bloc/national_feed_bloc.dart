import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:samma_tv/source/core/exception.dart';
import 'package:samma_tv/source/model/samaa_category_news.dart';
import 'package:samma_tv/source/repository/national_feed_repo.dart';

part 'national_feed_event.dart';

part 'national_feed_state.dart';

class NationalFeedBloc extends Bloc<NationalFeedEvent, NationalFeedState> {
  final NationalFeedRepository _repository;

  NationalFeedBloc(this._repository) : super(NationalFeedInitial()) {
    on<GetNationalFeed>((event, emit) async {
      emit(NationalFeedLoading());
      final eitherResponse = await _repository.getNationalFeed();
      emit(
        eitherResponse.fold(
            (failure) =>
                NationalFeedError(message: _mapFailureToMessage(failure)),
            (data) => NationalFeedLoaded(myNews: data)),
      );
    });
    on<GetCurrentNationalFeed>((event, emit) async {
      emit(NationalFeedLoaded(myNews: event.myNews));
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
