import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:samma_tv/source/core/exception.dart';
import 'package:samma_tv/source/model/samaa_category_news.dart';
import 'package:samma_tv/source/repository/samaa_category_news_repo.dart';

part 'samaa_category_news_event.dart';

part 'samaa_category_news_state.dart';

class SamaaCategoryNewsBloc
    extends Bloc<SamaaCategoryNewsEvent, SamaaCategoryNewsState> {
  final SamaaCategoryNewsRepository _samaaCategoryNewsRepository;

  SamaaCategoryNewsBloc(this._samaaCategoryNewsRepository)
      : super(SamaaCategoryNewsInitial()) {
    on<GetSamaaCategoryNewsByName>((event, emit) async {
      emit(SamaaCategoryNewsLoading());
      final eitherResponse = await _samaaCategoryNewsRepository
          .getSamaaCategoryNewsByName(event. categoryName);
      emit(
        eitherResponse.fold(
            (failure) =>
                SamaaCategoryNewsError(message: _mapFailureToMessage(failure)),
            (data) => SamaaCategoryNewsLoaded(samaaCategoryNews: data)),
      );
    });
    on<GetSamaaCategoryNewsUrdu>((event, emit) async {
      emit(SamaaCategoryNewsLoaded(samaaCategoryNews: event.samaaCategoryNews));
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
