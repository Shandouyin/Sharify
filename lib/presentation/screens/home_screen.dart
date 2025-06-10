import 'package:flutter/material.dart';
import '../../core/widgets/music_card.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/comment_sheet.dart';
import '../../core/widgets/custom_snack_bar.dart';
import '../../data/datasources/mock_data_service.dart';
import '../../data/models/music_model.dart';
import '../../data/models/user_model.dart';

// Widget pour le bouton Like avec état (repris de la page amis)
class LikeButton extends StatefulWidget {  final Function() onLikeChanged;
  final int initialCount;
  final String userId;
  final MockDataService dataService;

  const LikeButton({
    super.key, 
    required this.onLikeChanged, 
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
          ),          onPressed: () {
            setState(() {
              if (!isLiked) {
                isLiked = true;
                likeCount = likeCount + 1;
                // Marquer ce post comme liké dans le service
                widget.dataService.likePost(widget.userId);
                widget.onLikeChanged();
              } else {
                isLiked = false;
                likeCount = likeCount - 1;
                // Retirer le like de ce post dans le service
                widget.dataService.unlikePost(widget.userId);
                widget.onLikeChanged();
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

// Définition de la couleur personnalisée pour les boutons
const Color customButtonColor = Color(0xFF0F7ACC);

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
        .toList();    // Initialiser les compteurs avec des données persistantes
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
  }  void incrementLikes(int userIndex) {
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
      return _buildEmptyState('Il n\'y a personne d\'autre',
          'Tous les utilisateurs sont déjà vos amis!');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: communityUsers.length,      itemBuilder: (context, index) {
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
            crossAxisAlignment: CrossAxisAlignment.start,            children: [              // User header
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/user-profile', arguments: user.id);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                      ),                      SizedBox(
                        width: 90, // Largeur réduite
                        height: 36, // Hauteur réduite
                        child: ElevatedButton.icon(
                          icon: Icon(isFollowing ? Icons.check : Icons.person_add,
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
                            fixedSize: const Size(90, 36), // Taille fixe réduite
                            alignment: Alignment.center,
                          ),
                          onPressed: () {                            toggleFollowStatus(index);
                            CustomSnackBar.showInfo(
                              context,
                              message: isFollowing
                                  ? 'Vous ne suivez plus ${user.username}'
                                  : 'Vous suivez maintenant ${user.username}',
                            );
                          },
                        ),                      ),
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
              // Ajout des icônes d'interaction
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Icône de cœur (Like) avec compteur
                    Column(
                      children: [                        LikeButton(
                          initialCount: likeCounts[index] ?? 0,
                          userId: user.id,
                          dataService: dataService,
                          onLikeChanged: () => incrementLikes(index),
                        ),
                      ],
                    ),

                    // Icône de partage avec compteur
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            _showShareOptions(context, user, index);
                          },
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${shareCounts[index]}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    // Icône de commentaire avec compteur
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.comment,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,                              builder: (context) => CommentSheet(
                                username: user.username,
                                userId: user.id,
                                onCommentAdded: (count) {
                                  updateCommentCount(index, count);
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${commentCounts[index]}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.music_note,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour afficher les options de partage
  void _showShareOptions(BuildContext context, UserModel user, int index) {
    // Incrémenter le compteur de partage
    setState(() {
      shareCounts[index] = (shareCounts[index] ?? 0) + 1;
    });

    // Texte à partager
    final String shareText =
        "Découvre le top 3 musical de ${user.username} sur Sharify!";

    // Afficher une boîte de dialogue modale avec les options de partage
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Titre
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'Partager avec',
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
                      context, Icons.message, Colors.green, 'Message', () {
                    Navigator.pop(context);
                    _simulateShare(context, 'Message', shareText);
                  }),
                  _buildShareOption(context, Icons.email, Colors.red, 'Email',
                      () {
                    Navigator.pop(context);
                    _simulateShare(context, 'Email', shareText);
                  }),
                  _buildShareOption(
                      context, Icons.facebook, Colors.blue, 'Facebook', () {
                    Navigator.pop(context);
                    _simulateShare(context, 'Facebook', shareText);
                  }),
                  _buildShareOption(
                      context, Icons.link, Colors.orange, 'Copier', () {
                    Navigator.pop(context);
                    _simulateShare(context, 'Copier le lien', shareText,
                        isLink: true);
                  }),
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
      },
    );
  }

  // Construire une option de partage individuelle
  Widget _buildShareOption(BuildContext context, IconData icon, Color color,
      String label, VoidCallback onTap) {
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

  // Simuler un partage
  void _simulateShare(BuildContext context, String platform, String content,
      {bool isLink = false}) {    if (isLink) {
      // Simuler la copie du lien
      CustomSnackBar.showInfo(
        context,
        message: 'Lien copié dans le presse-papier',
      );
    } else {
      // Simuler le partage sur la plateforme spécifiée
      CustomSnackBar.showInfo(
        context,
        message: 'Partage via $platform : "$content"',
      );
    }
  }
}
