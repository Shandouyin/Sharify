import 'package:flutter/material.dart';
import '../../data/models/music_model.dart';
import 'music_card.dart';

class MusicSelectionModal extends StatefulWidget {
  final List<MusicModel> musicList;
  final Function(MusicModel) onMusicSelected;
  final String title;

  const MusicSelectionModal({
    super.key,
    required this.musicList,
    required this.onMusicSelected,
    required this.title,
  });

  @override
  State<MusicSelectionModal> createState() => _MusicSelectionModalState();
}

class _MusicSelectionModalState extends State<MusicSelectionModal> {
  late List<MusicModel> filteredMusic;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredMusic = List.from(widget.musicList);
    _searchController.addListener(_filterMusic);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterMusic() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredMusic = List.from(widget.musicList);
      } else {
        filteredMusic = widget.musicList.where((music) {
          return music.title.toLowerCase().contains(query) ||
                 music.artist.toLowerCase().contains(query);
        }).toList();
      }
    });
  }  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600, // Hauteur fixe pour éviter le problème de mouvement, identique à GlobalSearchModal
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Titre
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: 20),

          // Barre de recherche
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Rechercher par titre ou artiste...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Liste des musiques filtrées
          Expanded(
            child: filteredMusic.isEmpty
                ? Center(
                    child: Text(
                      'Aucune musique trouvée',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredMusic.length,
                    itemBuilder: (context, index) {
                      final music = filteredMusic[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: MusicCard(
                          music: music,
                          rank: 0, // Pas de rang spécifique dans la liste de sélection
                          backgroundColor: Colors.grey.withAlpha(64),
                          onTap: () {
                            widget.onMusicSelected(music);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
