import 'package:flutter/material.dart';
import '../../data/datasources/mock_data_service.dart';
import '../../data/models/user_model.dart';
import '../../data/models/music_model.dart';
import '../../data/models/top3_model.dart';
import '../../core/widgets/music_card.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/background_container.dart';

class AllTop3Screen extends StatelessWidget {
  final String? userId; // Si null, affiche les Top3 de l'utilisateur actuel

  const AllTop3Screen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    final MockDataService dataService = MockDataService();
    final UserModel targetUser = userId != null 
        ? dataService.getUserById(userId!)
        : dataService.currentUser;
    
    // Données simulées de Top3 avec dates
    final List<Top3Model> userTop3s = _getMockTop3sForUser(targetUser.id, dataService);    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Top 3 de ${targetUser.username}'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BackgroundContainer(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GlassContainer(
            blur: 10,
            opacity: 0.25,            child: userTop3s.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: userTop3s.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 24),
                    itemBuilder: (context, index) {
                      final top3 = userTop3s[index];
                      return _buildTop3Card(context, top3, dataService);
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_note,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 24),
            Text(
              'Aucun Top 3 créé',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              'Créez votre premier Top 3 pour voir votre historique ici !',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }  Widget _buildTop3Card(BuildContext context, Top3Model top3, MockDataService dataService) {
    final List<MusicModel> musics = top3.musicIds
        .map((id) => dataService.getMusicById(id))
        .toList();
      // Formatage simple de la date avec zéros
    final String formattedDate = '${top3.createdAt.day.toString().padLeft(2, '0')}/${top3.createdAt.month.toString().padLeft(2, '0')}/${top3.createdAt.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date en en-tête
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            formattedDate,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        
        // Les 3 musiques
        ...List.generate(
          musics.length,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: index < musics.length - 1 ? 12 : 0),
            child: MusicCard(
              music: musics[index],
              rank: index + 1,
            ),
          ),
        ),
      ],
    );
  }

  // Fonction pour générer des données mockées de Top3 avec dates
  List<Top3Model> _getMockTop3sForUser(String userId, MockDataService dataService) {
    final List<MusicModel> allMusic = dataService.getAllMusic();
    final List<Top3Model> top3s = [];
    
    // Générer quelques Top3 avec des dates différentes
    final DateTime now = DateTime.now();
    
    // Top3 d'il y a 1 semaine
    top3s.add(Top3Model(
      id: 't1_$userId',
      userId: userId,
      musicIds: [allMusic[0].id, allMusic[1].id, allMusic[2].id],
      createdAt: now.subtract(const Duration(days: 7)),
      title: 'Mes découvertes de la semaine',
    ));
    
    // Top3 d'il y a 2 semaines
    top3s.add(Top3Model(
      id: 't2_$userId',
      userId: userId,
      musicIds: [allMusic[3].id, allMusic[4].id, allMusic[5].id],
      createdAt: now.subtract(const Duration(days: 14)),
      title: 'Playlist été',
    ));
    
    // Top3 d'il y a 1 mois
    top3s.add(Top3Model(
      id: 't3_$userId',
      userId: userId,
      musicIds: [allMusic[6].id, allMusic[7].id, allMusic[8].id],
      createdAt: now.subtract(const Duration(days: 30)),
      title: 'Classics du mois',
    ));
    
    // Top3 d'il y a 2 mois
    top3s.add(Top3Model(
      id: 't4_$userId',
      userId: userId,
      musicIds: [allMusic[9].id, allMusic[10].id, allMusic[11].id],
      createdAt: now.subtract(const Duration(days: 60)),
    ));
    
    // Trier par date (plus récent en premier)
    top3s.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return top3s;
  }
}
