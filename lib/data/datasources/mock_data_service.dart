import '../models/music_model.dart';
import '../models/user_model.dart';
import '../models/top3_model.dart';
import 'mock_data.dart';
import 'dart:math';

class MockDataService {
  // Singleton pattern
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  // Référence aux données mockées
  final List<MusicModel> _musicList = MockData.musicList;
  final List<UserModel> _users = MockData.users;
  
  // Instance Random pour générer des données aléatoires
  final Random _random = Random();
  
  // Stockage persistant des données d'interaction et commentaires
  final Map<String, Map<String, dynamic>> _userInteractionData = {};
  final Map<String, List<Map<String, dynamic>>> _userComments = {};
  final Map<String, Set<String>> _userLikedPosts = {}; // Stockage des posts likés par utilisateur
  
  // Stockage des Top3 des utilisateurs
  final Map<String, List<Top3Model>> _userTop3s = {};

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
  // Update user profile (mock implementation)
  void updateUserProfile(String userId, String newUsername, String? newImagePath) {
    final userIndex = _users.indexWhere((user) => user.id == userId);
    if (userIndex != -1) {
      final currentUser = _users[userIndex];
      
      // For image path, if it's a local file, we keep it as is
      // In a real app, you would upload the image to a server and get a URL back
      String profilePictureUrl = currentUser.profilePicture;
      if (newImagePath != null) {
        // In this mock, we just store the local path
        // In a real app, you would upload the file and get back a URL
        profilePictureUrl = newImagePath;
      }
      
      // Create updated user model
      final updatedUser = UserModel(
        id: currentUser.id,
        username: newUsername,
        profilePicture: profilePictureUrl,
        topMusicIds: currentUser.topMusicIds,
        friendIds: currentUser.friendIds,
      );
      
      // Replace in the list
      _users[userIndex] = updatedUser;
    }
  }

  // Helper method to check if a path is a local file
  bool isLocalFile(String path) {
    return path.startsWith('/') || path.contains('\\') || path.startsWith('file://');
  }
  
  // Méthodes pour générer des données aléatoires
  int getRandomLikeCount() {
    return _random.nextInt(120) + 1; // Entre 1 et 50
  }
  
  int getRandomShareCount() {
    return _random.nextInt(20) + 1; // Entre 1 et 20
  }
  
  int getRandomCommentCount() {
    return _random.nextInt(15) + 1; // Entre 1 et 15
  }
    // Générer des données d'interaction pour un utilisateur (une seule fois)
  Map<String, int> getInteractionDataForUser(String userId) {
    if (!_userInteractionData.containsKey(userId)) {
      _userInteractionData[userId] = {
        'likes': getRandomLikeCount(),
        'shares': getRandomShareCount(),
        'comments': 0, // Sera mis à jour avec le vrai nombre de commentaires
      };
    }
    return Map<String, int>.from(_userInteractionData[userId]!);
  }
  
  // Obtenir les commentaires pour un utilisateur (générés une seule fois)
  List<Map<String, dynamic>> getCommentsForUser(String userId, String username) {
    if (!_userComments.containsKey(userId)) {
      _userComments[userId] = getRandomComments(username);
    }
    return List<Map<String, dynamic>>.from(_userComments[userId]!);
  }
  
  // Vérifier si l'utilisateur actuel a liké un post
  bool hasUserLikedPost(String postUserId) {
    final currentUserId = currentUser.id;
    return _userLikedPosts[currentUserId]?.contains(postUserId) ?? false;
  }
  
  // Marquer un post comme liké par l'utilisateur actuel
  void likePost(String postUserId) {
    final currentUserId = currentUser.id;
    if (!_userLikedPosts.containsKey(currentUserId)) {
      _userLikedPosts[currentUserId] = <String>{};
    }
    _userLikedPosts[currentUserId]!.add(postUserId);
    
    // Incrémenter le compteur de likes pour ce post
    if (_userInteractionData.containsKey(postUserId)) {
      _userInteractionData[postUserId]!['likes'] = 
        (_userInteractionData[postUserId]!['likes'] ?? 0) + 1;
    }
  }
  
