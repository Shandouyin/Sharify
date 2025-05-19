import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'friends_screen.dart';
import 'statistics_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  
  static final List<Widget> _screens = [
    const HomeScreen(),
    const FriendsScreen(),
    const Placeholder(),
    const StatisticsScreen(),
    const ProfileScreen(),
  ];
  
  void _onItemTapped(int index) {
    if (index == 2) {
      _showAddDialog();
      return;
    }
    
    setState(() {
      _selectedIndex = index;
    });
  }
  
  void _showAddDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Create New',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.music_note),
                    SizedBox(width: 10),
                    Text('Edit My Top 3'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Material(
        elevation: 8,
        color: Theme.of(context).colorScheme.surface,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(0, Icons.home, 'Accueil', size: 30),
              _buildNavItem(1, Icons.people, 'Ami(e)s', size: 30),
              _buildNavItem(2, Icons.add_circle, '', size: 40),
              _buildNavItem(3, Icons.bar_chart, 'Stats', size: 30),
              _buildNavItem(4, Icons.person, 'Profil', size: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, {double size = 24}) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Ink(
        child: Center(
          child: Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: size,
                  color: isSelected 
                      ? Theme.of(context).colorScheme.primary 
                      : Colors.grey,
                ),
                if (label.isNotEmpty) 
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 10, // Légèrement plus petit
                        color: isSelected 
                            ? Theme.of(context).colorScheme.primary 
                            : Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis, // Ajouter ceci pour éviter le débordement
                      maxLines: 1, // Limiter à une seule ligne
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}