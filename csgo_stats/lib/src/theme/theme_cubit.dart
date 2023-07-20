import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

/// {@template brightness_cubit}
/// A simple [Cubit] that manages the [ThemeData] as its state.
/// {@endtemplate}
class ThemeCubit extends Cubit<ThemeData> {
  /// {@macro brightness_cubit}
  ThemeCubit() : super(_lightTheme);

  Typography get typography => Typography.material2021();

  static final _lightTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
    ),
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color.fromARGB(255, 1, 26, 58),
      onPrimary: Color.fromARGB(255, 255, 255, 255),
      secondary: Color.fromRGBO(0, 92, 108, 1),
      onSecondary: Color.fromRGBO(255, 255, 255, 1),
      error: Color.fromRGBO(103, 0, 0, 1),
      onError: Color.fromRGBO(255, 255, 255, 1),
      background: Color.fromARGB(255, 60, 37, 37),
      onBackground: Color.fromARGB(255, 255, 255, 255),
      surface: Color.fromARGB(255, 241, 241, 241),
      onSurface: Color.fromRGBO(0, 40, 80, 1),
    ),
    textTheme: TextTheme(
      bodySmall: GoogleFonts.getFont(
        "Montserrat Alternates",
        color: Colors.black,
        wordSpacing: 0,
      ),
      bodyMedium: GoogleFonts.getFont(
        "Montserrat Alternates",
        color: Colors.black,
        wordSpacing: 0,
      ),
      // Body Large is used for the markdown pages paragraphs
      bodyLarge: GoogleFonts.getFont(
        "Montserrat Alternates",
        color: Colors.black,
        wordSpacing: 0,
        fontSize: 15,
      ),
      displayLarge: GoogleFonts.getFont(
        "Montserrat Alternates",
        color: Colors.black,
        wordSpacing: 0,
      ),
      displayMedium: GoogleFonts.getFont(
        "Montserrat Alternates",
        color: Colors.black,
        wordSpacing: 0,
      ),
      displaySmall: GoogleFonts.getFont(
        "Montserrat Alternates",
        color: Colors.black,
        wordSpacing: 0,
      ),
      // Used for the markdown pages title
      headlineLarge: GoogleFonts.getFont(
        "Montserrat Alternates",
        color: Colors.white,
        wordSpacing: 0,
        fontSize: 35,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: GoogleFonts.getFont(
        "Montserrat Alternates",
        color: Colors.black,
        wordSpacing: 0,
      ),
      headlineSmall: GoogleFonts.getFont(
        "Montserrat Alternates",
        color: Colors.white,
        wordSpacing: 0,
        fontSize: 17.0,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.getFont(
        "Montserrat Alternates",
        color: Colors.black,
        wordSpacing: 0,
      ),
      titleMedium: GoogleFonts.getFont(
        "Montserrat Alternates",
        color: Colors.black,
        wordSpacing: 0,
      ),
      titleSmall: GoogleFonts.getFont(
        "Montserrat Alternates",
        color: Colors.black,
        wordSpacing: 0,
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 1, 26, 58),
      indicatorColor: Colors.white,
    ),

    // colorScheme:
  );

  static final _darkTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.black,
    ),
    textTheme: TextTheme(
      bodySmall: GoogleFonts.getFont(
        "Montserrat Alternates",
        color: Colors.white,
        wordSpacing: 0,
      ),
      bodyMedium: GoogleFonts.getFont(
        "Montserrat Alternates",
        color: Colors.white,
        wordSpacing: 0,
      ),
      // Body Large is used for the markdown pages paragraphs
      bodyLarge: GoogleFonts.getFont(
        "Montserrat Alternates",
        color: Colors.white,
        wordSpacing: 0,
        fontSize: 15,
      ),
      displayLarge: GoogleFonts.getFont(
        "Montserrat Alternates",
        color: Colors.white,
        wordSpacing: 0,
      ),
      displayMedium: GoogleFonts.getFont(
        "Montserrat Alternates",
        color: Colors.white,
        wordSpacing: 0,
      ),
      displaySmall: GoogleFonts.getFont(
        "Montserrat Alternates",
        color: Colors.white,
        wordSpacing: 0,
      ),
      // Used for the markdown pages title
      headlineLarge: GoogleFonts.getFont(
        "Montserrat Alternates",
        color: Colors.white,
        wordSpacing: 0,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: GoogleFonts.getFont(
        "Montserrat Alternates",
        color: Colors.white,
        wordSpacing: 0,
      ),
      headlineSmall: GoogleFonts.getFont(
        "Montserrat Alternates",
        color: Colors.white,
        wordSpacing: 0,
        fontSize: 17.0,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.getFont(
        "Montserrat Alternates",
        color: Colors.white,
        wordSpacing: 0,
      ),
      titleMedium: GoogleFonts.getFont(
        "Montserrat Alternates",
        color: Colors.white,
        wordSpacing: 0,
      ),
      titleSmall: GoogleFonts.getFont(
        "Montserrat Alternates",
        color: Colors.white,
        wordSpacing: 0,
      ),
    ),
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color.fromARGB(255, 1, 26, 58),
      onPrimary: Color.fromARGB(255, 255, 255, 255),
      secondary: Color.fromRGBO(255, 255, 255, 1),
      onSecondary: Color.fromRGBO(255, 255, 255, 1),
      error: Color.fromRGBO(255, 255, 255, 1),
      onError: Color.fromRGBO(255, 255, 255, 1),
      background: Color.fromARGB(255, 255, 255, 255),
      onBackground: Color.fromARGB(255, 255, 255, 255),
      surface: Color.fromARGB(255, 241, 241, 241),
      onSurface: Color.fromRGBO(79, 80, 0, 1),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 1, 26, 58),
      indicatorColor: Colors.white,
    ),
  );

  /// Toggles the current brightness between light and dark.
  void toggleTheme() {
    emit(state.brightness == Brightness.dark ? _lightTheme : _darkTheme);
  }
}