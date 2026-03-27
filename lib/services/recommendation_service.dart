import '../models/restaurant.dart';
import 'database_service.dart';

class RecommendationService {
  final DatabaseService _db = DatabaseService();

  /// Kullanicinin gecmis davranislarina gore restoranlari siralar
  /// Skor = (puan * puan_agirligi) + (yakinlik * mesafe_agirligi) + (kategori_uyumu * kategori_agirligi)
  Future<List<Restaurant>> getRecommendedRestaurants({
    required List<Restaurant> restaurants,
    required double userLat,
    required double userLng,
  }) async {
    if (restaurants.isEmpty) return [];

    final categoryCounts = await _db.getCategoryVisitCounts();
    final avgRating = await _db.getAveragePreferredRating();
    final totalVisits = categoryCounts.values.fold(0, (a, b) => a + b);

    // Skor hesapla
    final scored = <_ScoredRestaurant>[];
    for (final r in restaurants) {
      double score = 0;

      // 1. Puan skoru (0-5 arasi normalize, agirlik: 0.35)
      final ratingScore = (r.rating ?? 0) / 5.0;
      score += ratingScore * 0.35;

      // 2. Popularite skoru (yorum sayisi bazli, agirlik: 0.15)
      final maxReviews = restaurants
          .map((r) => r.userRatingsTotal ?? 0)
          .fold(1, (a, b) => a > b ? a : b);
      final popScore = (r.userRatingsTotal ?? 0) / maxReviews;
      score += popScore * 0.15;

      // 3. Mesafe skoru (yakin = yuksek, agirlik: 0.20)
      final distance = r.distanceTo(userLat, userLng);
      final distScore = 1.0 - (distance / 10000).clamp(0.0, 1.0);
      score += distScore * 0.20;

      // 4. Kategori uyum skoru (kullanicinin sik gittigi kategoriler, agirlik: 0.20)
      if (totalVisits > 0) {
        double catScore = 0;
        for (final type in r.types) {
          final mappedCat = _mapTypeToCategoryKeyword(type);
          if (categoryCounts.containsKey(mappedCat)) {
            catScore += categoryCounts[mappedCat]! / totalVisits;
          }
        }
        score += catScore.clamp(0.0, 1.0) * 0.20;
      } else {
        score += 0.10; // yeni kullanici icin notr
      }

      // 5. Puan tercihi uyumu (kullanicinin gittigi yerlerin ort. puanina yakinlik, agirlik: 0.10)
      if (r.rating != null) {
        final ratingDiff = (r.rating! - avgRating).abs();
        final prefScore = 1.0 - (ratingDiff / 5.0);
        score += prefScore * 0.10;
      }

      // Bonus: Acik olan yerlere kucuk bonus
      if (r.isOpen == true) score += 0.05;

      scored.add(_ScoredRestaurant(restaurant: r, score: score));
    }

    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored.map((s) => s.restaurant).toList();
  }

  /// Survey sonuclarina gore restoran filtrele ve sirala
  Future<List<Restaurant>> getRecommendationsFromSurvey({
    required List<Restaurant> restaurants,
    required SurveyResult survey,
    required double userLat,
    required double userLng,
  }) async {
    var filtered = List<Restaurant>.from(restaurants);

    // Sadece acik olanlar
    if (survey.onlyOpen) {
      filtered = filtered.where((r) => r.isOpen == true).toList();
    }

    // Minimum puan filtresi
    if (survey.minRating > 0) {
      filtered = filtered.where((r) => (r.rating ?? 0) >= survey.minRating).toList();
    }

    // Mesafe filtresi
    if (survey.maxDistance > 0) {
      filtered = filtered.where((r) {
        return r.distanceTo(userLat, userLng) <= survey.maxDistance;
      }).toList();
    }

    // Fiyat filtresi
    if (survey.maxPriceLevel > 0) {
      filtered = filtered.where((r) {
        return r.priceLevel == null || r.priceLevel! <= survey.maxPriceLevel;
      }).toList();
    }

    // Mood'a gore siralama agirliklari
    switch (survey.mood) {
      case DiningMood.quickBite:
        filtered.sort((a, b) {
          final distA = a.distanceTo(userLat, userLng);
          final distB = b.distanceTo(userLat, userLng);
          return distA.compareTo(distB);
        });
        break;
      case DiningMood.specialOccasion:
        filtered.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
        break;
      case DiningMood.explore:
        filtered.shuffle();
        break;
      case DiningMood.popular:
        filtered.sort((a, b) =>
            (b.userRatingsTotal ?? 0).compareTo(a.userRatingsTotal ?? 0));
        break;
      case DiningMood.none:
        filtered.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
        break;
    }

    return filtered;
  }

  String _mapTypeToCategoryKeyword(String type) {
    final map = {
      'restaurant': 'restaurant',
      'cafe': 'cafe',
      'bakery': 'pastane tatli',
      'meal_delivery': 'restaurant',
      'meal_takeaway': 'restaurant',
      'bar': 'cafe',
    };
    return map[type] ?? type;
  }
}

class _ScoredRestaurant {
  final Restaurant restaurant;
  final double score;
  _ScoredRestaurant({required this.restaurant, required this.score});
}

enum DiningMood { quickBite, specialOccasion, explore, popular, none }

class SurveyResult {
  final String category;
  final DiningMood mood;
  final double minRating;
  final double maxDistance;
  final int maxPriceLevel;
  final bool onlyOpen;

  SurveyResult({
    this.category = '',
    this.mood = DiningMood.none,
    this.minRating = 0,
    this.maxDistance = 5000,
    this.maxPriceLevel = 0,
    this.onlyOpen = false,
  });
}
