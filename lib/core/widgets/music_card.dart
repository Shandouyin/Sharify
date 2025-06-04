import 'package:flutter/material.dart';
import '../../data/models/music_model.dart';

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
        return const Color(0xFFF0C300).withOpacity(0.25); // Gold for 1st
      case 2:
        return const Color(0xFFF0F0F0).withOpacity(0.25); // Silver for 2nd
      case 3:
        return const Color(0xFFAD390E).withOpacity(0.25); // Bronze for 3rd
      default:
        return Colors.grey.withOpacity(0.25);
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
  }

  @override
  Widget build(BuildContext context) {
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
            
            // Rank circle
            Stack(
              clipBehavior: Clip.none,
              children: [
                const SizedBox(width: 15),
                Positioned(
                  left: -15,
                  top: -15,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        rank.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
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
              ),
            ),
              // Play button
            IconButton(
              icon: Icon(
                Icons.play_circle_filled, 
                color: getButtonColor(),
                size: 42,
              ),
              onPressed: () {
                // TODO: Implement preview playback
              },
            ),
          ],
        ),
      ),
    );
  }
}