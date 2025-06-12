import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/datasources/mock_data_service.dart';
import '../../data/models/user_model.dart';
import '../../data/models/music_model.dart';
import '../../core/widgets/music_card.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/vertical_bar_chart.dart';
import '../../core/widgets/custom_snack_bar.dart';
import '../../core/widgets/share_options_widget.dart';
import '../../core/widgets/profile_avatar.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/constants/app_constants.dart';

// Définition de la couleur personnalisée pour les boutons
const Color customButtonColor = AppConstants.primaryButtonColor;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late MockDataService dataService;
  late UserModel currentUser;
  late List<MusicModel> userTopMusic;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    dataService = MockDataService();
    currentUser = dataService.currentUser;
    userTopMusic = dataService.getTopMusicForUser(currentUser.id);

    // Charger le dernier Top3 pour afficher dans la section "Dernier top 3"
    final lastTop3 = dataService.getLastTop3ForUser(currentUser.id);
    if (lastTop3 != null) {
      // Remplacer userTopMusic par les musiques du dernier Top3
      userTopMusic =
          lastTop3.musicIds.map((id) => dataService.getMusicById(id)).toList();
    }
  }

  void _refreshUserData() {
    setState(() {
      _loadUserData();
    });
  }

  void _handleEditProfileResult(dynamic result) {
    if (result == true && mounted) {
      // Rafraîchir les données utilisateur
      _refreshUserData();
      // Afficher un message de succès
      CustomSnackBar.showSuccess(
        context,
        message: 'Profil mis à jour avec succès',
      );
    }
  }
  Widget _buildProfileImage(String imagePath) {
    return ProfileAvatar(
      imagePath: imagePath,
      radius: 35,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.fromLTRB(16, 16, 16, 60), // Padding réduit à 60px
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
                    _buildProfileImage(currentUser.profilePicture),

                    const SizedBox(width: 16),

                    // Informations utilisateur à droite
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentUser.username,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '@${currentUser.username.toLowerCase()}',
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
                    _buildStatColumn(
                        '${currentUser.friendIds.length}', 'Suivi(e)s'),
                    _buildStatColumn('127', 'Followers'),
                    _buildStatColumn('342', 'J\'aimes'),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Boutons Modifier et Partager
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Bouton "Modifier"
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.pushNamed(
                                context, '/edit-profile');
                            _handleEditProfileResult(result);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: customButtonColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Modifier',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
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
                            ShareOptionsWidget.show(
                              context: context,
                              shareText:
                                  "Découvre le profil de ${currentUser.username} sur Sharify!",
                            );
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
              _buildMyTopMusic(context, userTopMusic),
              const SizedBox(height: 20),

              // Bouton Voir Plus
              _buildViewMoreButton(context), const SizedBox(height: 30),

              // Titre Statistiques
              Padding(
                padding: const EdgeInsets.all(16),
                child: const Text(
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
              _buildChartsSection(context, currentUser),

              const SizedBox(height: 50),
            ],
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

  Widget _buildMyTopMusic(BuildContext context, List<MusicModel> topMusic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: const Text(
            "Dernier top 3",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        if (topMusic.isEmpty)
          SizedBox(
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
                  'Créez votre premier Top 3 !',
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
    final MusicModel? favoriteMusic =
        topMusic.isNotEmpty ? topMusic.first : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: const Text(
            "Son préféré",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        if (favoriteMusic == null)
          SizedBox(
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
                  'Créez votre Top 3 pour définir un favori !',
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
  Widget _buildViewMoreButton(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 150,
        height: 40,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/all-top3');
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
    final Map<String, int> userGenres =
        dataService.getUserGenresFromTop3s(user.id);
    final Map<String, int> userArtists =
        dataService.getUserArtistsFromTop3s(user.id);

    // Si pas de Top3, fallback sur les données statiques
    final Map<String, int> fallbackGenres =
        userGenres.isEmpty ? dataService.getUserGenres(user.id) : userGenres;
    final Map<String, int> fallbackArtists =
        userArtists.isEmpty ? dataService.getUserArtists(user.id) : userArtists;
    return Column(
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
  } // Widget pour construire une section de graphique

  Widget _buildChartSection(BuildContext context,
      {required String title, required Widget chart}) {
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
