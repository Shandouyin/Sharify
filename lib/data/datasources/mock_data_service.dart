import '../models/music_model.dart';
import '../models/user_model.dart';
import 'mock_data.dart';

class MockDataService {
  // Singleton pattern
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  // Référence aux données mockées
  final List<MusicModel> _musicList = MockData.musicList;
  final List<UserModel> _users = MockData.users;

  // Get current user (mock)
  UserModel get currentUser => _users.firstWhere(
        (user) => user.id == MockData.currentUserId,
        orElse: () => _users[0],
      );

  // Get all music tracks
  List<MusicModel> getAllMusic() {
    return _musicList;
  }

  // Get all users
  List<UserModel> getAllUsers() {
    return _users;
  }

  // Get top music list for a user
  List<MusicModel> getTopMusicForUser(String userId) {
    final user = _users.firstWhere((user) => user.id == userId);
    return user.topMusicIds
        .map((musicId) => _musicList.firstWhere((music) => music.id == musicId))
        .toList();
  }

  // Get music by id
  MusicModel getMusicById(String musicId) {
    return _musicList.firstWhere(
      (music) => music.id == musicId,
      orElse: () => throw Exception('Music not found: $musicId'),
    );
  }

  // Get user by id
  UserModel getUserById(String userId) {
    return _users.firstWhere(
      (user) => user.id == userId,
      orElse: () => throw Exception('User not found: $userId'),
    );
  }

  // Get friends list for current user
  List<UserModel> getFriendsForCurrentUser() {
    return _users
        .where((user) => currentUser.friendIds.contains(user.id))
        .toList();
  }

  // Get friends list for a specific user
  List<UserModel> getFriendsForUser(String userId) {
    final UserModel user = getUserById(userId);
    return _users.where((u) => user.friendIds.contains(u.id)).toList();
  }

  // Get community top tracks (mock implementation)
  List<MusicModel> getCommunityTopTracks() {
    Map<String, int> trackCounts = {};

    for (var user in _users) {
      for (var musicId in user.topMusicIds) {
        trackCounts[musicId] = (trackCounts[musicId] ?? 0) + 1;
      }
    }

    // Trier les morceaux par popularité
    List<String> sortedMusicIds = trackCounts.keys.toList()
      ..sort((a, b) => (trackCounts[b] ?? 0).compareTo(trackCounts[a] ?? 0));

    // Prendre les 5 plus populaires
    return sortedMusicIds.take(5).map((id) => getMusicById(id)).toList();
  }

  // Rechercher des morceaux par titre ou artiste
  List<MusicModel> searchMusic(String query) {
    final String lowercaseQuery = query.toLowerCase();
    return _musicList.where((music) {
      return music.title.toLowerCase().contains(lowercaseQuery) ||
          music.artist.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
  // Rechercher des utilisateurs par nom d'utilisateur
  List<UserModel> searchUsers(String query) {
    final String lowercaseQuery = query.toLowerCase();
    return _users.where((user) {
      return user.username.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
  // Get popular genres statistics
  Map<String, int> getPopularGenres() {
    Map<String, int> genreCounts = {};

    for (var user in _users) {
      for (var musicId in user.topMusicIds) {
        final music = getMusicById(musicId);
        final genre = music.genre ?? 'Unknown';
        genreCounts[genre] = (genreCounts[genre] ?? 0) + 1;
      }
    }

    // Convert to sorted map (keeping only top 5)
    final entries = genreCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Map.fromEntries(entries.take(5));
  }

  // Get popular artists statistics
  Map<String, int> getPopularArtists() {
    Map<String, int> artistCounts = {};

    for (var user in _users) {
      for (var musicId in user.topMusicIds) {
        final music = getMusicById(musicId);
        artistCounts[music.artist] = (artistCounts[music.artist] ?? 0) + 1;
      }
    }

    // Convert to sorted map (keeping only top 5)
    final entries = artistCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Map.fromEntries(entries.take(5));
  }

  // Get top 10 community tracks
  List<MusicModel> getTop10PopularTracks() {
    Map<String, int> trackCounts = {};

    for (var user in _users) {
      for (var musicId in user.topMusicIds) {
        trackCounts[musicId] = (trackCounts[musicId] ?? 0) + 1;
      }
    }

    // Sort tracks by popularity and get top 10
    List<String> sortedMusicIds = trackCounts.keys.toList()
      ..sort((a, b) => (trackCounts[b] ?? 0).compareTo(trackCounts[a] ?? 0));

    return sortedMusicIds.take(10).map((id) => getMusicById(id)).toList();
  }

  // Get user-specific genre statistics
  Map<String, int> getUserGenres(String userId) {
    Map<String, int> genreCounts = {};
    
    final user = getUserById(userId);
    for (var musicId in user.topMusicIds) {
      final music = getMusicById(musicId);
      final genre = music.genre ?? 'Unknown';
      genreCounts[genre] = (genreCounts[genre] ?? 0) + 1;
    }
    
    // Convert to sorted map (keeping only top 5)
    final entries = genreCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Map.fromEntries(entries.take(5));
  }

  // Get user-specific artist statistics
  Map<String, int> getUserArtists(String userId) {
    Map<String, int> artistCounts = {};
    
    final user = getUserById(userId);
    for (var musicId in user.topMusicIds) {
      final music = getMusicById(musicId);
      artistCounts[music.artist] = (artistCounts[music.artist] ?? 0) + 1;
    }
    
    // Convert to sorted map (keeping only top 5)
    final entries = artistCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Map.fromEntries(entries.take(5));
  }
}
