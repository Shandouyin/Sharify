import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class DeezerService {
  static const String _baseUrl = 'https://api.deezer.com';

  /// Recherche une musique sur Deezer à partir du titre et de l'artiste
  static Future<Map<String, dynamic>?> searchTrack(String title, String artist) async {
    try {
      // Construire la requête de recherche
      final query = Uri.encodeComponent('$title $artist');
      final url = Uri.parse('$_baseUrl/search?q=$query&limit=1');
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['data'] != null && data['data'].isNotEmpty) {
          final track = data['data'][0];
          
          // Vérifier que la track contient bien un preview
          if (track['preview'] != null && track['preview'].isNotEmpty) {
            return {
              'id': track['id'],
              'title': track['title'],
              'artist': track['artist']['name'],
              'album': track['album']['title'],
              'preview_url': track['preview'],
              'cover': track['album']['cover_medium'],
              'duration': track['duration'], // en secondes
            };
          }        }
      }
    } catch (e) {
      debugPrint('Erreur lors de la recherche Deezer: $e');
    }
    
    return null;
  }

  /// Recherche une musique avec une stratégie de fallback
  /// Essaie d'abord avec titre + artiste, puis seulement le titre
  static Future<Map<String, dynamic>?> searchTrackWithFallback(String title, String artist) async {
    // Première tentative avec titre et artiste
    var result = await searchTrack(title, artist);
    
    if (result != null) {
      return result;
    }
    
    // Deuxième tentative avec seulement le titre
    try {
      final query = Uri.encodeComponent(title);
      final url = Uri.parse('$_baseUrl/search?q=$query&limit=5');
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['data'] != null && data['data'].isNotEmpty) {
          // Parcourir les résultats pour trouver le meilleur match
          for (var track in data['data']) {
            if (track['preview'] != null && track['preview'].isNotEmpty) {
              // Vérifier si l'artiste correspond approximativement
              final trackArtist = track['artist']['name'].toLowerCase();
              final searchArtist = artist.toLowerCase();
              
              if (trackArtist.contains(searchArtist) || searchArtist.contains(trackArtist)) {
                return {
                  'id': track['id'],
                  'title': track['title'],
                  'artist': track['artist']['name'],
                  'album': track['album']['title'],
                  'preview_url': track['preview'],
                  'cover': track['album']['cover_medium'],
                  'duration': track['duration'],
                };
              }
            }
          }
          
          // Si aucun match d'artiste, prendre le premier avec preview
          for (var track in data['data']) {
            if (track['preview'] != null && track['preview'].isNotEmpty) {
              return {
                'id': track['id'],
                'title': track['title'],
                'artist': track['artist']['name'],
                'album': track['album']['title'],
                'preview_url': track['preview'],
                'cover': track['album']['cover_medium'],
                'duration': track['duration'],
              };
            }
          }        }
      }
    } catch (e) {
      debugPrint('Erreur lors de la recherche Deezer (fallback): $e');
    }
    
    return null;
  }
}
