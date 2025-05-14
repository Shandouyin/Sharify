import '../models/music_model.dart';
import '../models/user_model.dart';

class MockDataService {
  // Singleton pattern
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  // Mock music data
  final List<MusicModel> _musicList = [
    MusicModel(
      id: 'm1',
      title: 'Blinding Lights',
      artist: 'The Weeknd',
      albumArt: 'https://i.scdn.co/image/ab67616d0000b273c5649add07ed3720be9d5526',
      previewUrl: 'https://example.com/preview1',
    ),
    MusicModel(
      id: 'm2',
      title: 'As It Was',
      artist: 'Harry Styles',
      albumArt: 'https://i.scdn.co/image/ab67616d0000b2732e8ed79e177ff6011076f5f0',
      previewUrl: 'https://example.com/preview2',
    ),
    MusicModel(
      id: 'm3',
      title: 'Bad Habits',
      artist: 'Ed Sheeran',
      albumArt: 'https://i.scdn.co/image/ab67616d0000b2732a038d3bf875d23e4aeaa84e',
      previewUrl: 'https://example.com/preview3',
    ),
    MusicModel(
      id: 'm4',
      title: 'Stay',
      artist: 'The Kid LAROI & Justin Bieber',
      albumArt: 'https://i.scdn.co/image/ab67616d0000b273bd9ef5c294ede777c8328a02',
      previewUrl: 'https://example.com/preview4',
    ),
    MusicModel(
      id: 'm5',
      title: 'Heat Waves',
      artist: 'Glass Animals',
      albumArt: 'https://i.scdn.co/image/ab67616d0000b273c63be7d5cd8dd93c9d5a1afe',
      previewUrl: 'https://example.com/preview5',
    ),
    MusicModel(
      id: 'm6',
      title: 'Montero (Call Me By Your Name)',
      artist: 'Lil Nas X',
      albumArt: 'https://i.scdn.co/image/ab67616d0000b273be82673b5f79d9658ec0a9fd',
      previewUrl: 'https://example.com/preview6',
    ),
  ];

  // Mock users
  final List<UserModel> _users = [
    UserModel(
      id: 'u1',
      username: 'musiclover94',
      profilePicture: 'https://randomuser.me/api/portraits/women/44.jpg',
      topMusicIds: ['m1', 'm3', 'm5'],
      friendIds: ['u2', 'u3'],
    ),
    UserModel(
      id: 'u2',
      username: 'beatmaster',
      profilePicture: 'https://randomuser.me/api/portraits/men/32.jpg',
      topMusicIds: ['m2', 'm4', 'm6'],
      friendIds: ['u1'],
    ),
    UserModel(
      id: 'u3',
      username: 'rockstar2000',
      profilePicture: 'https://randomuser.me/api/portraits/women/68.jpg',
      topMusicIds: ['m6', 'm1', 'm4'],
      friendIds: ['u1'],
    ),
  ];

  // Get current user (mock)
  UserModel get currentUser => _users[0];

  // Get top music list for a user
  List<MusicModel> getTopMusicForUser(String userId) {
    final user = _users.firstWhere((user) => user.id == userId);
    return user.topMusicIds
        .map((musicId) => _musicList.firstWhere((music) => music.id == musicId))
        .toList();
  }

  // Get friends list for current user
  List<UserModel> getFriendsForCurrentUser() {
    return _users
        .where((user) => currentUser.friendIds.contains(user.id))
        .toList();
  }

  // Get community top tracks (mock implementation)
  List<MusicModel> getCommunityTopTracks() {
    // In a real app, this would be calculated from all users' preferences
    return _musicList.sublist(0, 3);
  }
}