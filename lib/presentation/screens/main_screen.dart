import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'friends_screen.dart';
import 'statistics_screen.dart';
import 'profile_screen.dart';
import 'create_top3_screen.dart';
import '../../core/widgets/background_container.dart';

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
  ];  void _onItemTapped(int index) {
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
    ];    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_selectedIndex]),
        backgroundColor: Colors.black,
        scrolledUnderElevation:
            0, // Désactive l'effet d'élévation lors du défilement
        elevation: 0, // Supprime l'ombre
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: BackgroundContainer(
        child: _screens[_selectedIndex],
      ),
      extendBody: true, // Pour permettre au contenu d'aller sous la navbar
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius:
                BorderRadius.circular(30), // Plus grand rayon pour plus d'arc
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
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index,
      {double size = 30}) {
    bool isSelected = _selectedIndex == index;
    const Color selectedColor = Color(0xFF0F7ACC); // Bleu spécifié (0F7ACC)

    // Calculer la largeur pour chaque élément de manière fixe
    final double itemWidth = MediaQuery.of(context).size.width / 5 - 10;

    return SizedBox(
      width: itemWidth, // Largeur fixe
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onItemTapped(index),
        child: Container(
          color: Colors.transparent,
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
                  textAlign: TextAlign.center, // Centre le texte
                  style: TextStyle(
                    color: isSelected ? selectedColor : Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight
                        .w500, // Utiliser w500 (medium) au lieu de basculer entre normal/bold
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