  // Retirer le like d'un post par l'utilisateur actuel
  void unlikePost(String postUserId) {
    final currentUserId = currentUser.id;
    if (_userLikedPosts.containsKey(currentUserId)) {
      _userLikedPosts[currentUserId]!.remove(postUserId);
    }
    
    // Décrémenter le compteur de likes pour ce post
    if (_userInteractionData.containsKey(postUserId)) {
      final currentLikes = _userInteractionData[postUserId]!['likes'] ?? 0;
      if (currentLikes > 0) {
        _userInteractionData[postUserId]!['likes'] = currentLikes - 1;
      }
    }
  }
  
  // Mettre à jour le nombre de commentaires pour un utilisateur
  void updateCommentCount(String userId, int count) {
    if (_userInteractionData.containsKey(userId)) {
      _userInteractionData[userId]!['comments'] = count;
    }
  }
  
  // Ajouter un nouveau commentaire pour un utilisateur
  void addCommentForUser(String userId, Map<String, dynamic> comment) {
    if (_userComments.containsKey(userId)) {
      _userComments[userId]!.insert(0, comment);
    }
  }
  
  // Compte le nombre total de commentaires pour un utilisateur
  int getTotalCommentCount(String userId) {
    if (!_userComments.containsKey(userId)) {
      return 0;
    }
    
    int count = _userComments[userId]!.length;
    for (var comment in _userComments[userId]!) {
      if (comment['replies'] != null) {
        count += (comment['replies'] as List).length;
      }
    }
    return count;
  }

  // Générer des données d'interaction pour un utilisateur
  Map<String, int> getRandomInteractionData() {
    return {
      'likes': getRandomLikeCount(),
      'shares': getRandomShareCount(),
      'comments': getRandomCommentCount(),
    };
  }
  
  // Générer des commentaires aléatoires pour une publication
  List<Map<String, dynamic>> getRandomComments(String username) {
    final List<String> commentAuthors = [
      'Alice', 'Bob', 'Charlie', 'Diana', 'Eva', 'Frank', 'Grace', 'Henry', 'Ivy', 'Jack'
    ];
    
    final List<String> commentTexts = [
      'J\'adore ton top 3 !',
      'Excellent choix musical !',
      'Je ne connais pas le deuxième titre, tu recommandes ?',
      'Super sélection, on a des goûts similaires !',
      'Wow, j\'ai découvert de nouveaux artistes grâce à toi',
      'Cette playlist est parfaite !',
      'Tu as un goût musical exceptionnel',
      'Je vais écouter ça de suite !',
      'Merci pour ces découvertes musicales',
      'On dirait qu\'on écoute la même musique !'
    ];
    
    final List<String> replyTexts = [
      'Absolument, c\'est un de mes préférés !',
      'Merci, content que ça te plaise !',
      'Je peux te faire d\'autres recommandations si tu veux',
      'C\'est exactement ce que je pensais !',
      'N\'hésite pas si tu veux d\'autres suggestions'
    ];
    
    List<Map<String, dynamic>> comments = [];
    int numComments = _random.nextInt(4) + 1; // Entre 1 et 4 commentaires
    
    for (int i = 0; i < numComments; i++) {
      String author = commentAuthors[_random.nextInt(commentAuthors.length)];
      String text = commentTexts[_random.nextInt(commentTexts.length)];
      
      Map<String, dynamic> comment = {
        'id': 'random_${DateTime.now().millisecondsSinceEpoch}_$i',
        'author': author,
        'text': text,
        'time': '${_random.nextInt(24) + 1}h',
        'likes': _random.nextInt(10),
        'replies': []
      };
      
      // Ajouter parfois une réponse
      if (_random.nextBool() && _random.nextBool()) { // 25% de chance
        Map<String, dynamic> reply = {
          'id': 'reply_${DateTime.now().millisecondsSinceEpoch}_$i',
          'author': username,
          'text': replyTexts[_random.nextInt(replyTexts.length)],
          'time': '${_random.nextInt(12) + 1}h',
          'likes': _random.nextInt(5)
        };
        comment['replies'].add(reply);
      }
      
      comments.add(comment);
    }
    
    return comments;
  }
  
