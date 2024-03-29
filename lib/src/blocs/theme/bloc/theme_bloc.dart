import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:filimo/src/utils/global/theme/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeData: appThemeData[AppTheme.Dark]));

  @override
  ThemeState get initialState => ThemeState(themeData: appThemeData[AppTheme.Dark]);

  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    
    if(event is ThemeChanged){
      yield ThemeState(themeData: appThemeData[event.theme]);
    }
  }
}
