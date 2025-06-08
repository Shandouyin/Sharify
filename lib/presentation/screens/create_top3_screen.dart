import 'package:flutter/material.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/music_card.dart';
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
  List<MusicModel?> selectedMusic = [null, null, null];  // Couleurs pour les slots selon le rang (exactement les mêmes que dans MusicCard)
  static const Color goldColor = Color(0xFFF0C300);
  static const Color silverColor = Color(0xFFF0F0F0);
  static const Color bronzeColor = Color(0xFFAD390E);
    @override
  void initState() {
    super.initState();
    allMusic = dataService.getAllMusic();
  }
  
  void selectMusicForSlot(int slotIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildMusicSelectionSheet(slotIndex),
    );
  }
  
  Widget _buildMusicSelectionSheet(int slotIndex) {
    return GlassContainer(
      blur: 10,
      opacity: 0.9,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
              // Titre
            Text(
              'Sélectionner une musique pour la ${_getPositionText(slotIndex + 1)} place',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            
            // Liste des musiques
            Expanded(
              child: ListView.builder(
                itemCount: allMusic.length,
                itemBuilder: (context, index) {
                  final music = allMusic[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: MusicCard(
                      music: music,
                      rank: 0, // Pas de rang spécifique dans la liste de sélection
                      backgroundColor: Colors.grey.withAlpha(64),
                      onTap: () {
                        setState(() {
                          selectedMusic[slotIndex] = music;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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
  }  void loadLastTop3() {
    // Récupérer 3 musiques au hasard
    final shuffledMusic = List.from(allMusic)..shuffle();
    setState(() {
      selectedMusic = [
        shuffledMusic[0],
        shuffledMusic[1],
        shuffledMusic[2],
      ];
    });
  }void publishTop3() {
    // Vérifier si toutes les musiques sont sélectionnées
    bool allSelected = selectedMusic.every((music) => music != null);
    
    if (allSelected) {
      // Afficher une notification de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Top 3 publié avec succès !'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner 3 musiques pour publier votre Top 3'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }  Widget _buildMusicSlot(int index) {
    final music = selectedMusic[index];
    
    return GestureDetector(
      onTap: () => selectMusicForSlot(index),      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: music != null ? _getRankColor(index).withAlpha(64) : Colors.grey.withAlpha(64),
          borderRadius: BorderRadius.circular(12),
        ),
        child: music != null 
          ? _buildMusicContent(music, index + 1)
          : _buildEmptyContent(),
      ),
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
        
        // Play button
        IconButton(
          icon: Icon(
            Icons.play_circle_filled,
            color: _getButtonColorForRank(rank),
            size: 42,
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Lecture de la prévisualisation'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
      ],
    );
  }
  Widget _buildEmptyContent() {
    return const Center(
      child: Text(
        'Ajouter une musique',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GlassContainer(
          blur: 10,
          opacity: 0.25,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [                // Titre principal
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
                
                const SizedBox(height: 30),                  // Boutons d'action
                Row(
                  children: [
                    // Bouton "Récupérer dernier top 3"
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          child: const Text(
                            'Récupérer dernier top 3',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: customButtonColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            alignment: Alignment.center,
                          ),
                          onPressed: loadLastTop3,
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Bouton "Publier"
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          child: const Text(
                            'Publier',
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: customButtonColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            alignment: Alignment.center,
                          ),
                          onPressed: publishTop3,
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
