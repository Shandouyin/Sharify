import 'package:flutter/material.dart';

class VerticalBarChart extends StatelessWidget {
  final Map<String, int> data;
  final double height;
  final String title;

  const VerticalBarChart({
    super.key,
    required this.data,
    this.height = 200,
    required this.title,
  });

  Color _getBarColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFF0C300).withAlpha(64); // Gold
      case 1:
        return const Color(0xFFF0F0F0).withAlpha(64); // Silver
      case 2:
        return const Color(0xFFAD390E).withAlpha(64); // Bronze
      default:
        return Colors.grey.withAlpha(64);
    }
  }

  Color _getBarBorderColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFF0C300); // Gold
      case 1:
        return const Color(0xFFF0F0F0); // Silver
      case 2:
        return const Color(0xFFAD390E); // Bronze
      default:
        return Colors.grey;
    }
  }
  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(
          child: Text(
            'Aucune donnée disponible',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    final maxValue = data.values.reduce((a, b) => a > b ? a : b);
    final entries = data.entries.toList();

    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Chart
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: entries.asMap().entries.map((entry) {
                final index = entry.key;
                final dataEntry = entry.value;
                final label = dataEntry.key;
                final value = dataEntry.value;
                // Réservons 50 pixels pour les labels en bas
                final availableHeight = height - 100;
                final barHeight = (value / maxValue) * availableHeight;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      children: [
                        // Spacer pour pousser le contenu vers le bas
                        const Spacer(),                        // Value label
                        Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            value.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Bar
                        Container(
                          width: double.infinity,
                          height: barHeight,
                          decoration: BoxDecoration(
                            color: _getBarColor(index),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getBarBorderColor(index),
                              width: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Label avec hauteur fixe pour éviter l'overflow
                        SizedBox(
                          height: 30, // Hauteur fixe pour 2 lignes
                          child: Text(
                            label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
