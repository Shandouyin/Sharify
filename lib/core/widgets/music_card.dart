import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/music_model.dart';
import '../services/audio_player_service.dart';

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
  });
  // Get colors based on rank
  Color getBackgroundColor() {
    if (backgroundColor != null) return backgroundColor!;
      switch (rank) {
      case 1:
        return const Color(0xFFF0C300).withAlpha(64); // Gold for 1st (0.25 * 255 = 64)
      case 2:
        return const Color(0xFFF0F0F0).withAlpha(64); // Silver for 2nd
      case 3:
        return const Color(0xFFAD390E).withAlpha(64); // Bronze for 3rd
      default:
        return Colors.grey.withAlpha(64);
    }
  }

  Color getButtonColor() {
    if (buttonColor != null) return buttonColor!;
    
    switch (rank) {
      case 1:
        return const Color(0xFFFF9900); // Gold button
      case 2:
        return const Color(0xFFC1D4ED); // Silver button
      case 3:
        return const Color(0xFFB74210); // Bronze button
      default:
        return Colors.grey;
    }
  }  @override
  Widget build(BuildContext context) {    // Si backgroundColor est transparent, on utilise un conteneur simple sans Card
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
                  children: [                    Text(
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
              ),
            ),              // Play button
            Consumer<AudioPlayerService>(
              builder: (context, audioService, child) {
                final isCurrentMusic = audioService.isMusicLoaded(music);
                final isPlaying = audioService.isPlayingMusic(music);
                final isLoading = audioService.isLoading && 
                    (audioService.currentMusic?.id == music.id || audioService.currentMusic == null);

                return IconButton(
                  icon: Icon(
                    isLoading 
                        ? Icons.hourglass_empty
                        : isPlaying 
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                    color: getButtonColor(),
                    size: 42,
                  ),
                  onPressed: isLoading ? null : () async {
                    if (isCurrentMusic) {
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
          children: [            // Album art
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
                  ],
                ),
              ),
            ),              // Play button
            Consumer<AudioPlayerService>(
              builder: (context, audioService, child) {
                final isCurrentMusic = audioService.isMusicLoaded(music);
                final isPlaying = audioService.isPlayingMusic(music);
                final isLoading = audioService.isLoading && 
                    (audioService.currentMusic?.id == music.id || audioService.currentMusic == null);

                return IconButton(
                  icon: Icon(
                    isLoading 
                        ? Icons.hourglass_empty
                        : isPlaying 
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                    color: getButtonColor(),
                    size: 42,
                  ),
                  onPressed: isLoading ? null : () async {
                    if (isCurrentMusic) {
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