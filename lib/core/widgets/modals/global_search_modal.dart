import 'package:flutter/material.dart';
import '../../../data/models/music_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/datasources/mock_data_service.dart';
import '../cards/music_card.dart';
import '../ui_components/custom_snack_bar.dart';

class GlobalSearchModal extends StatefulWidget {
  const GlobalSearchModal({super.key});

  @override
  State<GlobalSearchModal> createState() => _GlobalSearchModalState();
}

class _GlobalSearchModalState extends State<GlobalSearchModal>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final MockDataService _dataService = MockDataService();

  List<MusicModel> filteredMusic = [];
  List<UserModel> filteredUsers = [];
  Map<String, bool> followStatus = {};
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(_performSearch);

    // Écouter les changements d'onglets pour mettre à jour le placeholder
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          // Trigger rebuild pour mettre à jour le placeholder
        });
      }
    });

    // Initialiser avec toutes les données
    filteredMusic = _dataService.getAllMusic();

    // Obtenir les utilisateurs qui ne sont pas des amis de l'utilisateur actuel
    final currentUser = _dataService.currentUser;
    final allUsers = _dataService.getAllUsers();
    filteredUsers = allUsers
        .where((user) =>
            user.id != currentUser.id &&
            !currentUser.friendIds.contains(user.id))
        .toList();

    // Initialiser le statut de suivi
    for (var user in filteredUsers) {
      followStatus[user.id] = false;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        // Réinitialiser avec toutes les données
        filteredMusic = _dataService.getAllMusic();
        final currentUser = _dataService.currentUser;
        final allUsers = _dataService.getAllUsers();
        filteredUsers = allUsers
            .where((user) =>
                user.id != currentUser.id &&
                !currentUser.friendIds.contains(user.id))
            .toList();
      } else {
        // Filtrer les musiques
        filteredMusic = _dataService.getAllMusic().where((music) {
          return music.title.toLowerCase().contains(query) ||
              music.artist.toLowerCase().contains(query);
        }).toList();

        // Filtrer les utilisateurs
        final currentUser = _dataService.currentUser;
        final allUsers = _dataService.getAllUsers();
        filteredUsers = allUsers.where((user) {
          return user.id != currentUser.id &&
              !currentUser.friendIds.contains(user.id) &&
              user.username.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _toggleFollow(String userId) {
    setState(() {
      followStatus[userId] = !(followStatus[userId] ?? false);
    }); // Afficher une notification
    final isFollowing = followStatus[userId] ?? false;
    final user = filteredUsers.firstWhere((u) => u.id == userId);
    CustomSnackBar.showInfo(
      context,
      message: isFollowing
          ? 'Vous suivez maintenant ${user.username}'
          : 'Vous ne suivez plus ${user.username}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600, // Hauteur fixe pour éviter le problème de mouvement
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Titre
          const Text(
            'Recherche globale',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 16), // Barre de recherche
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: _tabController.index == 0
                    ? 'Rechercher par titre ou artiste...'
                    : 'Rechercher par utilisateur...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Onglets
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: const Color(0xFF0F7ACC),
                borderRadius: BorderRadius.circular(8),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[400],
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Musiques'),
                Tab(text: 'Utilisateurs'),
              ],
            ),
          ),

          const SizedBox(height: 16), // Contenu des onglets
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Onglet Musiques
                  _buildMusicTab(),
                  // Onglet Utilisateurs
                  _buildUsersTab(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMusicTab() {
    return filteredMusic.isEmpty
        ? const Center(
            child: Text(
              'Aucune musique trouvée',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filteredMusic.length,
            itemBuilder: (context, index) {
              final music = filteredMusic[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: MusicCard(
                  music: music,
                  rank: 0,
                  backgroundColor: Colors.grey.withAlpha(64),
                  onTap: () {
                    // Optionnel: Action au tap sur une musique
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sélectionné: ${music.title}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              );
            },
          );
  }

  Widget _buildUsersTab() {
    return filteredUsers.isEmpty
        ? const Center(
            child: Text(
              'Aucun utilisateur trouvé',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              final isFollowing = followStatus[user.id] ?? false;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/user-profile',
                        arguments: user.id);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.withAlpha(64),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        // Photo de profil
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.network(
                              user.profilePicture,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.person, size: 30),
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Infos utilisateur
                        Expanded(
                          child: Text(
                            user.username,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // Bouton Suivre
                        SizedBox(
                          width: 90,
                          height: 36,
                          child: ElevatedButton.icon(
                            icon: Icon(
                                isFollowing ? Icons.check : Icons.person_add,
                                size: 16),
                            label: Text(
                              isFollowing ? 'Suivi(e)' : 'Suivre',
                              style: const TextStyle(fontSize: 12),
                            ),
                            onPressed: () => _toggleFollow(user.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isFollowing
                                  ? Colors.grey[700]
                                  : const Color(0xFF0F7ACC),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: EdgeInsets.zero,
                              fixedSize: const Size(90, 36),
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
