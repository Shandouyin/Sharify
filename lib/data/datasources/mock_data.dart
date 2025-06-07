import '../models/music_model.dart';
import '../models/user_model.dart';

/// Classe contenant uniquement les données mockées pour l'application Sharify
class MockData {
  static final List<MusicModel> musicList = [    MusicModel(
      id: 'm1',
      title: 'Billie Jean',
      artist: 'Michael Jackson',
      albumArt:
          'https://upload.wikimedia.org/wikipedia/en/5/55/Michael_Jackson_-_Thriller.png',
      previewUrl: 'https://example.com/preview1',
    ),MusicModel(
      id: 'm2',
      title: 'Shape of You',
      artist: 'Ed Sheeran',
      albumArt:
          'https://upload.wikimedia.org/wikipedia/en/b/b4/Shape_Of_You_%28Official_Single_Cover%29_by_Ed_Sheeran.png',
      previewUrl: 'https://example.com/preview2',
    ),    MusicModel(
      id: 'm3',
      title: 'Bohemian Rhapsody',
      artist: 'Queen',
      albumArt:
          'https://upload.wikimedia.org/wikipedia/en/9/9f/Bohemian_Rhapsody.png',
      previewUrl: 'https://example.com/preview3',
    ),    MusicModel(
      id: 'm4',
      title: 'Happy',
      artist: 'Pharrell Williams',
      albumArt:
          'https://upload.wikimedia.org/wikipedia/en/2/23/Pharrell_Williams_-_Happy.jpg',
      previewUrl: 'https://example.com/preview4',
    ),
    MusicModel(
      id: 'm5',
      title: 'Fortnight',
      artist: 'Taylor Swift ft. Post Malone',
      albumArt:
          'https://i.scdn.co/image/ab67616d0000b2730b04da4f224b51ff86e0a481',
      previewUrl: 'https://example.com/preview5',
    ),
    MusicModel(
      id: 'm6',
      title: 'Kill Bill',
      artist: 'SZA',
      albumArt:
          'https://i.scdn.co/image/ab67616d0000b2730c471c36970b9406233842a5',
      previewUrl: 'https://example.com/preview6',
    ),    MusicModel(
      id: 'm7',
      title: 'Blinding Lights',
      artist: 'The Weeknd',
      albumArt:
          'https://upload.wikimedia.org/wikipedia/en/e/e6/The_Weeknd_-_Blinding_Lights.png',
      previewUrl: 'https://example.com/preview7',
    ),MusicModel(
      id: 'm8',
      title: 'Despacito',
      artist: 'Luis Fonsi ft. Daddy Yankee',
      albumArt:
          'https://upload.wikimedia.org/wikipedia/en/c/c8/Luis_Fonsi_Feat._Daddy_Yankee_-_Despacito_%28Official_Single_Cover%29.png',
      previewUrl: 'https://example.com/preview8',
    ),MusicModel(
      id: 'm9',
      title: 'Imagine',
      artist: 'John Lennon',
      albumArt:
          'https://upload.wikimedia.org/wikipedia/en/6/69/ImagineCover.jpg',
      previewUrl: 'https://example.com/preview9',
    ),MusicModel(
      id: 'm10',
      title: 'Hotel California',
      artist: 'Eagles',
      albumArt:
          'https://upload.wikimedia.org/wikipedia/en/4/49/Hotelcalifornia.jpg',
      previewUrl: 'https://example.com/preview10',
    ),
    MusicModel(
      id: 'm11',
      title: 'SICKO MODE',
      artist: 'Travis Scott',
      albumArt:
          'https://i.scdn.co/image/ab67616d0000b273072e9faef2ef7b6db63834a3',
      previewUrl: 'https://example.com/preview11',
    ),    MusicModel(
      id: 'm12',
      title: 'Thriller',
      artist: 'Michael Jackson',
      albumArt:
          'https://upload.wikimedia.org/wikipedia/en/5/55/Michael_Jackson_-_Thriller.png',
      previewUrl: 'https://example.com/preview12',
    ),
    MusicModel(
      id: 'm13',
      title: 'After Hours',
      artist: 'The Weeknd',
      albumArt:
          'https://i.scdn.co/image/ab67616d0000b2738863bc11d2aa12b54f5aeb36',
      previewUrl: 'https://example.com/preview13',
    ),
    MusicModel(
      id: 'm14',
      title: 'Save Your Tears',
      artist: 'The Weeknd',
      albumArt:
          'https://i.scdn.co/image/ab67616d0000b2738863bc11d2aa12b54f5aeb36',
      previewUrl: 'https://example.com/preview14',
    ),    MusicModel(
      id: 'm15',
      title: 'Stairway to Heaven',
      artist: 'Led Zeppelin',
      albumArt:
          'https://upload.wikimedia.org/wikipedia/en/2/26/Led_Zeppelin_-_Led_Zeppelin_IV.jpg',
      previewUrl: 'https://example.com/preview15',
    ),
    MusicModel(
      id: 'm16',
      title: 'Unholy',
      artist: 'Sam Smith & Kim Petras',
      albumArt:
          'https://i.scdn.co/image/ab67616d0000b273a935e4689f15953311772cc4',
      previewUrl: 'https://example.com/preview16',
    ),
    MusicModel(
      id: 'm17',
      title: 'I Wanna Be Yours',
      artist: 'Arctic Monkeys',
      albumArt:
          'https://i.scdn.co/image/ab67616d0000b2734ae1c4c5c45aabe565499163',
      previewUrl: 'https://example.com/preview17',
    ),    MusicModel(
      id: 'm18',
      title: 'Flowers',
      artist: 'Miley Cyrus',
      albumArt:
          'https://i.scdn.co/image/ab67616d0000b273f429549123dbe8552764ba1d',
      previewUrl: 'https://example.com/preview18',
    ),
    MusicModel(
      id: 'm19',
      title: 'Starboy',
      artist: 'The Weeknd ft. Daft Punk',
      albumArt:
          'https://i.scdn.co/image/ab67616d0000b273a048415db06a5b6fa7ec4e1a',
      previewUrl: 'https://example.com/preview19',
    ),
    MusicModel(
      id: 'm20',
      title: 'Die For You',
      artist: 'The Weeknd',
      albumArt:
          'https://i.scdn.co/image/ab67616d0000b273a048415db06a5b6fa7ec4e1a',
      previewUrl: 'https://example.com/preview20',
    ),
  ];

