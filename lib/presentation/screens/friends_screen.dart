import 'package:flutter/material.dart';
import '../../data/datasources/mock_data_service.dart';
import '../../data/models/user_model.dart';
import '../../core/widgets/music_card.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/comment_sheet.dart';

// Widget pour le bouton Like avec état
class LikeButton extends StatefulWidget {
  final Function() onLikeChanged;
  final int initialCount;

  const LikeButton(
      {super.key, required this.onLikeChanged, required this.initialCount});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;
  late int likeCount;

  @override
  void initState() {
    super.initState();
    likeCount = widget.initialCount;
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
          ),
          onPressed: () {
            setState(() {
              isLiked = !isLiked;
              likeCount = isLiked ? likeCount + 1 : likeCount - 1;
              widget.onLikeChanged();
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
    friends = dataService.getFriendsForCurrentUser();

    // Initialiser les compteurs avec des valeurs par défaut
    for (int i = 0; i < friends.length; i++) {
      likeCounts[i] = 24 + (i % 3);
      shareCounts[i] = 8 + (i % 4);
      commentCounts[i] = 12 + (i % 5);
    }
  }

  void incrementLikes(int friendIndex) {
    setState(() {
      likeCounts[friendIndex] = (likeCounts[friendIndex] ?? 0) + 1;
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
      return _buildEmptyState(
          'No friends yet', 'Add friends to see their music taste');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        final friendTopMusic = dataService.getTopMusicForUser(friend.id);

        return GlassContainer(
          blur: 10,
          opacity: 0.25,
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Friend header
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                leading: CircleAvatar(
                  radius: 28, // Taille augmentée (par défaut c'était ~20)
                  backgroundImage: NetworkImage(friend.profilePicture),
                ),
                title: Text(
                  friend.username,
                  style: const TextStyle(
                    fontSize: 18, // Taille de police augmentée
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                    '${20 - index}/05/2025'), // Date simulée différente pour chaque ami
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
                      children: [
                        LikeButton(
                          initialCount: likeCounts[index] ?? 0,
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
                              backgroundColor: Colors.transparent,
                              builder: (context) => CommentSheet(
                                username: friend.username,
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
      {bool isLink = false}) {
    if (isLink) {
      // Simuler la copie du lien
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lien copié dans le presse-papier'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Simuler le partage sur la plateforme spécifiée
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Partage via $platform : "$content"'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
