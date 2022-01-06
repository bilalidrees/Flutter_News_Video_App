part of 'theme_bloc.dart';

@immutable
abstract class ThemeEvent {
  const ThemeEvent();
}

class SetLightTheme extends ThemeEvent {
  const SetLightTheme();
}

class SetDarkTheme extends ThemeEvent {
  const SetDarkTheme();
}
