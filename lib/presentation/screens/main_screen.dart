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
    const Placeholder(), // This will be temporarily empty for the '+' button
    const StatisticsScreen(),
    const ProfileScreen(),
  ];
  
  void _onItemTapped(int index) {
    // If center button (index 2) is tapped, we'll handle it differently
    if (index == 2) {
      // Show dialog or navigate to create screen
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
                  // TODO: Navigate to create/edit top 3 screen
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
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 0.5
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Accueil', 0),
            _buildNavItem(Icons.people, 'Ami(e)s', 1),
            _buildNavItem(Icons.add_circle, '', 2, size: 40),
            _buildNavItem(Icons.bar_chart, 'Statistiques', 3),
            _buildNavItem(Icons.person, 'Profil', 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, {double size = 30}) {
    bool isSelected = _selectedIndex == index;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: size,
              color: isSelected ? colorScheme.primary : colorScheme.onSurface,
            ),
            if (label.isNotEmpty)
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }
}