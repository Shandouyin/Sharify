class Top3Model {
  final String id;
  final String userId;
  final List<String> musicIds;
  final DateTime createdAt;
  final String? title; // Titre optionnel pour le Top3

  Top3Model({
    required this.id,
    required this.userId,
    required this.musicIds,
    required this.createdAt,
    this.title,
  });

  factory Top3Model.fromJson(Map<String, dynamic> json) {
    return Top3Model(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      musicIds: List<String>.from(json['musicIds'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'musicIds': musicIds,
      'createdAt': createdAt.toIso8601String(),
      'title': title,
    };
  }
}
