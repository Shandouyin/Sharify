import 'package:flutter/material.dart';
import '../../core/widgets/music_card.dart';
import '../../data/datasources/mock_data_service.dart';
import '../../data/models/music_model.dart';
import '../../data/models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MockDataService _dataService = MockDataService();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final UserModel currentUser = _dataService.currentUser;
    final List<MusicModel> userTopMusic = _dataService.getTopMusicForUser(currentUser.id);
    final List<UserModel> friends = _dataService.getFriendsForCurrentUser();
    final List<MusicModel> communityTracks = _dataService.getCommunityTopTracks();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sharify'),
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundImage: NetworkImage(currentUser.profilePicture),
              radius: 14,
            ),
            onPressed: () {
              // TODO: Navigate to profile screen
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My Top 3'),
            Tab(text: 'Friends'),
            Tab(text: 'Community'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // My Top 3 Tab
          _buildMyTopMusic(userTopMusic),
          
          // Friends Tab
          _buildFriendsList(friends),
          
          // Community Tab
          _buildCommunityTracks(communityTracks),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create/edit top 3 screen
        },
        tooltip: 'Edit My Top 3',
        child: const Icon(Icons.edit),
      ),
    );
  }
  
  Widget _buildMyTopMusic(List<MusicModel> topMusic) {
    return topMusic.isEmpty
        ? _buildEmptyState('You haven\'t added your top tracks yet', 'Tap the edit button to add your favorites')
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: topMusic.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: MusicCard(
                  music: topMusic[index],
                  rank: index + 1,
                  onTap: () {
                    // TODO: Show details or play preview
                  },
                ),
              );
            },
          );
  }
  
  Widget _buildFriendsList(List<UserModel> friends) {
    if (friends.isEmpty) {
      return _buildEmptyState('No friends yet', 'Add friends to see their music taste');
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        final friendTopMusic = _dataService.getTopMusicForUser(friend.id);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 24),
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
  
  Widget _buildCommunityTracks(List<MusicModel> communityTracks) {
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
      ],
    );
  }
  
  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
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
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}