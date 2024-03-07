import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemePreference {
  static ValueNotifier<Brightness> tema = ValueNotifier(Brightness.light);

  static setTema() {
    tema.value = WidgetsBinding.instance!.platformDispatcher.platformBrightness;
  }

  static changeStatusNavigationBar() {
    bool isDark = tema.value == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: isDark ? Color(0xFFFFFFFF) : Color(0xFF000000),
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark
      
    ));
  }
}
