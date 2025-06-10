import 'package:flutter/material.dart';
import '../../data/datasources/mock_data_service.dart';
import '../../data/models/user_model.dart';
import '../../data/models/music_model.dart';
import '../../core/widgets/music_card.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/vertical_bar_chart.dart';
import '../../core/widgets/background_container.dart';
import '../../core/widgets/custom_snack_bar.dart';

// Définition de la couleur personnalisée pour les boutons (même que profile_screen.dart)
const Color customButtonColor = Color(0xFF0F7ACC);

class UserProfileScreen extends StatefulWidget {
  final String userId;
  
  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool isFollowing = false;
  late int followersCount;
  @override
  void initState() {
    super.initState();
    final MockDataService dataService = MockDataService();
    final UserModel currentUser = dataService.currentUser;
    
    // Vérifier si l'utilisateur actuel suit déjà cet utilisateur
    isFollowing = currentUser.friendIds.contains(widget.userId);
    
    // Initialiser le compteur de followers (simulé avec un calcul basé sur l'ID)
    // Si l'utilisateur actuel suit déjà, le compteur inclut déjà ce suivi
    followersCount = 95 + (widget.userId.hashCode % 50);
    if (isFollowing) {
      // Le compteur de base inclut déjà notre suivi
      // Pas besoin d'ajuster
    }
  }  @override
  Widget build(BuildContext context) {
    final MockDataService dataService = MockDataService();
    final UserModel targetUser = dataService.getUserById(widget.userId);
    
    // Charger le dernier Top3 de l'utilisateur pour afficher dans la section "Dernier top 3"
    List<MusicModel> userTopMusic = dataService.getTopMusicForUser(widget.userId);
    final lastTop3 = dataService.getLastTop3ForUser(widget.userId);
    if (lastTop3 != null) {
      // Remplacer par les musiques du dernier Top3
      userTopMusic = lastTop3.musicIds
          .map((id) => dataService.getMusicById(id))
          .toList();
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Profil de ${targetUser.username}'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BackgroundContainer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: GlassContainer(
            blur: 10,
            opacity: 0.25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête du profil avec image à gauche et infos à droite
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Image de profil à gauche
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(targetUser.profilePicture),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Informations utilisateur à droite
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              targetUser.username,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '@${targetUser.username.toLowerCase()}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                  // Statistiques : Suivi(e)s, Followers et J'aimes
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatColumn('${targetUser.friendIds.length}', 'Suivi(e)s'),
                      _buildStatColumn('$followersCount', 'Followers'),
                      _buildStatColumn('${250 + (targetUser.id.hashCode % 200)}', 'J\'aimes'),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                
                // Boutons Suivre et Partager
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // Bouton "Suivre/Suivi(e)"
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton.icon(
                            icon: Icon(
                              isFollowing ? Icons.check : Icons.person_add,
                              size: 18,
                            ),
                            label: Text(
                              isFollowing ? 'Suivi(e)' : 'Suivre',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),                            onPressed: () {
                              setState(() {
                                isFollowing = !isFollowing;
                                // Mettre à jour le compteur de followers
                                if (isFollowing) {
                                  followersCount++;
                                } else {
                                  followersCount--;
                                }
                              });                              CustomSnackBar.showInfo(
                                context,
                                message: isFollowing
                                    ? 'Vous suivez maintenant ${targetUser.username}'
                                    : 'Vous ne suivez plus ${targetUser.username}',
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isFollowing ? Colors.grey : customButtonColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Bouton "Partager"
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              _showShareOptions(context, targetUser);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: customButtonColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Partager',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Section Son préféré
                _buildFavoriteMusic(context, userTopMusic),
                
                const SizedBox(height: 30),
                
                // Section Dernier top 3
                _buildUserTopMusic(context, userTopMusic),
                
                const SizedBox(height: 20),
                
                // Bouton Voir Plus
                _buildViewMoreButton(context, targetUser),
                
                const SizedBox(height: 30),
                
                // Titre Statistiques
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Statistiques",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Charts section
                _buildChartsSection(context, targetUser),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // Widget pour construire une colonne de statistiques
  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
  
  // Méthode pour afficher les options de partage
  void _showShareOptions(BuildContext context, UserModel user) {
    final String shareText = "Découvre le profil de ${user.username} sur Sharify!";

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
                  'Partager le profil',
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

  Widget _buildUserTopMusic(BuildContext context, List<MusicModel> topMusic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "Dernier top 3",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        if (topMusic.isEmpty)
          Container(
            width: double.infinity,
            child: const Column(
              children: [
                Icon(
                  Icons.music_note,
                  size: 60,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'Aucune musique ajoutée',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Cet utilisateur n\'a pas encore créé de Top 3',
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: List.generate(
                topMusic.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MusicCard(
                    music: topMusic[index],
                    rank: index + 1,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
  
  // Widget pour construire la section "Son préféré"
  Widget _buildFavoriteMusic(BuildContext context, List<MusicModel> topMusic) {
    // Afficher la première musique du top 3 comme son préféré
    final MusicModel? favoriteMusic = topMusic.isNotEmpty ? topMusic.first : null;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "Son préféré",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        if (favoriteMusic == null)
          Container(
            width: double.infinity,
            child: const Column(
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 60,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'Aucun favori défini',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Cet utilisateur n\'a pas encore défini de favori',
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: MusicCard(
              music: favoriteMusic,
              rank: 0, // Pas de rang pour le favori
              backgroundColor: Colors.grey.withAlpha(64),
              buttonColor: Colors.grey,
            ),
          ),
      ],
    );
  }
  
  // Widget pour construire le bouton "Voir Plus"
  Widget _buildViewMoreButton(BuildContext context, UserModel user) {
    return Center(
      child: SizedBox(
        width: 150,
        height: 40,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/all-top3', arguments: user.id);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: customButtonColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            'Voir plus',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
  // Widget pour construire la section des graphiques
  Widget _buildChartsSection(BuildContext context, UserModel user) {
    final MockDataService dataService = MockDataService();
    
    // Utiliser les statistiques basées sur les Top3 réels
    final Map<String, int> userGenres = dataService.getUserGenresFromTop3s(user.id);
    final Map<String, int> userArtists = dataService.getUserArtistsFromTop3s(user.id);
    
    // Si pas de Top3, fallback sur les données statiques
    final Map<String, int> fallbackGenres = userGenres.isEmpty ? dataService.getUserGenres(user.id) : userGenres;
    final Map<String, int> fallbackArtists = userArtists.isEmpty ? dataService.getUserArtists(user.id) : userArtists;    return Column(
      children: [
        // Graphique des genres
        _buildChartSection(
          context,
          title: 'Genres les plus écoutés',
          chart: VerticalBarChart(
            data: fallbackGenres,
            title: 'Genres',
            height: 250,
          ),
        ),

        const SizedBox(height: 30),

        // Graphique des artistes
        _buildChartSection(
          context,
          title: 'Artistes les plus écoutés',
          chart: VerticalBarChart(
            data: fallbackArtists,
            title: 'Artistes',
            height: 250,
          ),
        ),
      ],
    );
  }

  // Widget pour construire une section de graphique
  Widget _buildChartSection(BuildContext context, {required String title, required Widget chart}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        chart,
      ],
    );
  }
}
