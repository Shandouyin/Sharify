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
  MusicModel? _loadingMusic; // Musique en cours de chargement
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _isCompleted = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  String? _currentPreviewUrl;  // Getters
  MusicModel? get currentMusic => _currentMusic;
  MusicModel? get loadingMusic => _loadingMusic;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  bool get isCompleted => _isCompleted;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  bool get hasMusic => _currentMusic != null;
  void _init() {
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      // Si la musique commence à jouer, on n'est plus en loading
      if (state.playing) {
        _isLoading = false;
        _isCompleted = false; // Reset completion state when music starts
      }
      // Détecter quand la musique se termine naturellement
      if (state.processingState == ProcessingState.completed) {
        _isCompleted = true;
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
        _isCompleted = true;
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

  /// Vérifie si une musique spécifique est en cours de chargement
  bool isMusicLoading(MusicModel music) {
    return _loadingMusic?.id == music.id && _isLoading;
  }  /// Lance la lecture d'une musique
  Future<void> playMusic(MusicModel music) async {
    try {
      _isLoading = true;
      _loadingMusic = music; // Marquer cette musique comme en cours de chargement
      notifyListeners();

      // Si c'est la même musique, juste reprendre la lecture
      if (_currentMusic?.id == music.id && _currentPreviewUrl != null) {
        await _audioPlayer.play();
        _isLoading = false;
        _loadingMusic = null;
        notifyListeners();
        return;
      }      // Arrêter l'audio sans réinitialiser _currentMusic pour éviter le clignotement de l'UI
      await _audioPlayer.stop();

      // Rechercher la musique sur Deezer
      final deezerTrack = await DeezerService.searchTrackWithFallback(
          music.title, music.artist);

      if (deezerTrack != null && deezerTrack['preview_url'] != null) {
        _currentPreviewUrl = deezerTrack['preview_url'];
        _currentMusic = music;

        // Charger et jouer la musique
        await _audioPlayer.setUrl(_currentPreviewUrl!);
        await _audioPlayer.play();
      } else {
        // Si pas de preview Deezer, essayer avec l'URL du mock (si disponible)
        if (music.previewUrl.isNotEmpty &&
            !music.previewUrl.contains('example.com')) {
          _currentPreviewUrl = music.previewUrl;
          _currentMusic = music;
          await _audioPlayer.setUrl(_currentPreviewUrl!);
          await _audioPlayer.play();
        } else {
          throw Exception('Aucun aperçu disponible pour cette musique');
        }
      }
    } catch (e) {
      // En cas d'erreur, réinitialiser complètement
      _currentMusic = null;
      _currentPreviewUrl = null;
      _currentPosition = Duration.zero;
      _totalDuration = Duration.zero;
    } finally {
      _isLoading = false;
      _loadingMusic = null; // Réinitialiser la musique en cours de chargement
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

  /// Redémarre la musique depuis le début
  Future<void> restart() async {
    if (_currentMusic != null && _currentPreviewUrl != null) {
      _isCompleted = false;
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.play();
      notifyListeners();
    }
  }
  /// Arrête complètement la lecture
  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentMusic = null;
    _loadingMusic = null;
    _currentPreviewUrl = null;
    _currentPosition = Duration.zero;
    _totalDuration = Duration.zero;
    _isLoading = false; // Réinitialiser le loading state
    _isCompleted = false; // Réinitialiser le completion state
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
