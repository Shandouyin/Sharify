import 'package:flutter/material.dart';
import '../../data/datasources/mock_data_service.dart';
import '../../data/models/user_model.dart';
import '../../data/models/music_model.dart';
import '../../core/widgets/music_card.dart';
import '../../core/widgets/glass_container.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final MockDataService dataService = MockDataService();
    final UserModel currentUser = dataService.currentUser;
    final List<MusicModel> userTopMusic =
        dataService.getTopMusicForUser(currentUser.id);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(currentUser.profilePicture),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentUser.username,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Member since January 2025',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatCard(context,
                          currentUser.friendIds.length.toString(), 'Friends'),
                      const SizedBox(width: 20),
                      _buildStatCard(context, '42', 'Updates'),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(),

            // My Top 3 section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Top 3',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                        onPressed: () {
                          // TODO: Navigate to edit top 3
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildMyTopMusic(context, userTopMusic),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildMyTopMusic(BuildContext context, List<MusicModel> topMusic) {
    return topMusic.isEmpty
        ? const Center(
            child: Text('No top tracks added yet'),
          )
        : GlassContainer(
            blur: 10,
            opacity: 0.25,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "My Top 3",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                ...List.generate(
                  topMusic.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: MusicCard(
                      music: topMusic[index],
                      rank: index + 1,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
