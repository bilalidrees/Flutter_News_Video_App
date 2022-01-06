import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'theme_event.dart';

part 'theme_state.dart';

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeMode> {
  ThemeBloc() : super(ThemeMode.light) {
    on<SetLightTheme>((event, emit) {
      emit(ThemeMode.light);
    });
    on<SetDarkTheme>((event, emit) {
      emit(ThemeMode.dark);
    });
  }

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    return ThemeMode.values[json['mode'] as int];
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode  state) {
    return <String, int>{'mode': state.index};
    throw UnimplementedError();
  }
}
