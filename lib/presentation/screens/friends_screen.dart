import 'package:flutter/material.dart';
import '../../data/datasources/mock_data_service.dart';
import '../../data/models/user_model.dart';
import '../../data/models/music_model.dart';
import '../../core/widgets/music_card.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/comment_sheet.dart';
import '../../core/widgets/custom_snack_bar.dart';

// Widget pour le bouton Like avec état
class LikeButton extends StatefulWidget {
  final Function() onLikeChanged;
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
            size: 28, // Augmentation de la taille de l'icône
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
        const SizedBox(height: 2), // Espace réduit entre l'icône et le nombre
        Text(
          '$likeCount',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14, // Taille de police augmentée
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

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
    friends = dataService.getFriendsForCurrentUser();    // Initialiser les compteurs avec des données persistantes
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
  }  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _buildFriendsList(),
    );
  }

  Widget _buildFriendsList() {
    if (friends.isEmpty) {
      return _buildEmptyState(
          'No friends yet', 'Add friends to see their music taste');
    }    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 60), // Padding réduit à 60px
      itemCount: friends.length,itemBuilder: (context, index) {
        final friend = friends[index];
        
        // Charger le dernier Top3 de l'ami
        List<MusicModel> friendTopMusic = dataService.getTopMusicForUser(friend.id);
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
            crossAxisAlignment: CrossAxisAlignment.start,            children: [
              // Friend header
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/user-profile', arguments: friend.id);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                          userId: friend.id,
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
                            size: 28, // Augmentation de la taille de l'icône
                          ),
                          onPressed: () {
                            _showShareOptions(context, friend, index);
                          },
                        ),
                        const SizedBox(
                            height:
                                2), // Espace réduit entre l'icône et le nombre
                        Text(
                          '${shareCounts[index]}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14, // Taille de police augmentée
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
                            size: 28, // Augmentation de la taille de l'icône
                          ),
                          onPressed: () {
                            // Afficher une boîte de dialogue pour les commentaires
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled:
                                  true, // Pour que le clavier ne cache pas le champ de texte
                              backgroundColor: Colors.transparent,                              builder: (context) => CommentSheet(
                                username: friend.username,
                                userId: friend.id,
                                onCommentAdded: (count) {
                                  updateCommentCount(index, count);
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                            height:
                                2), // Espace réduit entre l'icône et le nombre
                        Text(
                          '${commentCounts[index]}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14, // Taille de police augmentée
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.people,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            backgroundColor: color.withAlpha(51), // 0.2 * 255 = 51
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

  // Simuler un partage (dans une vraie application, vous utiliseriez un package comme share_plus)
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
