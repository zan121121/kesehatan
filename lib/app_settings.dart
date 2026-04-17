import 'package:flutter/material.dart';

class AppSettings {
  static ValueNotifier<bool> isDarkMode = ValueNotifier(false);
  static ValueNotifier<Locale> locale =
      ValueNotifier(const Locale('id')); // default Indonesia
}