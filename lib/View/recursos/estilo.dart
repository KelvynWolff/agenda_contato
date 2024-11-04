import 'package:flutter/material.dart';

ThemeData estilo() {
  ThemeData base = ThemeData.dark();
  return base.copyWith(
      primaryColor: Colors.grey.shade900,
      colorScheme: ColorScheme.dark(),

      //Botão Flutuante
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: Colors.orange));
}
