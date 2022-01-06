import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:samma_tv/source/core/exception.dart';
import 'package:samma_tv/source/model/json_placeholder.dart';
import 'package:samma_tv/source/repository/json_placeholder_repo.dart';

part 'temp_event.dart';

part 'temp_state.dart';

class TempBloc extends Bloc<TempEvent, TempState> {
  final JsonPlaceHolderRepository _repository;

  TempBloc(this._repository) : super(TempInitial()) {
    on<GetJsonData>((event, emit) async {
      emit(TempLoading());
      final  eitherResponse = await _repository.getJsonPlaceHolder();
      emit(
        eitherResponse.fold(
            (failure) => TempError(message: _mapFailureToMessage(failure)),
            (data) => TempLoaded(placeHolder: data)),
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