  // Données utilisateurs mockées
  static final List<UserModel> users = [
    UserModel(
      id: 'u1',
      username: 'musiclover94',
      profilePicture: 'https://randomuser.me/api/portraits/women/44.jpg',
      topMusicIds: ['m1', 'm3', 'm5'],
      friendIds: ['u2', 'u3', 'u5', 'u7'],
    ),
    UserModel(
      id: 'u2',
      username: 'beatmaster',
      profilePicture: 'https://randomuser.me/api/portraits/men/32.jpg',
      topMusicIds: ['m2', 'm4', 'm6'],
      friendIds: ['u1', 'u4', 'u6'],
    ),
    UserModel(
      id: 'u3',
      username: 'rockstar2000',
      profilePicture: 'https://randomuser.me/api/portraits/women/68.jpg',
      topMusicIds: ['m6', 'm1', 'm4'],
      friendIds: ['u1', 'u4', 'u8'],
    ),
    UserModel(
      id: 'u4',
      username: 'popfan_23',
      profilePicture: 'https://randomuser.me/api/portraits/men/55.jpg',
      topMusicIds: ['m8', 'm9', 'm10'],
      friendIds: ['u2', 'u3', 'u7'],
    ),
    UserModel(
      id: 'u5',
      username: 'guitarHero',
      profilePicture: 'https://randomuser.me/api/portraits/men/74.jpg',
      topMusicIds: ['m17', 'm18', 'm3'],
      friendIds: ['u1', 'u8'],
    ),
    UserModel(
      id: 'u6',
      username: 'rhythmQueen',
      profilePicture: 'https://randomuser.me/api/portraits/women/22.jpg',
      topMusicIds: ['m11', 'm12', 'm14'],
      friendIds: ['u2', 'u9', 'u10'],
    ),
    UserModel(
      id: 'u7',
      username: 'jazzSoul',
      profilePicture: 'https://randomuser.me/api/portraits/women/33.jpg',
      topMusicIds: ['m15', 'm7', 'm19'],
      friendIds: ['u1', 'u4'],
    ),
    UserModel(
      id: 'u8',
      username: 'classicalVibes',
      profilePicture: 'https://randomuser.me/api/portraits/men/42.jpg',
      topMusicIds: ['m20', 'm16', 'm13'],
      friendIds: ['u3', 'u5', 'u9'],
    ),
    UserModel(
      id: 'u9',
      username: 'electro_dj',
      profilePicture: 'https://randomuser.me/api/portraits/men/28.jpg',
      topMusicIds: ['m12', 'm19', 'm7'],
      friendIds: ['u6', 'u8', 'u10'],
    ),
    UserModel(
      id: 'u10',
      username: 'indieLover',
      profilePicture: 'https://randomuser.me/api/portraits/women/56.jpg',
      topMusicIds: ['m18', 'm17', 'm15'],
      friendIds: ['u6', 'u9'],
    ),
  ];

  // Identifiant de l'utilisateur courant (simulé)
  static const String currentUserId = 'u1';
}
