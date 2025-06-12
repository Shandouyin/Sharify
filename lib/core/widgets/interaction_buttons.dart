import 'package:flutter/material.dart';
import '../../data/datasources/mock_data_service.dart';
import '../../data/models/user_model.dart';
import '../constants/app_constants.dart';
import 'comment_sheet.dart';
import 'like_button.dart';

/// Widget réutilisable pour les boutons d'interaction (like, share, comment)
class InteractionButtons extends StatelessWidget {
  final UserModel user;
  final int index;
  final Map<int, int> likeCounts;
  final Map<int, int> shareCounts;
  final Map<int, int> commentCounts;
  final MockDataService dataService;
  final VoidCallback? onLikeChanged;
  final Function(int, int)? onCommentUpdate;
  final Function(BuildContext, UserModel, int)? onShare;

  const InteractionButtons({
    super.key,
    required this.user,
    required this.index,
    required this.likeCounts,
    required this.shareCounts,
    required this.commentCounts,
    required this.dataService,
    this.onLikeChanged,
    this.onCommentUpdate,
    this.onShare,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Bouton Like
          Column(
            children: [
              LikeButton(
                initialCount: likeCounts[index] ?? 0,
                userId: user.id,
                dataService: dataService,
                onLikeChanged: onLikeChanged,
              ),
            ],
          ),

          // Bouton Share
          Column(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.share,
                  color: Colors.white,
                  size: AppConstants.iconSize,
                ),
                onPressed: () {
                  onShare?.call(context, user, index);
                },
              ),
              const SizedBox(height: 2),
              Text(
                '${shareCounts[index] ?? 0}',
                style: AppConstants.countStyle,
              ),
            ],
          ),

          // Bouton Comment
          Column(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.comment,
                  color: Colors.white,
                  size: AppConstants.iconSize,
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => CommentSheet(
                      username: user.username,
                      userId: user.id,
                      onCommentAdded: (count) {
                        onCommentUpdate?.call(index, count);
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 2),
              Text(
                '${commentCounts[index] ?? 0}',
                style: AppConstants.countStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
