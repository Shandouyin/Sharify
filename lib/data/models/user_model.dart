class UserModel {
  final String id;
  final String username;
  final String profilePicture;
  final List<String> topMusicIds;
  final List<String> friendIds;

  UserModel({
    required this.id,
    required this.username,
    required this.profilePicture,
    required this.topMusicIds,
    required this.friendIds,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      topMusicIds: List<String>.from(json['topMusicIds'] ?? []),
      friendIds: List<String>.from(json['friendIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'profilePicture': profilePicture,
      'topMusicIds': topMusicIds,
      'friendIds': friendIds,
    };
  }
}