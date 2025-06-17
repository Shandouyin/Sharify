import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'friends_screen.dart';
import 'statistics_screen.dart';
import 'profile_screen.dart';
import 'create_top3_screen.dart';
import '../../core/widgets/ui_components/background_container.dart';
import '../../core/widgets/modals/global_search_modal.dart';
import '../../core/widgets/players/mini_player.dart';
import '../../core/services/audio_player_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Méthode pour changer d'écran (publique pour être accessible)
  void changeScreen(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late final List<Widget> _screens = [
    const HomeScreen(),
    const FriendsScreen(),
    CreateTop3Screen(onNavigateToHome: changeScreen),
    const StatisticsScreen(),
    const ProfileScreen(),
  ];
  void _onItemTapped(int index) {
    changeScreen(index);
  }

  @override
  Widget build(BuildContext context) {
    // Liste des titres pour chaque écran de navigation
    final List<String> titles = [
      'Sharify', // Home
      'Ami(e)s', // Friends
      'Création du Top 3', // Create Top 3
      'Statistiques',
      'Profil',
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_selectedIndex]),
        backgroundColor: Colors.black,
        scrolledUnderElevation:
            0, // Désactive l'effet d'élévation lors du défilement
        elevation: 0, // Supprime l'ombre
        actions: [
          // Afficher la barre de recherche seulement sur l'accueil (index 0) et amis (index 1)
          if (_selectedIndex == 0 || _selectedIndex == 1)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  enableDrag: true, // Permet le drag-to-dismiss
                  isDismissible: true, // Permet de fermer en tapant à côté
                  builder: (context) => const GlobalSearchModal(),
                );
              },
            ),
        ],
      ),
      body: BackgroundContainer(
        child: _screens[_selectedIndex],
      ),
      extendBody: true,
      bottomNavigationBar: Consumer<AudioPlayerService>(
        builder: (context, audioService, child) {
          final bool hasActiveMusic = audioService.hasMusic;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Mini-lecteur au-dessus de la barre de navigation
              const MiniPlayer(),
              // Barre de navigation avec style conditionnel
              Container(
                padding: hasActiveMusic
                    ? EdgeInsets.zero
                    : const EdgeInsets.only(left: 24, right: 24, bottom: 16),
                child: Container(
                  height: 50,
                  margin: hasActiveMusic
                      ? EdgeInsets.zero
                      : const EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: hasActiveMusic
                        ? BorderRadius.zero
                        : BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(Icons.home, 'Accueil', 0),
                      _buildNavItem(Icons.people, 'Ami(e)s', 1),
                      _buildNavItem(Icons.add_circle, '', 2, size: 34),
                      _buildNavItem(Icons.bar_chart, 'Statistiques', 3),
                      _buildNavItem(Icons.person, 'Profil', 4),
                    ],
                  ),
                ),
              ),
              // Extension noire en bas quand la musique joue
              if (hasActiveMusic)
                Container(
                  height: 16,
                  color: Colors.black,
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index,
      {double size = 30}) {
    bool isSelected = _selectedIndex == index;
    const Color selectedColor = Color(0xFF0F7ACC); // Bleu spécifié (0F7ACC)

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onItemTapped(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: size,
              color: isSelected ? selectedColor : Colors.white,
            ),
            if (label.isNotEmpty)
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? selectedColor : Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
