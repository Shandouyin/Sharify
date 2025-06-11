import 'package:flutter/material.dart';
import '../../data/datasources/mock_data_service.dart';
import '../../data/models/music_model.dart';
import '../../core/widgets/music_card.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/vertical_bar_chart.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});  @override  Widget build(BuildContext context) {    final MockDataService dataService = MockDataService();
    
    // Utiliser les statistiques basées sur les Top3 réels
    final Map<String, int> popularGenres = dataService.getPopularGenresFromTop3s();
    final Map<String, int> popularArtists = dataService.getPopularArtistsFromTop3s();
    final List<MusicModel> top10Tracks = dataService.getTop10PopularTracksFromTop3s();
    
    // Si pas de données des Top3, fallback sur les données statiques
    final Map<String, int> fallbackGenres = popularGenres.isEmpty ? dataService.getPopularGenres() : popularGenres;
    final Map<String, int> fallbackArtists = popularArtists.isEmpty ? dataService.getPopularArtists() : popularArtists;
    final List<MusicModel> fallbackTracks = top10Tracks.isEmpty ? dataService.getTop10PopularTracks() : top10Tracks;

    return Scaffold(
      backgroundColor: Colors.transparent,      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 60), // Padding réduit à 60px
        child: GlassContainer(
          blur: 10,
          opacity: 0.25,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,            children: [
              // Genres Chart
              _buildChartSection(
                context,
                title: 'Genres les plus populaires',
                chart: VerticalBarChart(
                  data: fallbackGenres,
                  title: 'Genres',
                  height: 250,
                ),
              ),

              const SizedBox(height: 32),

              // Artists Chart
              _buildChartSection(
                context,
                title: 'Artistes du moment',
                chart: VerticalBarChart(
                  data: fallbackArtists,
                  title: 'Artistes',
                  height: 250,
                ),
              ),

              const SizedBox(height: 32),

              // Top 10 Tracks
              _buildTopTracksSection(context, fallbackTracks),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartSection(BuildContext context, {required String title, required Widget chart}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        chart,
      ],
    );
  }

  Widget _buildTopTracksSection(BuildContext context, List<MusicModel> topTracks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Musiques du moment',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        if (topTracks.isEmpty)
          _buildEmptyState('Aucune musique populaire', 'Soyez le premier à partager vos favoris !')
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: topTracks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MusicCard(
                    music: topTracks[index],
                    rank: index + 1,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.bar_chart,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
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
}
