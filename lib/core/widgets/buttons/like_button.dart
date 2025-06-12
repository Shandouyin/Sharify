import 'package:flutter/material.dart';
import '../../../data/datasources/mock_data_service.dart';

/// Widget réutilisable pour le bouton Like avec état
class LikeButton extends StatefulWidget {
  final Function()? onLikeChanged;
  final int initialCount;
  final String userId;
  final MockDataService dataService;

  const LikeButton({
    super.key,
    this.onLikeChanged,
    required this.initialCount,
    required this.userId,
    required this.dataService,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  late bool isLiked;
  late int likeCount;

  @override
  void initState() {
    super.initState();
    likeCount = widget.initialCount;
    // Vérifier si l'utilisateur actuel a déjà liké ce post
    isLiked = widget.dataService.hasUserLikedPost(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : Colors.white,
            size: 28,
          ),
          onPressed: () {
            setState(() {
              if (!isLiked) {
                isLiked = true;
                likeCount = likeCount + 1;
                // Marquer ce post comme liké dans le service
                widget.dataService.likePost(widget.userId);
                if (widget.onLikeChanged != null) {
                  widget.onLikeChanged!();
                }
              } else {
                isLiked = false;
                likeCount = likeCount - 1;
                // Retirer le like de ce post dans le service
                widget.dataService.unlikePost(widget.userId);
                if (widget.onLikeChanged != null) {
                  widget.onLikeChanged!();
                }
              }
            });
          },
        ),
        const SizedBox(height: 2),
        Text(
          '$likeCount',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
