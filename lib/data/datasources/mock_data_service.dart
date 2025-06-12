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
  final Map<String, Set<String>> _userLikedPosts =
      {}; // Stockage des posts likés par utilisateur

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

  // =============== MÉTHODES STATISTIQUES UNIFIÉES ===============

  /// Méthode unifiée pour obtenir les statistiques de genres
  /// Utilise les Top3 en priorité, puis fallback sur les données statiques
  Map<String, int> getGenreStatistics({String? userId, bool isGlobal = false}) {
    Map<String, int> genreCounts = {};

    if (isGlobal) {
      // Statistiques globales
      for (String uid in _users.map((u) => u.id)) {
        final userTop3s = getTop3sForUser(uid);
        if (userTop3s.isNotEmpty) {
          _addGenresFromTop3s(genreCounts, userTop3s);
        } else {
          _addGenresFromStaticData(genreCounts, uid);
        }
      }
    } else if (userId != null) {
      // Statistiques d'un utilisateur spécifique
      final userTop3s = getTop3sForUser(userId);
      if (userTop3s.isNotEmpty) {
        _addGenresFromTop3s(genreCounts, userTop3s);
      } else {
        _addGenresFromStaticData(genreCounts, userId);
      }
    }

    return _sortAndLimit(genreCounts);
  }

  /// Méthode unifiée pour obtenir les statistiques d'artistes
  Map<String, int> getArtistStatistics(
      {String? userId, bool isGlobal = false}) {
    Map<String, int> artistCounts = {};

    if (isGlobal) {
      // Statistiques globales
      for (String uid in _users.map((u) => u.id)) {
        final userTop3s = getTop3sForUser(uid);
        if (userTop3s.isNotEmpty) {
          _addArtistsFromTop3s(artistCounts, userTop3s);
        } else {
          _addArtistsFromStaticData(artistCounts, uid);
        }
      }
    } else if (userId != null) {
      // Statistiques d'un utilisateur spécifique
      final userTop3s = getTop3sForUser(userId);
      if (userTop3s.isNotEmpty) {
        _addArtistsFromTop3s(artistCounts, userTop3s);
      } else {
        _addArtistsFromStaticData(artistCounts, userId);
      }
    }

    return _sortAndLimit(artistCounts);
  }

  /// Méthode unifiée pour obtenir les tracks populaires
  List<MusicModel> getPopularTracks({int limit = 10}) {
    Map<String, int> trackCounts = {};

    // Essayer d'abord avec les Top3
    bool hasTop3Data = false;
    for (String userId in _users.map((u) => u.id)) {
      final userTop3s = getTop3sForUser(userId);
      if (userTop3s.isNotEmpty) {
        hasTop3Data = true;
        for (var top3 in userTop3s) {
          for (var musicId in top3.musicIds) {
            trackCounts[musicId] = (trackCounts[musicId] ?? 0) + 1;
          }
        }
      }
    }

    // Si pas de données Top3, utiliser les données statiques
    if (!hasTop3Data || trackCounts.isEmpty) {
      for (var user in _users) {
        for (var musicId in user.topMusicIds) {
          trackCounts[musicId] = (trackCounts[musicId] ?? 0) + 1;
        }
      }
    }

    // Trier et retourner les résultats
    List<String> sortedMusicIds = trackCounts.keys.toList()
      ..sort((a, b) => (trackCounts[b] ?? 0).compareTo(trackCounts[a] ?? 0));

    return sortedMusicIds
        .take(limit)
        .map((id) {
          try {
            return getMusicById(id);
          } catch (e) {
            return null;
          }
        })
        .where((music) => music != null)
        .cast<MusicModel>()
        .toList();
  }

  // =============== MÉTHODES AUXILIAIRES ===============

  void _addGenresFromTop3s(
      Map<String, int> genreCounts, List<Top3Model> top3s) {
    for (var top3 in top3s) {
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

  void _addGenresFromStaticData(Map<String, int> genreCounts, String userId) {
    final user = getUserById(userId);
    for (var musicId in user.topMusicIds) {
      try {
        final music = getMusicById(musicId);
        final genre = music.genre ?? 'Unknown';
        genreCounts[genre] = (genreCounts[genre] ?? 0) + 1;
      } catch (e) {
        // Ignorer si la musique n'existe pas
      }
    }
  }

  void _addArtistsFromTop3s(
      Map<String, int> artistCounts, List<Top3Model> top3s) {
    for (var top3 in top3s) {
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

  void _addArtistsFromStaticData(Map<String, int> artistCounts, String userId) {
    final user = getUserById(userId);
    for (var musicId in user.topMusicIds) {
      try {
        final music = getMusicById(musicId);
        artistCounts[music.artist] = (artistCounts[music.artist] ?? 0) + 1;
      } catch (e) {
        // Ignorer si la musique n'existe pas
      }
    }
  }

  Map<String, int> _sortAndLimit(Map<String, int> counts, {int limit = 5}) {
    final entries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(entries.take(limit));
  }

  // =============== MÉTHODES DE COMPATIBILITÉ (pour ne pas casser l'existant) ===============

  Map<String, int> getPopularGenres() => getGenreStatistics(isGlobal: true);
  Map<String, int> getPopularArtists() => getArtistStatistics(isGlobal: true);
  List<MusicModel> getTop10PopularTracks() => getPopularTracks(limit: 10);
  List<MusicModel> getCommunityTopTracks() => getPopularTracks(limit: 5);

  Map<String, int> getUserGenres(String userId) =>
      getGenreStatistics(userId: userId);
  Map<String, int> getUserArtists(String userId) =>
      getArtistStatistics(userId: userId);

  Map<String, int> getPopularGenresFromTop3s() =>
      getGenreStatistics(isGlobal: true);
  Map<String, int> getPopularArtistsFromTop3s() =>
      getArtistStatistics(isGlobal: true);
  List<MusicModel> getTop10PopularTracksFromTop3s() =>
      getPopularTracks(limit: 10);

  Map<String, int> getUserGenresFromTop3s(String userId) =>
      getGenreStatistics(userId: userId);
  Map<String, int> getUserArtistsFromTop3s(String userId) =>
      getArtistStatistics(userId: userId);

  // =============== SYSTÈME DE FAVORIS ===============

  /// Calcule la musique favorite d'un utilisateur basée sur un système de points
  /// 1ère position = 3 points, 2ème position = 2 points, 3ème position = 1 point
  MusicModel? getFavoriteMusicForUser(String userId) {
    final userTop3s = getTop3sForUser(userId);
    
    if (userTop3s.isEmpty) {
      return null;
    }

    Map<String, int> musicPoints = {};

    // Calculer les points pour chaque musique
    for (var top3 in userTop3s) {
      for (int i = 0; i < top3.musicIds.length && i < 3; i++) {
        final musicId = top3.musicIds[i];
        final points = 3 - i; // 1ère position = 3, 2ème = 2, 3ème = 1
        musicPoints[musicId] = (musicPoints[musicId] ?? 0) + points;
      }
    }

    // Trouver la musique avec le plus de points
    if (musicPoints.isEmpty) {
      return null;
    }

    String favoriteMusicId = musicPoints.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    try {
      return getMusicById(favoriteMusicId);
    } catch (e) {
      // Si la musique n'existe plus, retourner la première du dernier Top3
      final lastTop3 = getLastTop3ForUser(userId);
      if (lastTop3 != null && lastTop3.musicIds.isNotEmpty) {
        try {
          return getMusicById(lastTop3.musicIds.first);
        } catch (e) {
          return null;
        }
      }
      return null;
    }
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

    _userTop3s[userId]!.insert(
        0, top3); // Ajouter en premier pour avoir le plus récent en haut
  }

  // Générer des Top3 mockés spécifiques à chaque utilisateur
  List<Top3Model> _generateMockTop3sForUser(String userId) {
    final user = getUserById(userId);
    final List<Top3Model> top3s = [];
    final DateTime now = DateTime.now();

    // Créer un Random spécifique à l'utilisateur pour la cohérence
    final Random userRandom = Random(userId.hashCode);

    // Pool de musiques pour cet utilisateur (ses favoris + quelques autres)
    Set<String> musicPool = Set.from(user.topMusicIds);

    // Ajouter quelques musiques aléatoires de tous les genres
    final allMusic = getAllMusic();
    final randomMusic = List.from(allMusic)..shuffle(userRandom);
    musicPool.addAll(randomMusic
        .take(5 + userRandom.nextInt(5))
        .map((m) => m.id)); // Entre 5 et 9 musiques

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
        // Varier les dates de création de manière plus réaliste
        final daysBack = (i + 1) * 7 +
            userRandom.nextInt(7); // Espacer les dates de manière variable

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
  // =============== GESTION DES INTERACTIONS ET COMMENTAIRES ===============

  // Gestion des posts likés
  void likePost(String userId) {
    _userLikedPosts.putIfAbsent(currentUser.id, () => <String>{});
    _userLikedPosts[currentUser.id]!.add(userId);

    // Incrémenter le compteur de likes pour ce post
    if (_userInteractionData.containsKey(userId)) {
      _userInteractionData[userId]!['likes'] =
          (_userInteractionData[userId]!['likes'] ?? 0) + 1;
    }
  }

  void unlikePost(String userId) {
    _userLikedPosts[currentUser.id]?.remove(userId);

    // Décrémenter le compteur de likes pour ce post
    if (_userInteractionData.containsKey(userId)) {
      final currentLikes = _userInteractionData[userId]!['likes'] ?? 0;
      if (currentLikes > 0) {
        _userInteractionData[userId]!['likes'] = currentLikes - 1;
      }
    }
  }

  bool isPostLiked(String userId) {
    return _userLikedPosts[currentUser.id]?.contains(userId) ?? false;
  }

  // Vérifier si l'utilisateur actuel a liké un post
  bool hasUserLikedPost(String postUserId) {
    final currentUserId = currentUser.id;
    return _userLikedPosts[currentUserId]?.contains(postUserId) ?? false;
  }

  // Génération de commentaires persistants
  List<Map<String, dynamic>> getCommentsForUser(
      String userId, String username) {
    if (!_userComments.containsKey(userId)) {
      _userComments[userId] = _generateDemoComments(userId, username);
    }
    return List<Map<String, dynamic>>.from(_userComments[userId]!);
  }

  // Ajouter un nouveau commentaire pour un utilisateur
  void addCommentForUser(String userId, Map<String, dynamic> comment) {
    if (_userComments.containsKey(userId)) {
      _userComments[userId]!.insert(0, comment);
    }
  }

  // Mettre à jour le nombre de commentaires pour un utilisateur
  void updateCommentCount(String userId, int count) {
    if (_userInteractionData.containsKey(userId)) {
      _userInteractionData[userId]!['comments'] = count;
    }
  }

  // Compter le nombre total de commentaires pour un utilisateur
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

  // Méthodes pour générer des données aléatoires
  int getRandomLikeCount() {
    return _random.nextInt(120) + 1;
  }

  int getRandomShareCount() {
    return _random.nextInt(20) + 1;
  }

  int getRandomCommentCount() {
    return _random.nextInt(15) + 1;
  }

  List<Map<String, dynamic>> _generateDemoComments(
      String userId, String username) {
    final Random random =
        Random(userId.hashCode); // Cohérence basée sur l'ID utilisateur

    List<String> commentTexts = [
      'Excellent goût musical ! 🎵',
      'J\'adore cette sélection',
      'On a les mêmes goûts !',
      'Tu me fais découvrir de super trucs',
      'Playlist parfaite pour le weekend',
      'Cette musique me rappelle des souvenirs',
      'Génial ! Je l\'ajoute à ma playlist',
      'Tu as toujours de bonnes recommandations',
      'C\'est exactement ce qu\'il me fallait',
      'Merci pour cette découverte !',
    ];

    List<String> replyTexts = [
      'Merci ! 😊',
      'Content que ça te plaise',
      'N\'hésite pas à me faire découvrir aussi',
      'On devrait faire une playlist ensemble',
      'J\'ai d\'autres recommandations si tu veux',
    ];

    List<String> authors = [
      'alex_music',
      'sarah_beats',
      'tom_playlist',
      'emma_sound',
      'lucas_melody'
    ];

    List<Map<String, dynamic>> comments = [];
    int numberOfComments = 2 + random.nextInt(4); // Entre 2 et 5 commentaires

    for (int i = 0; i < numberOfComments; i++) {
      Map<String, dynamic> comment = {
        'id': 'comment_${userId}_$i',
        'author': authors[random.nextInt(authors.length)],
        'text': commentTexts[random.nextInt(commentTexts.length)],
        'time': '${random.nextInt(24) + 1}h', // Entre 1h et 24h
        'likes': random.nextInt(8), // Entre 0 et 7 likes
        'isLiked': random.nextBool(),
        'replies': <Map<String, dynamic>>[], // Initialiser comme liste vide
      };

      // 25% de chance d'avoir une réponse
      if (random.nextBool() && random.nextBool()) {
        // 25% de chance
        Map<String, dynamic> reply = {
          'id': 'reply_${DateTime.now().millisecondsSinceEpoch}_$i',
          'author': username,
          'text': replyTexts[random.nextInt(replyTexts.length)],
          'time': '${random.nextInt(12) + 1}h',
          'likes': random.nextInt(5)
        };
        comment['replies'].add(reply);
      }

      comments.add(comment);
    }

    return comments;
  }

  // Update user profile (mock implementation)
  void updateUserProfile(
      String userId, String newUsername, String? newImagePath) {
    final userIndex = _users.indexWhere((user) => user.id == userId);
    if (userIndex != -1) {
      final currentUser = _users[userIndex];

      // For image path, if it's a local file, we keep it as is
      // In a real app, you would upload the image to a server and get a URL back
      String profilePictureUrl = currentUser.profilePicture;
      if (newImagePath != null) {
        // In this mock, we just store the local path
        profilePictureUrl = newImagePath;
      }
      // Create a new user object with updated data
      _users[userIndex] = UserModel(
        id: currentUser.id,
        username: newUsername,
        profilePicture: profilePictureUrl,
        topMusicIds: currentUser.topMusicIds,
        friendIds: currentUser.friendIds,
      );
    }
  }
}
