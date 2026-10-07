import 'package:flutter/material.dart';

import 'colors.dart';

abstract class AppTheme {
  static final ValueNotifier<ThemeMode> modo = ValueNotifier(ThemeMode.light);

  static void alternarTema(bool escuro) {
    modo.value = escuro ? ThemeMode.dark : ThemeMode.light;
  }

  static ThemeData temaClaro = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppColors.c5,
    primaryColor: AppColors.c1,
    colorScheme: const ColorScheme.light(
      primary: AppColors.c1,
      secondary: AppColors.c3,
      surface: AppColors.c5,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.c5,
      scrimColor: AppColors.c2,
    ),
    iconTheme: const IconThemeData(color: AppColors.c1),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.c1,
      foregroundColor: AppColors.c5,
      shape: CircleBorder(),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.c1,
      foregroundColor: AppColors.c5,
      titleTextStyle: TextStyle(
        color: AppColors.c5,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'PatrickHand',
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.c1,
        foregroundColor: AppColors.c5,
      ),
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.c5,
      titleTextStyle: TextStyle(
        color: AppColors.c1,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'PatrickHand',
      ),
      contentTextStyle: TextStyle(
        color: AppColors.c1,
        fontSize: 16,
        fontFamily: 'PatrickHand',
      ),
    ),
    listTileTheme: const ListTileThemeData(
      textColor: AppColors.c1,
      iconColor: AppColors.c2,
    ),
  );

  static ThemeData temaEscuro = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColors.c1,
    primaryColor: AppColors.c5,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.c4,
      secondary: AppColors.c3,
      surface: AppColors.c2,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.c1,
      scrimColor: AppColors.c5,
    ),
    iconTheme: const IconThemeData(color: AppColors.c5),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.c5,
      foregroundColor: AppColors.c1,
      shape: CircleBorder(),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.c2,
      foregroundColor: AppColors.c5,
      titleTextStyle: TextStyle(
        color: AppColors.c5,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'PatrickHand',
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.c4,
        foregroundColor: AppColors.c1,
      ),
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.c2,
      titleTextStyle: TextStyle(
        color: AppColors.c5,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'PatrickHand',
      ),
      contentTextStyle: TextStyle(
        color: AppColors.c5,
        fontSize: 16,
        fontFamily: 'PatrickHand',
      ),
    ),
    listTileTheme: const ListTileThemeData(
      textColor: AppColors.c5,
      iconColor: AppColors.c4,
    ),
  );
}
