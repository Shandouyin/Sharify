import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Widget réutilisable pour afficher les états vides
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final double iconSize;
  final Color iconColor;
  final Widget? action;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconSize = 80,
    this.iconColor = Colors.grey,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: iconColor,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppConstants.subtitleStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppConstants.bodyStyle,
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: 16),
              action!,
            ],
          ],
        ),
      ),
    );
  }

  /// Factory pour état vide de musique
  factory EmptyStateWidget.music({
    String title = 'Aucune musique trouvée',
    String subtitle = 'Essayez de modifier vos critères de recherche',
  }) {
    return EmptyStateWidget(
      icon: Icons.music_note,
      title: title,
      subtitle: subtitle,
    );
  }

  /// Factory pour état vide d'amis
  factory EmptyStateWidget.friends() {
    return const EmptyStateWidget(
      icon: Icons.people,
      title: 'Aucun ami pour le moment',
      subtitle: 'Ajoutez des amis pour voir leurs goûts musicaux',
    );
  }

  /// Factory pour état vide de Top 3
  factory EmptyStateWidget.top3() {
    return const EmptyStateWidget(
      icon: Icons.music_note,
      title: 'Aucun Top 3 créé',
      subtitle: 'Créez votre premier Top 3 pour voir votre historique ici !',
    );
  }

  /// Factory pour état vide de statistiques
  factory EmptyStateWidget.statistics() {
    return const EmptyStateWidget(
      icon: Icons.bar_chart,
      title: 'Aucune donnée disponible',
      subtitle: 'Soyez le premier à partager vos favoris !',
    );
  }

  /// Factory pour état vide de profil
  factory EmptyStateWidget.profile({
    String title = 'Aucune musique ajoutée',
    String subtitle = 'Créez votre premier Top 3 !',
  }) {
    return EmptyStateWidget(
      icon: Icons.music_note,
      iconSize: 60,
      title: title,
      subtitle: subtitle,
    );
  }

  /// Factory pour favori non défini
  factory EmptyStateWidget.favorite() {
    return const EmptyStateWidget(
      icon: Icons.favorite_border,
      iconSize: 60,
      title: 'Aucun favori défini',
      subtitle: 'Créez votre Top 3 pour définir un favori !',
    );
  }
}
