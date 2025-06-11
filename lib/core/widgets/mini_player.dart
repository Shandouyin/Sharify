import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/audio_player_service.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioPlayerService>(
      builder: (context, audioService, child) {
        if (!audioService.hasMusic) {
          return const SizedBox.shrink();
        }

        final music = audioService.currentMusic!;
        final progress = audioService.totalDuration.inMilliseconds > 0
            ? audioService.currentPosition.inMilliseconds /
                audioService.totalDuration.inMilliseconds
            : 0.0;
        return Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.9),
            border: Border(
                top: BorderSide(color: Colors.grey.withValues(alpha: 0.3))),
          ),
          child: Column(
            children: [
              // Barre de progression
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                minHeight: 2,
              ),

              // Contenu du mini-lecteur
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      // Image de l'album
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.network(
                            music.albumArt,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.music_note, size: 24),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Informations de la musique
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              music.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              music.artist,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Contrôles
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Temps restant (sur 30s)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${30 - audioService.currentPosition.inSeconds}s',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            const SizedBox(width: 2),
                            // Bouton play/pause
                            SizedBox(
                              width: 32,
                              height: 32,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  audioService.isLoading
                                      ? Icons.hourglass_empty
                                      : audioService.isCompleted
                                          ? Icons.refresh
                                          : audioService.isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: audioService.isLoading
                                    ? null
                                    : () async {
                                        if (audioService.isCompleted) {
                                          await audioService.restart();
                                        } else {
                                          await audioService.togglePlayPause();
                                        }
                                      },
                              ),
                            ),

                            const SizedBox(width: 2),

                            // Bouton stop
                            SizedBox(
                              width: 28,
                              height: 28,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                                onPressed: () async {
                                  await audioService.stop();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
