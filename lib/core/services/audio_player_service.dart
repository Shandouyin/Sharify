import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/models/music_model.dart';
import '../services/deezer_service.dart';

class AudioPlayerService extends ChangeNotifier {
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  factory AudioPlayerService() => _instance;
  AudioPlayerService._internal() {
    _init();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  
  MusicModel? _currentMusic;
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  String? _currentPreviewUrl;

  // Getters
  MusicModel? get currentMusic => _currentMusic;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  bool get hasMusic => _currentMusic != null;
  void _init() {
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      // Si la musique commence à jouer, on n'est plus en loading
      if (state.playing) {
        _isLoading = false;
      }
      notifyListeners();
    });

    _audioPlayer.positionStream.listen((position) {
      _currentPosition = position;
      notifyListeners();
    });

    _audioPlayer.durationStream.listen((duration) {
      _totalDuration = duration ?? Duration.zero;
      notifyListeners();
    });

    // Arrêter automatiquement après 30 secondes (preview)
    _audioPlayer.positionStream.listen((position) {
      if (position.inSeconds >= 30) {
        stop();
      }
    });
  }

  /// Vérifie si une musique spécifique est en cours de lecture
  bool isPlayingMusic(MusicModel music) {
    return _currentMusic?.id == music.id && _isPlaying;
  }

  /// Vérifie si une musique spécifique est chargée (même en pause)
  bool isMusicLoaded(MusicModel music) {
    return _currentMusic?.id == music.id;
  }

  /// Lance la lecture d'une musique
  Future<void> playMusic(MusicModel music) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Si c'est la même musique, juste reprendre la lecture
      if (_currentMusic?.id == music.id && _currentPreviewUrl != null) {
        await _audioPlayer.play();
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Arrêter la musique actuelle si elle existe
      await stop();

      // Rechercher la musique sur Deezer
      final deezerTrack = await DeezerService.searchTrackWithFallback(
        music.title, 
        music.artist
      );

      if (deezerTrack != null && deezerTrack['preview_url'] != null) {
        _currentPreviewUrl = deezerTrack['preview_url'];
        _currentMusic = music;

        // Charger et jouer la musique
        await _audioPlayer.setUrl(_currentPreviewUrl!);
        await _audioPlayer.play();
      } else {
        // Si pas de preview Deezer, essayer avec l'URL du mock (si disponible)
        if (music.previewUrl.isNotEmpty && !music.previewUrl.contains('example.com')) {
          _currentPreviewUrl = music.previewUrl;
          _currentMusic = music;
          await _audioPlayer.setUrl(_currentPreviewUrl!);
          await _audioPlayer.play();
        } else {
          throw Exception('Aucun aperçu disponible pour cette musique');
        }
      }    } catch (e) {
      // En mode debug, on peut utiliser debugPrint, sinon on ignore silencieusement
      assert(() {
        debugPrint('Erreur lors de la lecture: $e');
        return true;
      }());
      _currentMusic = null;
      _currentPreviewUrl = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Met en pause la lecture
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  /// Reprend la lecture
  Future<void> resume() async {
    await _audioPlayer.play();
  }

  /// Bascule entre lecture et pause
  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await pause();
    } else {
      await resume();
    }
  }
  /// Arrête complètement la lecture
  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentMusic = null;
    _currentPreviewUrl = null;
    _currentPosition = Duration.zero;
    _totalDuration = Duration.zero;
    _isLoading = false; // Réinitialiser le loading state
    notifyListeners();
  }

  /// Seek vers une position spécifique
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}