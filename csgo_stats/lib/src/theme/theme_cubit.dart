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
      primary: Color.fromARGB(255, 233, 81, 0),
      onPrimary: Color.fromARGB(255, 255, 255, 255),
      secondary: Color.fromRGBO(0, 92, 108, 1),
      onSecondary: Color.fromRGBO(255, 255, 255, 1),
      error: Color.fromRGBO(103, 0, 0, 1),
      onError: Color.fromRGBO(255, 255, 255, 1),
      background: Color.fromARGB(255, 0, 0, 0),
      onBackground: Color.fromARGB(255, 232, 232, 232),
      surface: Color.fromARGB(255, 241, 241, 241),
      onSurface: Color.fromRGBO(0, 40, 80, 1),
    ),
    textTheme: TextTheme(
      bodySmall: GoogleFonts.getFont(
        "Raleway",
        color: Colors.black,
        wordSpacing: 0,
      ),
      bodyMedium: GoogleFonts.getFont(
        "Raleway",
        color: Colors.black,
        wordSpacing: 0,
      ),
      // Body Large is used for the markdown pages paragraphs
      bodyLarge: GoogleFonts.getFont(
        "Raleway",
        color: Colors.black,
        wordSpacing: 0,
        fontSize: 15,
      ),
      displayLarge: GoogleFonts.getFont(
        "Raleway",
        color: Colors.black,
        wordSpacing: 0,
      ),
      displayMedium: GoogleFonts.getFont(
        "Raleway",
        color: Colors.black,
        wordSpacing: 0,
      ),
      displaySmall: GoogleFonts.getFont(
        "Raleway",
        color: Colors.black,
        wordSpacing: 0,
      ),
      // Used for the markdown pages title
      headlineLarge: GoogleFonts.getFont(
        "Raleway",
        color: Colors.white,
        wordSpacing: 0,
        fontSize: 35,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: GoogleFonts.getFont(
        "Raleway",
        color: Colors.black,
        wordSpacing: 0,
      ),
      headlineSmall: GoogleFonts.getFont(
        "Raleway",
        color: Colors.white,
        wordSpacing: 0,
        fontSize: 17.0,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.getFont(
        "Raleway",
        color: Colors.black,
        wordSpacing: 0,
      ),
      titleMedium: GoogleFonts.getFont(
        "Raleway",
        color: Colors.black,
        wordSpacing: 0,
      ),
      titleSmall: GoogleFonts.getFont(
        "Raleway",
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
        "Raleway",
        color: Colors.white,
        wordSpacing: 0,
      ),
      bodyMedium: GoogleFonts.getFont(
        "Raleway",
        color: Colors.white,
        wordSpacing: 0,
      ),
      // Body Large is used for the markdown pages paragraphs
      bodyLarge: GoogleFonts.getFont(
        "Raleway",
        color: Colors.white,
        wordSpacing: 0,
        fontSize: 15,
      ),
      displayLarge: GoogleFonts.getFont(
        "Raleway",
        color: Colors.white,
        wordSpacing: 0,
      ),
      displayMedium: GoogleFonts.getFont(
        "Raleway",
        color: Colors.white,
        wordSpacing: 0,
      ),
      displaySmall: GoogleFonts.getFont(
        "Raleway",
        color: Colors.white,
        wordSpacing: 0,
      ),
      // Used for the markdown pages title
      headlineLarge: GoogleFonts.getFont(
        "Raleway",
        color: Colors.white,
        wordSpacing: 0,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: GoogleFonts.getFont(
        "Raleway",
        color: Colors.white,
        wordSpacing: 0,
      ),
      headlineSmall: GoogleFonts.getFont(
        "Raleway",
        color: Colors.white,
        wordSpacing: 0,
        fontSize: 17.0,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.getFont(
        "Raleway",
        color: Colors.white,
        wordSpacing: 0,
      ),
      titleMedium: GoogleFonts.getFont(
        "Raleway",
        color: Colors.white,
        wordSpacing: 0,
      ),
      titleSmall: GoogleFonts.getFont(
        "Raleway",
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

  static const darkShimmerGradient = LinearGradient(
    colors: [
      Color.fromRGBO(66, 73, 93, 1),
      Color.fromRGBO(58, 64, 82, 1),
      Color.fromRGBO(50, 55, 70, 1),
      Color.fromRGBO(58, 64, 82, 1),
      Color.fromRGBO(66, 73, 93, 1),
    ],
    stops: [0.0, 0.2, 0.5, 0.8, 1],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const lightShimmerGradient = LinearGradient(
    colors: [
      Color.fromRGBO(203, 209, 212, 1),
      Color.fromRGBO(192, 203, 208, 1),
      Color.fromRGBO(182, 194, 199, 1),
      Color.fromRGBO(195, 204, 208, 1),
      Color.fromRGBO(204, 214, 217, 1),
    ],
    stops: [0.0, 0.2, 0.5, 0.8, 1],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Toggles the current brightness between light and dark.
  void toggleTheme() {
    emit(state.brightness == Brightness.dark ? _lightTheme : _darkTheme);
  }
}
