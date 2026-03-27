import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class AppConstants {
  /// API key is read from --dart-define at build time.
  /// Run with: flutter run --dart-define=GOOGLE_API_KEY=YOUR_KEY
  /// Falls back to empty string if not provided.
  static const String googleApiKey = String.fromEnvironment(
    'GOOGLE_API_KEY',
    defaultValue: 'AIzaSyBp9xyjovU6gtYsxhGPhfi9mOvR9qnI1qk',
  );

  static const String placesBaseUrl =
      'https://maps.googleapis.com/maps/api/place';
  static const String nearbySearchUrl = '$placesBaseUrl/nearbysearch/json';
  static const String placeDetailsUrl = '$placesBaseUrl/details/json';
  static const String placePhotoUrl = '$placesBaseUrl/photo';
  static const String textSearchUrl = '$placesBaseUrl/textsearch/json';

  static const double defaultLat = 40.7669;
  static const double defaultLng = 29.9169;
  static const int defaultRadius = 5000;
  static const int maxResults = 20;

  static const Color primaryColor = Color(0xFFFF6B35);
  static const Color secondaryColor = Color(0xFF004E89);
  static const Color accentColor = Color(0xFFFFD166);
  static const Color backgroundColor = Color(0xFFF7F7F7);
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color starColor = Color(0xFFFFB800);
}

class FoodCategory {
  final String nameKey;
  final String keyword;
  final IconData icon;

  const FoodCategory({
    required this.nameKey,
    required this.keyword,
    required this.icon,
  });

  String getName(String lang) {
    return AppLocalizations(lang).get(nameKey);
  }
}

class MealCard {
  final String id;
  final String name;
  final Color color;

  const MealCard({required this.id, required this.name, required this.color});
}

class DietaryFilter {
  final String id;
  final String nameKey;
  final IconData icon;
  final Color color;

  const DietaryFilter({required this.id, required this.nameKey, required this.icon, required this.color});
}

const List<DietaryFilter> dietaryFilters = [
  DietaryFilter(id: 'halal', nameKey: 'diet_halal', icon: Icons.verified, color: Color(0xFF2ECC71)),
  DietaryFilter(id: 'vegetarian', nameKey: 'diet_vegetarian', icon: Icons.eco, color: Color(0xFF27AE60)),
  DietaryFilter(id: 'vegan', nameKey: 'diet_vegan', icon: Icons.spa, color: Color(0xFF16A085)),
  DietaryFilter(id: 'gluten_free', nameKey: 'diet_gluten_free', icon: Icons.grain, color: Color(0xFFE67E22)),
];

const List<MealCard> mealCardTypes = [
  MealCard(id: 'sodexo', name: 'Sodexo', color: Color(0xFFE31E24)),
  MealCard(id: 'multinet', name: 'Multinet', color: Color(0xFF00A651)),
  MealCard(id: 'ticket', name: 'Ticket', color: Color(0xFF0072BC)),
  MealCard(id: 'metropol', name: 'Metropol', color: Color(0xFF6F2C91)),
  MealCard(id: 'setcard', name: 'SetCard', color: Color(0xFFFF6600)),
  MealCard(id: 'pluxee', name: 'Pluxee', color: Color(0xFF00B2A9)),
];

final List<FoodCategory> foodCategories = [
  const FoodCategory(nameKey: 'cat_all', keyword: 'restaurant', icon: Icons.restaurant),
  const FoodCategory(nameKey: 'cat_hamburger', keyword: 'hamburger', icon: Icons.lunch_dining),
  const FoodCategory(nameKey: 'cat_kebab', keyword: 'kebab', icon: Icons.kebab_dining),
  const FoodCategory(nameKey: 'cat_pizza', keyword: 'pizza', icon: Icons.local_pizza),
  const FoodCategory(nameKey: 'cat_dessert', keyword: 'pastane tatli', icon: Icons.cake),
  const FoodCategory(nameKey: 'cat_cafe', keyword: 'cafe', icon: Icons.coffee),
  const FoodCategory(nameKey: 'cat_fish', keyword: 'balik restoran', icon: Icons.set_meal),
  const FoodCategory(nameKey: 'cat_doner', keyword: 'doner', icon: Icons.dinner_dining),
  const FoodCategory(nameKey: 'cat_pide', keyword: 'pide lahmacun', icon: Icons.flatware),
  const FoodCategory(nameKey: 'cat_breakfast', keyword: 'kahvalti', icon: Icons.free_breakfast),
  const FoodCategory(nameKey: 'cat_cigkofte', keyword: 'cig kofte', icon: Icons.spa),
  const FoodCategory(nameKey: 'cat_chicken', keyword: 'tavuk restoran', icon: Icons.egg_alt),
];
