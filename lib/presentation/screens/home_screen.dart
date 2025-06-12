import 'package:flutter/material.dart';
import '../../core/widgets/music_card.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/custom_snack_bar.dart';
import '../../core/widgets/interaction_buttons.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../core/widgets/share_options_widget.dart';
import '../../core/constants/app_constants.dart';
import '../../data/datasources/mock_data_service.dart';
import '../../data/models/music_model.dart';
import '../../data/models/user_model.dart';

// Définition de la couleur personnalisée pour les boutons
const Color customButtonColor = AppConstants.primaryButtonColor;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MockDataService dataService = MockDataService();
  late List<UserModel> communityUsers;
  late List<MusicModel> communityTracks;

  // Compteurs pour les interactions sociales
  final Map<int, int> likeCounts = {};
  final Map<int, int> shareCounts = {};
  final Map<int, int> commentCounts = {};
  final Map<int, bool> followStatus =
      {}; // Pour gérer l'état des boutons Suivre
  @override
  void initState() {
    super.initState();
    communityTracks = dataService.getCommunityTopTracks();

    // Obtenir tous les utilisateurs qui ne sont pas des amis de l'utilisateur actuel
    final UserModel currentUser = dataService.currentUser;
    final List<UserModel> allUsers = dataService.getAllUsers();
    communityUsers = allUsers
        .where((user) =>
            user.id != currentUser.id &&
            !currentUser.friendIds.contains(user.id))
        .toList(); // Initialiser les compteurs avec des données persistantes
    for (int i = 0; i < communityUsers.length; i++) {
      final user = communityUsers[i];
      final interactionData = dataService.getInteractionDataForUser(user.id);

      likeCounts[i] = interactionData['likes']!;
      shareCounts[i] = interactionData['shares']!;

      // Obtenir le vrai nombre de commentaires
      dataService.getCommentsForUser(user.id, user.username);
      int commentCount = dataService.getTotalCommentCount(user.id);
      commentCounts[i] = commentCount;

      // Mettre à jour le compteur dans le service
      dataService.updateCommentCount(user.id, commentCount);

      followStatus[i] = false; // Tous les utilisateurs non suivis par défaut
    }
  }

  void incrementLikes(int userIndex) {
    setState(() {
      // Cette méthode n'est plus utilisée pour incrémenter/décrémenter
      // La logique est maintenant gérée directement dans le LikeButton
      // et synchronisée avec le service de données
      final user = communityUsers[userIndex];
      final interactionData = dataService.getInteractionDataForUser(user.id);
      likeCounts[userIndex] = interactionData['likes']!;
    });
  }

  void updateCommentCount(int userIndex, int count) {
    setState(() {
      commentCounts[userIndex] = count;
    });
  }

  void toggleFollowStatus(int userIndex) {
    setState(() {
      followStatus[userIndex] = !(followStatus[userIndex] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _buildCommunityUsersList(),
    );
  }

  Widget _buildCommunityUsersList() {
    if (communityUsers.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.people,
        title: 'Il n\'y a personne d\'autre',
        subtitle: 'Tous les utilisateurs sont déjà vos amis!',
      );
    }
    return ListView.builder(
      padding:
          const EdgeInsets.fromLTRB(16, 16, 16, 60), // Padding réduit à 60px
      itemCount: communityUsers.length,
      itemBuilder: (context, index) {
        final user = communityUsers[index];

        // Charger le dernier Top3 de l'utilisateur
        List<MusicModel> userTopMusic = dataService.getTopMusicForUser(user.id);
        final lastTop3 = dataService.getLastTop3ForUser(user.id);
        if (lastTop3 != null) {
          userTopMusic = lastTop3.musicIds
              .map((id) => dataService.getMusicById(id))
              .toList();
        }

        final bool isFollowing = followStatus[index] ?? false;

        return GlassContainer(
          blur: 10,
          opacity: 0.25,
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User header
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/user-profile',
                      arguments: user.id);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(user.profilePicture),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.username,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${20 - index % 15}/05/2025', // Date simulée
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 90, // Largeur réduite
                        height: 36, // Hauteur réduite
                        child: ElevatedButton.icon(
                          icon: Icon(
                              isFollowing ? Icons.check : Icons.person_add,
                              size: 16), // Icône plus petite
                          label: Text(
                            isFollowing ? 'Suivi(e)' : 'Suivre',
                            style: TextStyle(fontSize: 12), // Texte plus petit
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isFollowing ? Colors.grey : customButtonColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            fixedSize:
                                const Size(90, 36), // Taille fixe réduite
                            alignment: Alignment.center,
                          ),
                          onPressed: () {
                            toggleFollowStatus(index);
                            CustomSnackBar.showInfo(
                              context,
                              message: isFollowing
                                  ? 'Vous ne suivez plus ${user.username}'
                                  : 'Vous suivez maintenant ${user.username}',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // User's top 3 music
              ...List.generate(
                userTopMusic.length,
                (musicIndex) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: MusicCard(
                    music: userTopMusic[musicIndex],
                    rank: musicIndex + 1,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Boutons d'interaction simplifiés
              InteractionButtons(
                user: user,
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
  } // Méthode pour afficher les options de partage

  void _showShareOptions(BuildContext context, UserModel user, int index) {
    // Incrémenter le compteur de partage
    setState(() {
      shareCounts[index] = (shareCounts[index] ?? 0) + 1;
    });

    // Texte à partager
    final String shareText =
        "Découvre le top 3 musical de ${user.username} sur Sharify!";

    // Utiliser le nouveau widget de partage
    ShareOptionsWidget.show(
      context: context,
      shareText: shareText,
    );
  }
}
