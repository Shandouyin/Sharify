import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class CustomSnackBar {
  /// Affiche une SnackBar avec la couleur personnalisée de l'app
  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    Color? backgroundColor,
    Color textColor = Colors.white,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor),
        ),
        duration: duration,
        backgroundColor: backgroundColor ?? AppTheme.snackBarColor,
      ),
    );
  }

  /// Affiche une SnackBar de succès avec la couleur personnalisée
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    show(
      context,
      message: message,
      duration: duration,
      backgroundColor: AppTheme.snackBarColor,
    );
  }

  /// Affiche une SnackBar d'erreur en rouge (pour les erreurs de création du Top 3)
  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    show(
      context,
      message: message,
      duration: duration,
      backgroundColor: Colors.red,
    );
  }

  /// Affiche une SnackBar d'information avec la couleur personnalisée
  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    show(
      context,
      message: message,
      duration: duration,
      backgroundColor: AppTheme.snackBarColor,
    );
  }
}