  // =============== GESTION DES TOP3 ===============
  
  // Obtenir les Top3 d'un utilisateur
  List<Top3Model> getTop3sForUser(String userId) {
    if (!_userTop3s.containsKey(userId)) {
      _userTop3s[userId] = _generateMockTop3sForUser(userId);
    }
    return List<Top3Model>.from(_userTop3s[userId]!);
  }
    // Ajouter un nouveau Top3 pour un utilisateur
  void addTop3ForUser(String userId, List<String> musicIds, {String? title}) {
    if (!_userTop3s.containsKey(userId)) {
      _userTop3s[userId] = [];
    }
    
    final top3 = Top3Model(
      id: 'top3_${userId}_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      musicIds: musicIds,
      createdAt: DateTime.now(),
      title: null, // Pas de titre personnalisé pour garder la simplicité
    );
    
    _userTop3s[userId]!.insert(0, top3); // Ajouter en premier pour avoir le plus récent en haut
  }
    // Générer des Top3 mockés spécifiques à chaque utilisateur
  List<Top3Model> _generateMockTop3sForUser(String userId) {
    final user = getUserById(userId);
    final List<Top3Model> top3s = [];
    final DateTime now = DateTime.now();
    
    // Créer un générateur aléatoire spécifique à cet utilisateur pour des résultats reproductibles mais différents
    final userRandom = Random(userId.hashCode);
    
    // Créer un pool de musiques basé sur les goûts de l'utilisateur et ses amis
    Set<String> musicPool = Set<String>.from(user.topMusicIds);
    
    // Ajouter des musiques des amis pour varier les goûts
    final shuffledFriends = List<String>.from(user.friendIds)..shuffle(userRandom);
    for (String friendId in shuffledFriends.take(2)) { // Prendre 2 amis aléatoires
      try {
        final friend = getUserById(friendId);
        musicPool.addAll(friend.topMusicIds);
      } catch (e) {
        // Ignorer si l'ami n'existe pas
      }
    }
    
    // Ajouter quelques musiques aléatoires pour la diversité, mais de manière déterministe pour cet utilisateur
    final allMusic = getAllMusic();
    final randomMusic = List.from(allMusic)..shuffle(userRandom);
    musicPool.addAll(randomMusic.take(5 + userRandom.nextInt(5)).map((m) => m.id)); // Entre 5 et 9 musiques
    
    List<String> musicList = musicPool.toList()..shuffle(userRandom);
      // Générer 5-8 Top3 avec des dates différentes (plus que avant)
    int numberOfTop3s = 5 + userRandom.nextInt(4); // Entre 5 et 8
    
    for (int i = 0; i < numberOfTop3s && musicList.length >= 3; i++) {
      // Prendre 3 musiques différentes
      List<String> selectedMusicIds = [];
      for (int j = 0; j < 3 && musicList.isNotEmpty; j++) {
        selectedMusicIds.add(musicList.removeAt(0));
      }
      
      if (selectedMusicIds.length == 3) {
        final daysBack = (i + 1) * 7 + userRandom.nextInt(7); // Espacer les dates de manière variable
        
        top3s.add(Top3Model(
          id: 'mock_${userId}_$i',
          userId: userId,
          musicIds: selectedMusicIds,
          createdAt: now.subtract(Duration(days: daysBack)),
          title: null, // Pas de titre personnalisé
        ));
      }
    }
    
    // Trier par date (plus récent en premier)
    top3s.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return top3s;
  }
  
  // Obtenir le dernier Top3 d'un utilisateur
  Top3Model? getLastTop3ForUser(String userId) {
    final userTop3s = getTop3sForUser(userId);
    return userTop3s.isNotEmpty ? userTop3s.first : null;
  }
  
  // Forcer la régénération des Top3 pour un utilisateur (pour le debug)
  void regenerateTop3sForUser(String userId) {
    _userTop3s.remove(userId);
  }
  
  // Forcer la régénération de tous les Top3 (pour le debug)
  void regenerateAllTop3s() {
    _userTop3s.clear();
  }
  
