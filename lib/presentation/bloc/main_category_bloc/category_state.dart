part of 'category_bloc.dart';

@immutable
abstract class CategoryState {
  const CategoryState();
}

class CategoryInitial extends CategoryState {}
class CategoryLoading extends CategoryState {}
class CategoryLoaded extends CategoryState {
  final MainCategory mainCategory;
  const CategoryLoaded({required this.mainCategory});
}
class CategoryError extends CategoryState {
  final String message;
  const CategoryError({required this.message});
}
