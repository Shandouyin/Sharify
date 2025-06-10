import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const primaryColor = Color(0xFF0F7ACC); // Couleur bleue utilisée dans l'app
  static const secondaryColor = Color(0xFF191414); // Spotify black
  static const backgroundColor = Color(0xFFF5F5F5);
  static const cardColor = Colors.white;
  static const errorColor = Color(0xFFE57373);
  static const snackBarColor = Color(0xFF0F7ACC); // Couleur personnalisée pour les SnackBars  // Light theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0F7ACC), // Couleur bleue cohérente
      brightness: Brightness.light,
      primary: const Color(0xFF0F7ACC),
      secondary: Colors.white70,
      surface: Colors.white,
      onSurface: Colors.white, // Texte blanc sur les surfaces
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      error: errorColor,
    ),
    scaffoldBackgroundColor: Colors.white,
    // Garder le même style de texte blanc que le thème sombre
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.white),
      displayMedium: TextStyle(color: Colors.white),
      displaySmall: TextStyle(color: Colors.white),
      headlineLarge: TextStyle(color: Colors.white),
      headlineMedium: TextStyle(color: Colors.white),
      headlineSmall: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
      titleSmall: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white70),
      labelLarge: TextStyle(color: Colors.white),
      labelMedium: TextStyle(color: Colors.white),
      labelSmall: TextStyle(color: Colors.white70),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFFF8F8F8), // Gris très clair pour les cartes
      elevation: 2,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.white, // Texte blanc dans l'AppBar
      elevation: 0,
      scrolledUnderElevation: 0, // Désactive l'effet d'élévation lors du défilement
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0F7ACC),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Boutons arrondis comme dans l'app
        ),
      ),
    ),
  );// Dark theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0F7ACC), // Couleur bleue cohérente
      brightness: Brightness.dark,
      primary: const Color(0xFF0F7ACC),
      secondary: Colors.white70,
      surface: const Color(0xFF121212), // Noir plus profond pour correspondre à l'app
      onSurface: Colors.white, // Texte sur les surfaces
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      error: errorColor,
    ),
    scaffoldBackgroundColor: Colors.black,
    // Définir les couleurs de texte globales pour le thème sombre
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.white),
      displayMedium: TextStyle(color: Colors.white),
      displaySmall: TextStyle(color: Colors.white),
      headlineLarge: TextStyle(color: Colors.white),
      headlineMedium: TextStyle(color: Colors.white),
      headlineSmall: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
      titleSmall: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white70),
      labelLarge: TextStyle(color: Colors.white),
      labelMedium: TextStyle(color: Colors.white),
      labelSmall: TextStyle(color: Colors.white70),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E), // Gris sombre pour les cartes
      elevation: 2,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0, // Désactive l'effet d'élévation lors du défilement
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0F7ACC),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Boutons arrondis comme dans l'app
        ),
      ),
    ),
  );
}
