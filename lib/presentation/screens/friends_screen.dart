import 'package:flutter/material.dart';
import '../../data/datasources/mock_data_service.dart';
import '../../data/models/user_model.dart';
import '../../data/models/music_model.dart';
import '../../core/widgets/music_card.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/interaction_buttons.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../core/widgets/share_options_widget.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final MockDataService dataService = MockDataService();
  late List<UserModel> friends;

  // Compteurs pour les interactions sociales
  final Map<int, int> likeCounts = {};
  final Map<int, int> shareCounts = {};
  final Map<int, int> commentCounts = {};
  @override
  void initState() {
    super.initState();
    friends = dataService
        .getFriendsForCurrentUser(); // Initialiser les compteurs avec des données persistantes
    for (int i = 0; i < friends.length; i++) {
      final friend = friends[i];
      final interactionData = dataService.getInteractionDataForUser(friend.id);

      likeCounts[i] = interactionData['likes']!;
      shareCounts[i] = interactionData['shares']!;

      // Obtenir le vrai nombre de commentaires
      dataService.getCommentsForUser(friend.id, friend.username);
      int commentCount = dataService.getTotalCommentCount(friend.id);
      commentCounts[i] = commentCount;

      // Mettre à jour le compteur dans le service
      dataService.updateCommentCount(friend.id, commentCount);
    }
  }

  void incrementLikes(int friendIndex) {
    setState(() {
      // Cette méthode n'est plus utilisée pour incrémenter/décrémenter
      // La logique est maintenant gérée directement dans le LikeButton
      // et synchronisée avec le service de données
      final friend = friends[friendIndex];
      final interactionData = dataService.getInteractionDataForUser(friend.id);
      likeCounts[friendIndex] = interactionData['likes']!;
    });
  }

  void updateCommentCount(int friendIndex, int count) {
    setState(() {
      commentCounts[friendIndex] = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _buildFriendsList(),
    );
  }

  Widget _buildFriendsList() {
    if (friends.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.people,
        title: 'No friends yet',
        subtitle: 'Add friends to see their music taste',
      );
    }
    return ListView.builder(
      padding:
          const EdgeInsets.fromLTRB(16, 16, 16, 60), // Padding réduit à 60px
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];

        // Charger le dernier Top3 de l'ami
        List<MusicModel> friendTopMusic =
            dataService.getTopMusicForUser(friend.id);
        final lastTop3 = dataService.getLastTop3ForUser(friend.id);
        if (lastTop3 != null) {
          friendTopMusic = lastTop3.musicIds
              .map((id) => dataService.getMusicById(id))
              .toList();
        }

        return GlassContainer(
          blur: 10,
          opacity: 0.25,
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Friend header
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/user-profile',
                      arguments: friend.id);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24, // Taille réduite de 28 à 24
                        backgroundImage: NetworkImage(friend.profilePicture),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              friend.username,
                              style: const TextStyle(
                                fontSize: 16, // Taille réduite de 18 à 16px
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${20 - index}/05/2025', // Date simulée différente pour chaque ami
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Friend's top 3 music
              ...List.generate(
                friendTopMusic.length,
                (musicIndex) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: MusicCard(
                    music: friendTopMusic[musicIndex],
                    rank: musicIndex + 1,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Boutons d'interaction simplifiés
              InteractionButtons(
                user: friend,
                index: index,
                likeCounts: likeCounts,
                shareCounts: shareCounts,
                commentCounts: commentCounts,
                dataService: dataService,
                onLikeChanged: () => incrementLikes(index),
                onCommentUpdate: updateCommentCount,
                onShare: _showShareOptions,
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // Méthode pour afficher les options de partage
  void _showShareOptions(BuildContext context, UserModel friend, int index) {
    // Incrémenter le compteur de partage
    setState(() {
      shareCounts[index] = (shareCounts[index] ?? 0) + 1;
    });

    // Texte à partager
    final String shareText =
        "Découvre le top 3 musical de ${friend.username} sur Sharify!";

    // Utiliser le nouveau widget de partage
    ShareOptionsWidget.show(
      context: context,
      shareText: shareText,
    );
  }
}
