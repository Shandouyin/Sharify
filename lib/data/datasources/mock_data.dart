import '../models/music_model.dart';
import '../models/user_model.dart';

/// Classe contenant uniquement les données mockées pour l'application Sharify
class MockData {
  // Données musicales mockées
  static final List<MusicModel> musicList = [
    MusicModel(
      id: 'm1',
      title: 'Blinding Lights',
      artist: 'The Weeknd',
      albumArt:
          'https://i.scdn.co/image/ab67616d0000b273c5649add07ed3720be9d5526',
      previewUrl: 'https://example.com/preview1',
    ),
    MusicModel(
      id: 'm2',
      title: 'As It Was',
      artist: 'Harry Styles',
      albumArt:
          'https://i.scdn.co/image/ab67616d0000b2732e8ed79e177ff6011076f5f0',
      previewUrl: 'https://example.com/preview2',
    ),
    MusicModel(
      id: 'm3',
      title: 'Bad Habits',
      artist: 'Ed Sheeran',
      albumArt:
          'https://i.scdn.co/image/ab67616d0000b2732a038d3bf875d23e4aeaa84e',
      previewUrl: 'https://example.com/preview3',
    ),
    MusicModel(
      id: 'm4',
      title: 'Stay',
      artist: 'The Kid LAROI & Justin Bieber',
      albumArt:
          'https://i.scdn.co/image/ab67616d0000b273bd9ef5c294ede777c8328a02',
      previewUrl: 'https://example.com/preview4',
    ),
    MusicModel(
      id: 'm5',
      title: 'Heat Waves',
      artist: 'Glass Animals',
      albumArt:
          'https://i.scdn.co/image/ab67616d0000b273c63be7d5cd8dd93c9d5a1afe',
      previewUrl: 'https://example.com/preview5',
    ),
    MusicModel(
      id: 'm6',
      title: 'Montero (Call Me By Your Name)',
      artist: 'Lil Nas X',
      albumArt:
          'https://i.scdn.co/image/ab67616d0000b273be82673b5f79d9658ec0a9fd',
      previewUrl: 'https://example.com/preview6',
    ),
    MusicModel(
      id: 'm7',
      title: 'Dance The Night',
      artist: 'Dua Lipa',
      albumArt:
          'https://i.scdn.co/image/ab67616d0000b273864ddb3f85d72b6eb1404d6b',
      previewUrl: 'https://example.com/preview7',
    ),
    MusicModel(
      id: 'm8',
      title: 'Cruel Summer',
      artist: 'Taylor Swift',
      albumArt:
          'https://i.scdn.co/image/ab67616d0000b273e787cffec20aa2a396a61647',
      previewUrl: 'https://example.com/preview8',
    ),
    MusicModel(
      id: 'm9',
      title: 'Flowers',
      artist: 'Miley Cyrus',
      albumArt:
          'https://i.scdn.co/image/ab67616d0000b2739b8379f34256c5ce3a38febd',
      previewUrl: 'https://example.com/preview9',
    ),
    MusicModel(
      id: 'm10',
      title: 'Levitating',
      artist: 'Dua Lipa ft. DaBaby',
      albumArt:
          'https://i.scdn.co/image/ab67616d0000b2734aeaee7a1e4e5a92822a22f0',
      previewUrl: 'https://example.com/preview10',
    ),
    MusicModel(
      id: 'm11',
      title: 'SICKO MODE',
      artist: 'Travis Scott',
      albumArt:
          'https://i.scdn.co/image/ab67616d0000b273072e9faef2ef7b6db63834a3',
      previewUrl: 'https://example.com/preview11',
    ),
    MusicModel(
      id: 'm12',
      title: 'abcdefu',
      artist: 'GAYLE',
      albumArt:
          'https://i.scdn.co/image/ab67616d0000b273ba7fe7dd76cd3d7e3e1b7b6a',
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
    ),
    MusicModel(
      id: 'm15',
      title: 'Golden Hour',
      artist: 'JVKE',
      albumArt:
          'https://i.scdn.co/image/ab67616d0000b2733986c160b0d3bcc84596d452',
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
    ),
    MusicModel(
      id: 'm18',
      title: 'Sweater Weather',
      artist: 'The Neighbourhood',
      albumArt:
          'https://i.scdn.co/image/ab67616d0000b273a9037e3111e873734acc8b70',
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
