import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../services/places_service.dart';
import '../services/location_service.dart';
import '../services/database_service.dart';
import '../services/recommendation_service.dart';
import '../constants/app_constants.dart';

enum SortType { rating, distance, ratingCount, recommended }

class RestaurantProvider extends ChangeNotifier {
  final PlacesService _placesService = PlacesService();
  final LocationService _locationService = LocationService();
  final DatabaseService _db = DatabaseService();
  final RecommendationService _recService = RecommendationService();

  List<Restaurant> _restaurants = [];
  List<Restaurant> _filteredRestaurants = [];
  List<Restaurant> _surveyResults = [];
  Restaurant? _selectedRestaurant;
  bool _isLoading = false;
  String? _error;
  double? _currentLat;
  double? _currentLng;
  String _currentCity = '';
  int _selectedCategoryIndex = 0;
  SortType _sortType = SortType.recommended;
  bool _showOnlyOpen = false;
  int _selectedRadius = AppConstants.defaultRadius;
  List<Restaurant> _favorites = [];
  List<String> _searchHistory = [];
  bool _isDarkMode = false;
  String _currentLanguage = 'tr';
  List<Restaurant> _recentlyViewed = [];
  Map<String, List<String>> _mealCardsMap = {};
  String? _mealCardFilter;
  Set<String> _dietaryFilters = {};
  int? _priceFilter;

  // Getters
  List<Restaurant> get restaurants => _filteredRestaurants;
  List<Restaurant> get surveyResults => _surveyResults;
  Restaurant? get selectedRestaurant => _selectedRestaurant;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double? get currentLat => _currentLat;
  double? get currentLng => _currentLng;
  String get currentCity => _currentCity;
  int get selectedCategoryIndex => _selectedCategoryIndex;
  SortType get sortType => _sortType;
  bool get showOnlyOpen => _showOnlyOpen;
  int get selectedRadius => _selectedRadius;
  List<Restaurant> get favorites => _favorites;
  List<String> get searchHistory => _searchHistory;
  bool get isDarkMode => _isDarkMode;
  String get currentLanguage => _currentLanguage;
  List<Restaurant> get recentlyViewed => _recentlyViewed;
  Map<String, List<String>> get mealCardsMap => _mealCardsMap;
  String? get mealCardFilter => _mealCardFilter;
  Set<String> get dietaryFilters => _dietaryFilters;
  int? get priceFilter => _priceFilter;

  /// Uygulama baslarken veritabanindan verileri yukle
  Future<void> init() async {
    _favorites = await _db.getFavorites();
    _searchHistory = await _db.getSearchHistory();
    _isDarkMode = await _db.isDarkMode();
    _currentLanguage = await _db.getPreference('language') ?? 'tr';
    _mealCardsMap = await _db.getAllMealCards();
    notifyListeners();
  }

  /// Son goruntulenen restoranlara ekle
  void addToRecentlyViewed(Restaurant restaurant) {
    _recentlyViewed.removeWhere((r) => r.placeId == restaurant.placeId);
    _recentlyViewed.insert(0, restaurant);
    if (_recentlyViewed.length > 10) {
      _recentlyViewed = _recentlyViewed.sublist(0, 10);
    }
    notifyListeners();
  }

  /// Dil degistir
  Future<void> setLanguage(String lang) async {
    _currentLanguage = lang;
    await _db.setPreference('language', lang);
    notifyListeners();
  }

