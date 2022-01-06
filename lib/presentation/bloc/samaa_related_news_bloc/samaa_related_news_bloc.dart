import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:samma_tv/source/core/exception.dart';
import 'package:samma_tv/source/model/samaa_related_news.dart';
import 'package:samma_tv/source/model/samaa_related_news.dart';
import 'package:samma_tv/source/repository/samaa_related_news_repo.dart';

part 'samaa_related_news_event.dart';

part 'samaa_related_news_state.dart';

class SamaaRelatedNewsBloc
    extends Bloc<SamaaRelatedNewsEvent, SamaaRelatedNewsState> {
  final SamaaRelatedNewsRepository _samaaRelatedNewsRepository;

  SamaaRelatedNewsBloc(this._samaaRelatedNewsRepository)
      : super(SamaaRelatedNewsInitial()) {
    on<GetSamaaRelatedNewsById>((event, emit) async {
      emit(SamaaRelatedNewsLoading());
      final eitherResponse =
          await _samaaRelatedNewsRepository.getSamaaRelatedNewsByName(event.id);
      emit(
        eitherResponse.fold(
            (failure) =>
                SamaaRelatedNewsError(message: _mapFailureToMessage(failure)),
            (data) => SamaaRelatedNewsLoaded(samaaRelatedNews: data)),
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
