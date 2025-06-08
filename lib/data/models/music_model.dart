class MusicModel {
  final String id;
  final String title;
  final String artist;
  final String albumArt;
  final String previewUrl;
  final String? genre;

  MusicModel({
    required this.id,
    required this.title, 
    required this.artist,
    required this.albumArt,
    required this.previewUrl,
    this.genre,
  });
  factory MusicModel.fromJson(Map<String, dynamic> json) {
    return MusicModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      albumArt: json['albumArt'] ?? '',
      previewUrl: json['previewUrl'] ?? '',
      genre: json['genre'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'albumArt': albumArt,
      'previewUrl': previewUrl,
      'genre': genre,
    };
  }
}