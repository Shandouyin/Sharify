import 'package:flutter/material.dart';

/// Constantes centralisées pour l'application Sharify
class AppConstants {
  // Couleurs
  static const Color primaryButtonColor = Color(0xFF0F7ACC);
  static const Color goldColor = Color(0xFFF0C300);
  static const Color silverColor = Color(0xFFF0F0F0);
  static const Color bronzeColor = Color(0xFFAD390E);

  // Couleurs avec alpha pour les arrière-plans
  static final Color goldBackgroundColor = goldColor.withAlpha(64);
  static final Color silverBackgroundColor = silverColor.withAlpha(64);
  static final Color bronzeBackgroundColor = bronzeColor.withAlpha(64);

  // Dimensions communes
  static const double modalHeight = 600.0;
  static const double handleBarWidth = 40.0;
  static const double handleBarHeight = 4.0;
  static const double borderRadius = 12.0;
  static const double buttonHeight = 40.0;
  static const double profileImageRadius = 24.0;
  static const double iconSize = 28.0;

  // Espacements
  static const EdgeInsets modalPadding = EdgeInsets.all(16);
  static const EdgeInsets cardPadding = EdgeInsets.all(8);
  static const EdgeInsets screenPadding = EdgeInsets.fromLTRB(16, 16, 16, 60);

  // Styles de texte communs
  static const TextStyle titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: Colors.white70,
  );

  static const TextStyle countStyle = TextStyle(
    color: Colors.white70,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  // Méthodes utilitaires pour les couleurs de rang
  static Color getRankBackgroundColor(int rank) {
    switch (rank) {
      case 1:
        return goldBackgroundColor;
      case 2:
        return silverBackgroundColor;
      case 3:
        return bronzeBackgroundColor;
      default:
        return Colors.grey.withAlpha(64);
    }
  }

  static Color getRankBorderColor(int rank) {
    switch (rank) {
      case 1:
        return goldColor;
      case 2:
        return silverColor;
      case 3:
        return bronzeColor;
      default:
        return Colors.grey;
    }
  }

  static Color getRankButtonColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFF9900); // Gold button
      case 2:
        return const Color(0xFFC1D4ED); // Silver button
      case 3:
        return const Color(0xFFB74210); // Bronze button
      default:
        return Colors.grey;
    }
  }
}
