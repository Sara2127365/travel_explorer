import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_explorer/core/localstorage/theme_local_data_source.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final ThemeLocalDataSource localDataSource;

  ThemeCubit(this.localDataSource)
      : super(ThemeMode.light) {
    loadTheme();
  }

  Future<void> loadTheme() async {
    final isDark = await localDataSource.getIsDark();

    emit(
      isDark ? ThemeMode.dark : ThemeMode.light,
    );
  }

  Future<void> toggleTheme() async {
    final isDark = state == ThemeMode.dark;

    final newIsDark = !isDark;

    await localDataSource.saveTheme(newIsDark);

    emit(
      newIsDark ? ThemeMode.dark : ThemeMode.light,
    );
  }
}