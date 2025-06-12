import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Widget réutilisable pour les bottom sheets avec style unifié
class SharedBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const SharedBottomSheet({
    super.key,
    required this.title,
    required this.child,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? AppConstants.modalHeight,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: AppConstants.handleBarWidth,
            height: AppConstants.handleBarHeight,
            margin: const EdgeInsets.only(top: 12, bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Titre
          Text(
            title,
            style: AppConstants.titleStyle,
          ),

          const SizedBox(height: 16),

          // Contenu principal
          Expanded(
            child: Padding(
              padding: padding ?? AppConstants.modalPadding,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  /// Méthode statique pour afficher le bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    double? height,
    EdgeInsetsGeometry? padding,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (context) => SharedBottomSheet(
        title: title,
        height: height,
        padding: padding,
        child: child,
      ),
    );
  }
}
