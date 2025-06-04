import 'package:flutter/material.dart';
import '../../core/widgets/music_card.dart';
import '../../core/widgets/glass_container.dart';
import '../../data/datasources/mock_data_service.dart';
import '../../data/models/music_model.dart';
import '../../data/models/user_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MockDataService dataService = MockDataService();
    final UserModel currentUser = dataService.currentUser;
    final List<MusicModel> userTopMusic = dataService.getTopMusicForUser(currentUser.id);
    final List<MusicModel> communityTracks = dataService.getCommunityTopTracks();
      return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Sharify'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],      ),      
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bonjour, ${currentUser.username}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Découvrez les titres du moment',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            
            // My Top 3 Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Top 3',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to edit top 3
                    },
                    child: const Text('Edit'),
                  ),
                ],
              ),
            ),
            
            _buildMyTopMusic(userTopMusic),
            
            const Divider(height: 32),
            
            // Community section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Community Favorites',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            
            _buildCommunityPreview(communityTracks),
          ],
        ),
      ),
    );
  }
    Widget _buildMyTopMusic(List<MusicModel> topMusic) {
    return topMusic.isEmpty
        ? _buildEmptyState('You haven\'t added your top tracks yet', 'Tap the edit button to add your favorites')        : GlassContainer(
            blur: 10,
            opacity: 0.25,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...List.generate(
                  topMusic.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: MusicCard(
                      music: topMusic[index],
                      rank: index + 1,
                      onTap: () {
                        // TODO: Show details or play preview
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
  }
    Widget _buildCommunityPreview(List<MusicModel> communityTracks) {
    if (communityTracks.isEmpty) {
      return _buildEmptyState('No community tracks yet', 'Be the first to share your favorites!');
    }
      return GlassContainer(
      blur: 10,
      opacity: 0.25,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(
            communityTracks.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: MusicCard(
                music: communityTracks[index],
                rank: index + 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.music_note,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
      ),
    );
  }
}