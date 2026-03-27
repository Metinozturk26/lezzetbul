import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/restaurant.dart';

class PlacesService {
  final String apiKey;

  PlacesService({this.apiKey = AppConstants.googleApiKey});

  /// Yakindaki restoranlari arar
  Future<List<Restaurant>> searchNearby({
    required double lat,
    required double lng,
    int radius = AppConstants.defaultRadius,
    String? keyword,
    String? pageToken,
  }) async {
    final params = {
      'location': '$lat,$lng',
      'radius': '$radius',
      'type': 'restaurant',
      'key': apiKey,
      'language': 'tr',
    };

    if (keyword != null && keyword.isNotEmpty && keyword != 'restaurant') {
      params['keyword'] = keyword;
    }

    if (pageToken != null) {
      params['pagetoken'] = pageToken;
    }

    final uri =
        Uri.parse(AppConstants.nearbySearchUrl).replace(queryParameters: params);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final results = data['results'] as List<dynamic>;
        return results.map((r) => Restaurant.fromJson(r)).toList();
      }
    }
    return [];
  }

  /// Metin tabanli arama yapar (sehir + yemek turu)
  Future<List<Restaurant>> textSearch({
    required String query,
    double? lat,
    double? lng,
    int radius = AppConstants.defaultRadius,
  }) async {
    final params = {
      'query': '$query restoran',
      'type': 'restaurant',
      'key': apiKey,
      'language': 'tr',
    };

    if (lat != null && lng != null) {
      params['location'] = '$lat,$lng';
      params['radius'] = '$radius';
    }

    final uri =
        Uri.parse(AppConstants.textSearchUrl).replace(queryParameters: params);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final results = data['results'] as List<dynamic>;
        return results.map((r) => Restaurant.fromJson(r)).toList();
      }
    }
    return [];
  }

  /// Restoran detay bilgilerini getirir
  Future<Restaurant?> getPlaceDetails(String placeId) async {
    final params = {
      'place_id': placeId,
      'key': apiKey,
      'language': 'tr',
      'fields':
          'place_id,name,geometry,rating,user_ratings_total,formatted_address,'
              'opening_hours,price_level,photos,types,formatted_phone_number,'
              'website,reviews',
    };

    final uri =
        Uri.parse(AppConstants.placeDetailsUrl).replace(queryParameters: params);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        return Restaurant.fromDetailJson(data['result']);
      }
    }
    return null;
  }

  /// Fotograf URL'i olusturur
  static String getPhotoUrl(String photoReference,
      {int maxWidth = 400}) {
    return '${AppConstants.placePhotoUrl}?maxwidth=$maxWidth'
        '&photo_reference=$photoReference'
        '&key=${AppConstants.googleApiKey}';
  }
}
