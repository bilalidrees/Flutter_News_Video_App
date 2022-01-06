part of 'temp_bloc.dart';

@immutable
abstract class TempState {
  const TempState();
}

class TempInitial extends TempState {
  const TempInitial();
}
class TempLoading extends TempState {
  const TempLoading();
}
class TempLoaded extends TempState {
  final JsonPlaceHolder placeHolder;
  const TempLoaded({required this.placeHolder});
}
class TempError extends TempState {
  final String message;
  const TempError({required this.message});
}
