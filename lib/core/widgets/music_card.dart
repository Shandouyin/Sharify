import 'package:flutter/material.dart';
import '../../data/models/music_model.dart';

class MusicCard extends StatelessWidget {
  final MusicModel music;
  final int rank;
  final VoidCallback? onTap;

  const MusicCard({
    super.key,
    required this.music,
    required this.rank,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
              icon: const Icon(Icons.play_circle_filled),
              color: Theme.of(context).colorScheme.primary,
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