  /// Dark mode toggle
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _db.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  /// GPS ile mevcut konumu al ve restoranlari yukle
  Future<void> loadWithCurrentLocation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentLocation();
      _currentLat = position.latitude;
      _currentLng = position.longitude;
      try {
        _currentCity = await _locationService.getCityFromCoordinates(
            _currentLat!, _currentLng!);
      } catch (_) {
        _currentCity = 'Konum';
      }
      await _searchRestaurants();
    } catch (e) {
      _currentLat = 41.0082;
      _currentLng = 28.9784;
      _currentCity = 'Istanbul (varsayilan)';
      _error = null;
      try {
        await _searchRestaurants();
      } catch (_) {
        _error = 'restaurants_load_error';
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  /// Sehir ismiyle arama yap
  Future<void> searchByCity(String cityName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await _db.addSearchHistory(cityName);
    _searchHistory = await _db.getSearchHistory();

    try {
      final location = await _locationService.getLocationFromCity(cityName);
      _currentLat = location.lat;
      _currentLng = location.lng;
      _currentCity = location.cityName;
      await _searchRestaurants();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Arama gecmisini temizle
  Future<void> clearSearchHistory() async {
    await _db.clearSearchHistory();
    _searchHistory = [];
    notifyListeners();
  }

  /// Kategori sec
  void selectCategory(int index) {
    _selectedCategoryIndex = index;
    _searchRestaurants();
  }

  /// Siralama turunu degistir
  void setSortType(SortType type) {
    _sortType = type;
    _applyFiltersAndSort();
    notifyListeners();
  }

  /// Sadece acik olanlari goster
  void toggleShowOnlyOpen() {
    _showOnlyOpen = !_showOnlyOpen;
    _applyFiltersAndSort();
    notifyListeners();
  }

  /// Yaricapi degistir
  void setRadius(int radius) {
    _selectedRadius = radius;
    _searchRestaurants();
  }

  /// Restoran detaylarini yukle
  Future<void> loadRestaurantDetails(String placeId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _selectedRestaurant = await _placesService.getPlaceDetails(placeId);
      // Ziyaret gecmisine kaydet
      if (_selectedRestaurant != null) {
        final category = foodCategories[_selectedCategoryIndex].keyword;
        await _db.addVisit(_selectedRestaurant!, category);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Favorilere ekle/cikar (veritabanina kaydet)
  Future<void> toggleFavorite(Restaurant restaurant) async {
    final index = _favorites.indexWhere((r) => r.placeId == restaurant.placeId);
    if (index >= 0) {
      _favorites.removeAt(index);
      await _db.removeFavorite(restaurant.placeId);
    } else {
      _favorites.add(restaurant);
      await _db.addFavorite(restaurant);
    }
    notifyListeners();
  }

  bool isFavorite(String placeId) {
    return _favorites.any((r) => r.placeId == placeId);
  }

  // === MEAL CARDS ===
  List<String> getMealCardsForPlace(String placeId) {
    return _mealCardsMap[placeId] ?? [];
  }

  Future<void> toggleMealCard(String placeId, String cardType) async {
    final current = _mealCardsMap[placeId] ?? [];
    if (current.contains(cardType)) {
      await _db.removeMealCard(placeId, cardType);
      current.remove(cardType);
    } else {
      await _db.addMealCard(placeId, cardType);
      current.add(cardType);
    }
    _mealCardsMap[placeId] = current;
    notifyListeners();
  }

  void setMealCardFilter(String? cardType) {
    _mealCardFilter = cardType;
    _applyFiltersAndSort();
    notifyListeners();
  }

  void toggleDietaryFilter(String filterId) {
    if (_dietaryFilters.contains(filterId)) {
      _dietaryFilters.remove(filterId);
    } else {
      _dietaryFilters.add(filterId);
    }
    notifyListeners();
  }

  void setPriceFilter(int? level) {
    _priceFilter = level;
    _applyFiltersAndSort();
    notifyListeners();
  }

  /// Survey sonuclarini uygula
  Future<void> applySurvey(SurveyResult survey) async {
    if (_currentLat == null || _currentLng == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Eger kategori secildiyse o kategoriyi ara
      if (survey.category.isNotEmpty) {
        final idx = foodCategories.indexWhere((c) => c.keyword == survey.category);
        if (idx >= 0) _selectedCategoryIndex = idx;
      }

      // Restoranlari al
      final category = foodCategories[_selectedCategoryIndex];
      List<Restaurant> results;
      if (category.keyword == 'restaurant') {
        results = await _placesService.searchNearby(
          lat: _currentLat!,
          lng: _currentLng!,
          radius: survey.maxDistance.toInt().clamp(500, 50000),
        );
      } else {
        results = await _placesService.textSearch(
          query: category.keyword,
          lat: _currentLat!,
          lng: _currentLng!,
          radius: survey.maxDistance.toInt().clamp(500, 50000),
        );
      }

      _surveyResults = await _recService.getRecommendationsFromSurvey(
        restaurants: results,
        survey: survey,
        userLat: _currentLat!,
        userLng: _currentLng!,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Restoran arama (internal) - with offline cache support
  Future<void> _searchRestaurants() async {
    if (_currentLat == null || _currentLng == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    final category = foodCategories[_selectedCategoryIndex];
    final cacheKey = '${_currentLat!.toStringAsFixed(3)}_${_currentLng!.toStringAsFixed(3)}_${category.keyword}_$_selectedRadius';

    try {
      if (category.keyword == 'restaurant') {
        _restaurants = await _placesService.searchNearby(
          lat: _currentLat!,
          lng: _currentLng!,
          radius: _selectedRadius,
        );
      } else {
        _restaurants = await _placesService.textSearch(
          query: category.keyword,
          lat: _currentLat!,
          lng: _currentLng!,
          radius: _selectedRadius,
        );
      }

      // Cache results for offline use
      if (_restaurants.isNotEmpty) {
        await _db.cacheRestaurants(cacheKey, _restaurants);
      }

      await _applyFiltersAndSort();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      // Try loading from cache when offline
      final cached = await _db.getCachedRestaurants(cacheKey);
      if (cached.isNotEmpty) {
        _restaurants = cached;
        await _applyFiltersAndSort();
        _isLoading = false;
        notifyListeners();
      } else {
        _error = 'restaurants_load_error';
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> _applyFiltersAndSort() async {
    _filteredRestaurants = List.from(_restaurants);

    if (_showOnlyOpen) {
      _filteredRestaurants =
          _filteredRestaurants.where((r) => r.isOpen == true).toList();
    }

    if (_mealCardFilter != null) {
      _filteredRestaurants = _filteredRestaurants.where((r) {
        final cards = _mealCardsMap[r.placeId] ?? [];
        return cards.contains(_mealCardFilter);
      }).toList();
    }

    if (_priceFilter != null) {
      _filteredRestaurants = _filteredRestaurants.where((r) {
        return r.priceLevel != null && r.priceLevel! <= _priceFilter!;
      }).toList();
    }

    switch (_sortType) {
      case SortType.rating:
        _filteredRestaurants
            .sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
        break;
      case SortType.distance:
        if (_currentLat != null && _currentLng != null) {
          _filteredRestaurants.sort((a, b) {
            final distA = a.distanceTo(_currentLat!, _currentLng!);
            final distB = b.distanceTo(_currentLat!, _currentLng!);
            return distA.compareTo(distB);
          });
        }
        break;
      case SortType.ratingCount:
        _filteredRestaurants.sort(
            (a, b) => (b.userRatingsTotal ?? 0).compareTo(a.userRatingsTotal ?? 0));
        break;
      case SortType.recommended:
        if (_currentLat != null && _currentLng != null) {
          _filteredRestaurants = await _recService.getRecommendedRestaurants(
            restaurants: _filteredRestaurants,
            userLat: _currentLat!,
            userLng: _currentLng!,
          );
        }
        break;
    }
  }
}
