
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocaleCubit extends Cubit<Locale> {
  static const String _boxName = 'settingsBox';
  static const String _languageKey = 'languageCode';

  LocaleCubit() : super(const Locale('en')) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final box = await Hive.openBox(_boxName);

    final languageCode = box.get(_languageKey);

    if (languageCode != null) {
      emit(Locale(languageCode));
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    final box = await Hive.openBox(_boxName);

    await box.put(_languageKey, languageCode);

    emit(Locale(languageCode));
  }
}

