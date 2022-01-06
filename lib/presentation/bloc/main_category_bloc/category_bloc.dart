import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:samma_tv/source/core/exception.dart';
import 'package:samma_tv/source/model/main_category.dart';
import 'package:samma_tv/source/repository/main_category_repo.dart';
part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final MainCategoryRepository _categoryRepository;
  CategoryBloc(this._categoryRepository) : super(CategoryInitial()) {
    on<GetMainCategory>((event, emit) async{
      emit(CategoryLoading());
      final  eitherResponse = await _categoryRepository.getMainCategory();
      emit(
        eitherResponse.fold(
                (failure) => CategoryError(message: _mapFailureToMessage(failure)),
                (data) => CategoryLoaded(mainCategory: data)),
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
