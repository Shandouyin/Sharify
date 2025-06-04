import 'package:flutter/material.dart';
import '../../data/datasources/mock_data_service.dart';
import '../../data/models/user_model.dart';
import '../../core/widgets/music_card.dart';
import '../../core/widgets/glass_container.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MockDataService dataService = MockDataService();
    final List<UserModel> friends = dataService.getFriendsForCurrentUser();
      return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Ami(e)s'),
      ),
      body: _buildFriendsList(friends, dataService),
    );
  }
  
  Widget _buildFriendsList(List<UserModel> friends, MockDataService dataService) {
    if (friends.isEmpty) {
      return _buildEmptyState('No friends yet', 'Add friends to see their music taste');
    }      return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        final friendTopMusic = dataService.getTopMusicForUser(friend.id);          return GlassContainer(
          blur: 10,
          opacity: 0.25,
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Friend header
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(friend.profilePicture),
                ),
                title: Text(friend.username),
                subtitle: const Text('Latest update: Today'),
              ),
              
              // Friend's top 3 music
              ...List.generate(
                friendTopMusic.length,
                (musicIndex) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: MusicCard(
                    music: friendTopMusic[musicIndex], 
                    rank: musicIndex + 1,
                  ),
                ),
              ),
              
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.people,
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