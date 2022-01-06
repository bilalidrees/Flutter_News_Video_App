import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'localization_event.dart';

part 'localization_state.dart';

class LocalizationBloc extends HydratedBloc<LocalizationEvent, Locale> {
  LocalizationBloc() : super(Locale.fromSubtags(
      countryCode: 'US', languageCode: 'en')) {
    on<SetLocale>((event, emit) {
      emit(Locale.fromSubtags(
          countryCode: event.countryCode, languageCode: event.languageCode));
    });
  }

  @override
  Locale? fromJson(Map<String, dynamic> json) {
    var parsed = json['brightness'];
    var event = _CustomLocale.fromJson(parsed);

    return Locale.fromSubtags(
        countryCode: event._countryCode, languageCode: event._languageCode);
  }

  @override
  Map<String, dynamic>? toJson(Locale state) {
    final _CustomLocale customLocale =
        _CustomLocale(state.languageCode, state.countryCode);
    final json = customLocale.toJson();
    return <String, dynamic>{'brightness': json};
  }
}

class _CustomLocale {
  late final String _languageCode;
  late final String? _countryCode;

  _CustomLocale(this._languageCode, this._countryCode);

  _CustomLocale.fromJson(Map<String, dynamic> json) {
    _languageCode = json['languageCode'];
    _countryCode = json['countryCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['languageCode'] = this._languageCode;
    data['countryCode'] = this._countryCode;
    return data;
  }
}
