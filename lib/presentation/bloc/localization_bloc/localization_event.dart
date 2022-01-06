part of 'localization_bloc.dart';

@immutable
abstract class LocalizationEvent extends Equatable{
  const LocalizationEvent();
}

class SetLocale extends LocalizationEvent{
  final String countryCode;
  final String languageCode;
  const SetLocale({required this.countryCode,required this.languageCode});

  @override
  List<Object?> get props => [countryCode,languageCode];
}
