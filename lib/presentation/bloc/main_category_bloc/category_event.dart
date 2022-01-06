part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent {
  const CategoryEvent();
}

class GetMainCategory extends CategoryEvent{
  const GetMainCategory();
}
