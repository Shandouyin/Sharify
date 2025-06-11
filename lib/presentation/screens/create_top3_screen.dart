import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/music_selection_modal.dart';
import '../../core/widgets/custom_snack_bar.dart';
import '../../core/services/audio_player_service.dart';
import '../../data/datasources/mock_data_service.dart';
import '../../data/models/music_model.dart';

// Définition de la couleur personnalisée pour les boutons (même que home_screen.dart)
const Color customButtonColor = Color(0xFF0F7ACC);

class CreateTop3Screen extends StatefulWidget {
  final Function(int)? onNavigateToHome;

  const CreateTop3Screen({super.key, this.onNavigateToHome});

  @override
  State<CreateTop3Screen> createState() => _CreateTop3ScreenState();
}

class _CreateTop3ScreenState extends State<CreateTop3Screen> {
  final MockDataService dataService = MockDataService();
  late List<MusicModel> allMusic;

  // Liste pour stocker les 3 musiques sélectionnées
  List<MusicModel?> selectedMusic = [
    null,
    null,
    null
  ]; // Couleurs pour les slots selon le rang (exactement les mêmes que dans MusicCard)
  static const Color goldColor = Color(0xFFF0C300);
  static const Color silverColor = Color(0xFFF0F0F0);
  static const Color bronzeColor = Color(0xFFAD390E);
  @override
  void initState() {
    super.initState();
    allMusic = dataService.getAllMusic();
  }

  void _swapMusic(int fromIndex, int toIndex) {
    if (fromIndex != toIndex) {
      setState(() {
        final temp = selectedMusic[fromIndex];
        selectedMusic[fromIndex] = selectedMusic[toIndex];
        selectedMusic[toIndex] = temp;
      });
    }
  }