  // =============== STATISTIQUES BASÉES SUR LES TOP3 ===============
  
  // Obtenir les genres d'un utilisateur basés sur ses Top3
  Map<String, int> getUserGenresFromTop3s(String userId) {
    Map<String, int> genreCounts = {};
    final userTop3s = getTop3sForUser(userId);
    
    for (var top3 in userTop3s) {
      for (var musicId in top3.musicIds) {
        try {
          final music = getMusicById(musicId);
          final genre = music.genre ?? 'Unknown';
          genreCounts[genre] = (genreCounts[genre] ?? 0) + 1;
        } catch (e) {
          // Ignorer si la musique n'existe pas
        }
      }
    }
    
    // Convertir en map triée (garder seulement le top 5)
    final entries = genreCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Map.fromEntries(entries.take(5));
  }
  
  // Obtenir les artistes d'un utilisateur basés sur ses Top3
  Map<String, int> getUserArtistsFromTop3s(String userId) {
    Map<String, int> artistCounts = {};
    final userTop3s = getTop3sForUser(userId);
    
    for (var top3 in userTop3s) {
      for (var musicId in top3.musicIds) {
        try {
          final music = getMusicById(musicId);
          artistCounts[music.artist] = (artistCounts[music.artist] ?? 0) + 1;
        } catch (e) {
          // Ignorer si la musique n'existe pas
        }
      }
    }
    
    // Convertir en map triée (garder seulement le top 5)
    final entries = artistCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Map.fromEntries(entries.take(5));
  }
  
  // =============== STATISTIQUES GLOBALES BASÉES SUR LES TOP3 ===============
  
  // Obtenir les genres populaires basés sur tous les Top3
  Map<String, int> getPopularGenresFromTop3s() {
    Map<String, int> genreCounts = {};
    
    for (String userId in _users.map((u) => u.id)) {
      final userTop3s = getTop3sForUser(userId);
      for (var top3 in userTop3s) {
        for (var musicId in top3.musicIds) {
          try {
            final music = getMusicById(musicId);
            final genre = music.genre ?? 'Unknown';
            genreCounts[genre] = (genreCounts[genre] ?? 0) + 1;
          } catch (e) {
            // Ignorer si la musique n'existe pas
          }
        }
      }
    }
    
    // Convertir en map triée (garder seulement le top 5)
    final entries = genreCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Map.fromEntries(entries.take(5));
  }
  
  // Obtenir les artistes populaires basés sur tous les Top3
  Map<String, int> getPopularArtistsFromTop3s() {
    Map<String, int> artistCounts = {};
    
    for (String userId in _users.map((u) => u.id)) {
      final userTop3s = getTop3sForUser(userId);
      for (var top3 in userTop3s) {
        for (var musicId in top3.musicIds) {
          try {
            final music = getMusicById(musicId);
            artistCounts[music.artist] = (artistCounts[music.artist] ?? 0) + 1;
          } catch (e) {
            // Ignorer si la musique n'existe pas
          }
        }
      }
    }
    
    // Convertir en map triée (garder seulement le top 5)
    final entries = artistCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Map.fromEntries(entries.take(5));
  }
  
  // Obtenir les tracks populaires basés sur tous les Top3
  List<MusicModel> getTop10PopularTracksFromTop3s() {
    Map<String, int> trackCounts = {};
    
    for (String userId in _users.map((u) => u.id)) {
      final userTop3s = getTop3sForUser(userId);
      for (var top3 in userTop3s) {
        for (var musicId in top3.musicIds) {
          trackCounts[musicId] = (trackCounts[musicId] ?? 0) + 1;
        }
      }
    }

    // Trier les morceaux par popularité et récupérer le top 10
    List<String> sortedMusicIds = trackCounts.keys.toList()
      ..sort((a, b) => (trackCounts[b] ?? 0).compareTo(trackCounts[a] ?? 0));

    return sortedMusicIds.take(10).map((id) {
      try {
        return getMusicById(id);
      } catch (e) {
        return null;
      }
    }).where((music) => music != null).cast<MusicModel>().toList();
  }
}
