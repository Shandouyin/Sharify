import 'package:flutter/material.dart';
import '../../data/datasources/mock_data_service.dart';
import '../../data/models/music_model.dart';
import '../../core/widgets/music_card.dart';
import '../../core/widgets/glass_container.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MockDataService dataService = MockDataService();
    final List<MusicModel> communityTracks = dataService.getCommunityTopTracks();
      return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Statistiques'),
      ),
      body: _buildCommunityTracks(context, communityTracks),
    );
  }
  
  Widget _buildCommunityTracks(BuildContext context, List<MusicModel> communityTracks) {
    if (communityTracks.isEmpty) {
      return _buildEmptyState('No community tracks yet', 'Be the first to share your favorites!');
    }
      return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Trending in the Community',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Expanded(
          child: GlassContainer(
            blur: 10,
            opacity: 0.25,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: communityTracks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MusicCard(
                    music: communityTracks[index],
                    rank: index + 1,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
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
}