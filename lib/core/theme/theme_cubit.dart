import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void toggleTheme(bool isCurrentlyDark) {
    if (state == ThemeMode.system) {
      emit(isCurrentlyDark ? ThemeMode.light : ThemeMode.dark);
    } else {
      emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
    }
  }

  void setTheme(ThemeMode mode) {
    emit(mode);
  }
}
