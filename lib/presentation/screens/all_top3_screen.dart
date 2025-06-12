import 'package:flutter/material.dart';
import '../../data/datasources/mock_data_service.dart';
import '../../data/models/user_model.dart';
import '../../data/models/music_model.dart';
import '../../data/models/top3_model.dart';
import '../../core/widgets/music_card.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/background_container.dart';
import '../../core/widgets/empty_state_widget.dart';

class AllTop3Screen extends StatelessWidget {
  final String? userId; // Si null, affiche les Top3 de l'utilisateur actuel

  const AllTop3Screen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    final MockDataService dataService = MockDataService();
    final UserModel targetUser = userId != null
        ? dataService.getUserById(userId!)
        : dataService.currentUser;

    // Récupérer les Top3 spécifiques à l'utilisateur
    final List<Top3Model> userTop3s =
        dataService.getTop3sForUser(targetUser.id);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Top 3 de ${targetUser.username}'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation:
            0, // Désactive l'effet d'élévation lors du défilement
      ),
      body: BackgroundContainer(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GlassContainer(
            blur: 10,
            opacity: 0.25,
            child: userTop3s.isEmpty
                ? EmptyStateWidget(
                    icon: Icons.music_note,
                    title: 'Aucun Top 3 créé',
                    subtitle:
                        'Créez votre premier Top 3 pour voir votre historique ici !',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: userTop3s.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 24),
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

  Widget _buildTop3Card(
      BuildContext context, Top3Model top3, MockDataService dataService) {
    final List<MusicModel> musics =
        top3.musicIds.map((id) => dataService.getMusicById(id)).toList();
    // Formatage simple de la date avec zéros
    final String formattedDate =
        '${top3.createdAt.day.toString().padLeft(2, '0')}/${top3.createdAt.month.toString().padLeft(2, '0')}/${top3.createdAt.year}';
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
            padding:
                EdgeInsets.only(bottom: index < musics.length - 1 ? 12 : 0),
            child: MusicCard(
              music: musics[index],
              rank: index + 1,
            ),
          ),
        ),
      ],
    );
  }
}
