import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/music_model.dart';
import '../../services/audio_player_service.dart';
import '../../constants/app_constants.dart';

class MusicCard extends StatelessWidget {
  final MusicModel music;
  final int rank;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? buttonColor;

  const MusicCard({
    super.key,
    required this.music,
    required this.rank,
    this.onTap,
    this.backgroundColor,
    this.buttonColor,
  }); // Get colors based on rank
  Color getBackgroundColor() {
    if (backgroundColor != null) return backgroundColor!;
    return AppConstants.getRankBackgroundColor(rank);
  }

  Color getButtonColor() {
    if (buttonColor != null) return buttonColor!;
    return AppConstants.getRankButtonColor(rank);
  }

  @override
  Widget build(BuildContext context) {
    // Si backgroundColor est transparent, on utilise un conteneur simple sans Card
    if (backgroundColor == Colors.transparent) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            // Album art
            SizedBox(
              width: 80,
              height: 80,
              child: Image.network(
                music.albumArt,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.music_note, size: 40),
                  );
                },
              ),
            ),

            // Espace entre l'image et le texte
            const SizedBox(width: 15),

            // Song details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      music.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      music.artist,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),            ), // Play button
            Consumer<AudioPlayerService>(
              builder: (context, audioService, child) {
                final isCurrentMusic = audioService.isMusicLoaded(music);
                final isPlaying = audioService.isPlayingMusic(music);
                final isLoading = audioService.isMusicLoading(music);

                return IconButton(
                  icon: Icon(
                    isLoading
                        ? Icons.hourglass_empty
                        : (audioService.isCompleted && isCurrentMusic)
                            ? Icons.refresh
                            : isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                    color: getButtonColor(),
                    size: 42,
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (audioService.isCompleted && isCurrentMusic) {
                            await audioService.restart();
                          } else if (isCurrentMusic) {
                            await audioService.togglePlayPause();
                          } else {
                            await audioService.playMusic(music);
                          }
                        },
                );
              },
            ),
          ],
        ),
      );
    }

    // Comportement normal avec Card pour les autres cas
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: getBackgroundColor(),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // Album art
            SizedBox(
              width: 80,
              height: 80,
              child: Image.network(
                music.albumArt,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.music_note, size: 40),
                  );
                },
              ),
            ),

            // Espace entre l'image et le texte
            const SizedBox(width: 15),
            // Song details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      music.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: backgroundColor == Colors.transparent
                                ? Colors.white
                                : null, // Use theme color for Card version
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      music.artist,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: backgroundColor == Colors.transparent
                                ? Colors.white70
                                : null, // Use theme color for Card version
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],                ),
              ),
            ), // Play button
            Consumer<AudioPlayerService>(
              builder: (context, audioService, child) {
                final isCurrentMusic = audioService.isMusicLoaded(music);
                final isPlaying = audioService.isPlayingMusic(music);
                final isLoading = audioService.isMusicLoading(music);

                return IconButton(
                  icon: Icon(
                    isLoading
                        ? Icons.hourglass_empty
                        : (audioService.isCompleted && isCurrentMusic)
                            ? Icons.refresh
                            : isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                    color: getButtonColor(),
                    size: 42,
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (audioService.isCompleted && isCurrentMusic) {
                            await audioService.restart();
                          } else if (isCurrentMusic) {
                            await audioService.togglePlayPause();
                          } else {
                            await audioService.playMusic(music);
                          }
                        },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
