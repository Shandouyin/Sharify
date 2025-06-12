import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'custom_snack_bar.dart';

/// Widget réutilisable pour les options de partage
class ShareOptionsWidget extends StatelessWidget {
  final String shareText;
  final String title;

  const ShareOptionsWidget({
    super.key,
    required this.shareText,
    this.title = 'Partager avec',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppConstants.modalPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Titre
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.white),
            ),
          ),

          // Options de partage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildShareOption(
                context,
                Icons.message,
                Colors.green,
                'Message',
                () {
                  Navigator.pop(context);
                  _simulateShare(context, 'Message', shareText);
                },
              ),
              _buildShareOption(
                context,
                Icons.email,
                Colors.red,
                'Email',
                () {
                  Navigator.pop(context);
                  _simulateShare(context, 'Email', shareText);
                },
              ),
              _buildShareOption(
                context,
                Icons.facebook,
                Colors.blue,
                'Facebook',
                () {
                  Navigator.pop(context);
                  _simulateShare(context, 'Facebook', shareText);
                },
              ),
              _buildShareOption(
                context,
                Icons.link,
                Colors.orange,
                'Copier',
                () {
                  Navigator.pop(context);
                  _simulateShare(context, 'Copier le lien', shareText,
                      isLink: true);
                },
              ),
            ],
          ),

          // Plus d'options
          const SizedBox(height: 20),
          TextButton.icon(
            icon: const Icon(Icons.more_horiz, color: Colors.white70),
            label: const Text(
              'Plus d\'options',
              style: TextStyle(color: Colors.white70),
            ),
            onPressed: () {
              Navigator.pop(context);
              _simulateShare(context, 'Autres applications', shareText);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShareOption(
    BuildContext context,
    IconData icon,
    Color color,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color.withAlpha(51),
            radius: 25,
            child: Icon(icon, color: color, size: 25),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _simulateShare(
    BuildContext context,
    String platform,
    String content, {
    bool isLink = false,
  }) {
    if (isLink) {
      CustomSnackBar.showInfo(
        context,
        message: 'Lien copié dans le presse-papier',
      );
    } else {
      CustomSnackBar.showInfo(
        context,
        message: 'Partage via $platform : "$content"',
      );
    }
  }

  /// Méthode statique pour afficher les options de partage
  static void show({
    required BuildContext context,
    required String shareText,
    String title = 'Partager avec',
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ShareOptionsWidget(
        shareText: shareText,
        title: title,
      ),
    );
  }
}
