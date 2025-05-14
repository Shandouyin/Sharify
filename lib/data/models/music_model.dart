class MusicModel {
  final String id;
  final String title;
  final String artist;
  final String albumArt;
  final String previewUrl;

  MusicModel({
    required this.id,
    required this.title, 
    required this.artist,
    required this.albumArt,
    required this.previewUrl,
  });

  factory MusicModel.fromJson(Map<String, dynamic> json) {
    return MusicModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      albumArt: json['albumArt'] ?? '',
      previewUrl: json['previewUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'albumArt': albumArt,
      'previewUrl': previewUrl,
    };
  }
}