  void selectMusicForSlot(int slotIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MusicSelectionModal(
        musicList: allMusic,
        title:
            'Sélectionner une musique pour la ${_getPositionText(slotIndex + 1)} place',
        onMusicSelected: (music) {
          setState(() {
            selectedMusic[slotIndex] = music;
          });
        },
      ),
    );
  }

  String _getPositionText(int position) {
    switch (position) {
      case 1:
        return '1ère';
      case 2:
        return '2ème';
      case 3:
        return '3ème';
      default:
        return '$position';
    }
  }

  void loadLastTop3() {
    final lastTop3 = dataService.getLastTop3ForUser(dataService.currentUser.id);

    if (lastTop3 != null) {
      // Charger les musiques du dernier Top3
      final List<MusicModel> musics =
          lastTop3.musicIds.map((id) => dataService.getMusicById(id)).toList();
      setState(() {
        selectedMusic = [
          musics.isNotEmpty ? musics[0] : null,
          musics.length > 1 ? musics[1] : null,
          musics.length > 2 ? musics[2] : null,
        ];
      });

      // Afficher un message de succès
      CustomSnackBar.showSuccess(
        context,
        message: 'Dernier Top 3 chargé avec succès !',
        duration: const Duration(seconds: 2),
      );
    } else {
      // Si aucun Top3 précédent, générer aléatoirement comme avant
      final shuffledMusic = List.from(allMusic)..shuffle();
      setState(() {
        selectedMusic = [
          shuffledMusic[0],
          shuffledMusic[1],
          shuffledMusic[2],
        ];
      });

      // Afficher un message d'information
      CustomSnackBar.showInfo(
        context,
        message: 'Aucun Top 3 précédent trouvé. Musiques aléatoires chargées.',
        duration: const Duration(seconds: 2),
      );
    }
  }

  void publishTop3() {
    // Vérifier si toutes les musiques sont sélectionnées
    bool allSelected = selectedMusic.every((music) => music != null);

    if (allSelected) {
      // Sauvegarder le Top3 pour l'utilisateur actuel
      final List<String> musicIds =
          selectedMusic.map((music) => music!.id).toList();

      dataService.addTop3ForUser(
        dataService.currentUser.id,
        musicIds,
        title: null, // Pas de titre personnalisé pour l'instant
      );

      // Afficher une notification de succès
      CustomSnackBar.showSuccess(
        context,
        message: 'Top 3 publié avec succès !',
        duration: const Duration(seconds: 3),
      );

      // Réinitialiser les sélections pour la prochaine fois
      setState(() {
        selectedMusic = [null, null, null];
      });

      // Naviguer vers l'écran d'accueil si callback disponible
      if (widget.onNavigateToHome != null) {
        widget.onNavigateToHome!(0);
      }
    } else {
      // Afficher un message d'erreur si le top 3 n'est pas complet
      CustomSnackBar.showError(
        context,
        message: 'Veuillez sélectionner 3 musiques pour publier votre Top 3',
      );
    }
  }

  Widget _buildMusicSlot(int index) {
    final music = selectedMusic[index];

    return DragTarget<int>(
      onAcceptWithDetails: (details) {
        _swapMusic(details.data, index);
      },
      builder: (context, candidateData, rejectedData) {
        return Draggable<int>(
          data: index,
          feedback: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width - 72,
              height: 80,
              decoration: BoxDecoration(
                color: music != null
                    ? _getRankColor(index).withAlpha(128)
                    : Colors.grey.withAlpha(128),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: music != null
                  ? _buildMusicContent(music, index + 1)
                  : _buildEmptyContent(),
            ),
          ),
          childWhenDragging: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(32),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: const Center(
              child: Text(
                'Déplacer ici',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          child: GestureDetector(
            onTap: () => selectMusicForSlot(index),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: candidateData.isNotEmpty
                    ? _getRankColor(index).withAlpha(100)
                    : music != null
                        ? _getRankColor(index).withAlpha(64)
                        : Colors.grey.withAlpha(64),
                borderRadius: BorderRadius.circular(12),
                border: candidateData.isNotEmpty
                    ? Border.all(
                        color: _getRankColor(index),
                        width: 2,
                      )
                    : null,
              ),
              child: music != null
                  ? _buildMusicContent(music, index + 1)
                  : _buildEmptyContent(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMusicContent(MusicModel music, int rank) {
    return Row(
      children: [
        // Album art
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          ),
          child: SizedBox(
            width: 80,
            height: 80,
            child: Image.network(
              music.albumArt,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.music_note, size: 40),
                );
              },
            ),
          ),
        ),

        const SizedBox(width: 15),

        // Song details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                music.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                music.artist,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        // Drag handle icon
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Icon(
            Icons.drag_indicator,
            color: Colors.white.withValues(alpha: 0.7),
            size: 20,
          ),
        ),

        // Play button
        Consumer<AudioPlayerService>(
          builder: (context, audioService, child) {
            final isCurrentMusic = audioService.isMusicLoaded(music);
            final isPlaying = audioService.isPlayingMusic(music);
            final isLoading = audioService.isLoading &&
                (audioService.currentMusic?.id == music.id ||
                    audioService.currentMusic == null);
            return IconButton(
              icon: Icon(
                isLoading
                    ? Icons.hourglass_empty
                    : (audioService.isCompleted && isCurrentMusic)
                        ? Icons.refresh
                        : isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                color: _getButtonColorForRank(rank),
                size: 42,
              ),
              onPressed: isLoading
                  ? null
                  : () async {
                      if (audioService.isCompleted && isCurrentMusic) {
                        await audioService.restart();
                      } else if (isCurrentMusic) {
                        await audioService.togglePlayPause();
                      } else {
                        await audioService.playMusic(music);
                      }
                    },
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_circle_outline,
            color: Colors.white70,
            size: 24,
          ),
          SizedBox(height: 4),
          Text(
            'Ajouter une musique',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'ou glisser une musique ici',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return goldColor; // Couleur directe pour GlassContainer
      case 1:
        return silverColor;
      case 2:
        return bronzeColor;
      default:
        return Colors.grey;
    }
  }

  Color _getButtonColorForRank(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFF9900); // Gold button
      case 2:
        return const Color(0xFFC1D4ED); // Silver button
      case 3:
        return const Color(0xFFB74210); // Bronze button
      default:
        return Colors.grey;
    }
  }  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GlassContainer(
          blur: 10,
          opacity: 0.25,            child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 60), // Padding réduit à 60px
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre principal
                const Center(
                  child: Text(
                    'Création du top 3',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Slots pour les 3 musiques
                ...List.generate(3, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildMusicSlot(index),
                  );
                }),

                const SizedBox(height: 30), // Boutons d'action
                Row(
                  children: [
                    // Bouton "Récupérer dernier top 3"
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: customButtonColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: loadLastTop3,
                          child: const Text(
                            'Récupérer dernier top 3',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),
                    // Bouton "Publier"
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: customButtonColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: publishTop3,
                          child: const Text(
                            'Publier',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
