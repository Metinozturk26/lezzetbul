import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/restaurant.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'lezzetbul.db');
    return await openDatabase(
      path,
      version: 4,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites (
            place_id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            lat REAL NOT NULL,
            lng REAL NOT NULL,
            rating REAL,
            user_ratings_total INTEGER,
            address TEXT,
            is_open INTEGER,
            price_level INTEGER,
            photo_reference TEXT,
            types TEXT,
            added_at TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE search_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            query TEXT NOT NULL,
            searched_at TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE visit_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            place_id TEXT NOT NULL,
            name TEXT NOT NULL,
            category TEXT,
            rating REAL,
            lat REAL NOT NULL,
            lng REAL NOT NULL,
            visited_at TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE user_preferences (
            key TEXT PRIMARY KEY,
            value TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE meal_cards (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            place_id TEXT NOT NULL,
            card_type TEXT NOT NULL,
            reported_by TEXT,
            reported_at TEXT NOT NULL,
            UNIQUE(place_id, card_type)
          )
        ''');
        await db.execute('''
          CREATE TABLE restaurant_cache (
            place_id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            lat REAL NOT NULL,
            lng REAL NOT NULL,
            rating REAL,
            user_ratings_total INTEGER,
            address TEXT,
            is_open INTEGER,
            price_level INTEGER,
            photo_reference TEXT,
            types TEXT,
            search_key TEXT NOT NULL,
            cached_at TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS visit_history (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              place_id TEXT NOT NULL,
              name TEXT NOT NULL,
              category TEXT,
              rating REAL,
              lat REAL NOT NULL,
              lng REAL NOT NULL,
              visited_at TEXT NOT NULL
            )
          ''');
          await db.execute('''
            CREATE TABLE IF NOT EXISTS user_preferences (
              key TEXT PRIMARY KEY,
              value TEXT NOT NULL
            )
          ''');
        }
        if (oldVersion < 3) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS meal_cards (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              place_id TEXT NOT NULL,
              card_type TEXT NOT NULL,
              reported_by TEXT,
              reported_at TEXT NOT NULL,
              UNIQUE(place_id, card_type)
            )
          ''');
        }
        if (oldVersion < 4) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS restaurant_cache (
              place_id TEXT PRIMARY KEY,
              name TEXT NOT NULL,
              lat REAL NOT NULL,
              lng REAL NOT NULL,
              rating REAL,
              user_ratings_total INTEGER,
              address TEXT,
              is_open INTEGER,
              price_level INTEGER,
              photo_reference TEXT,
              types TEXT,
              search_key TEXT NOT NULL,
              cached_at TEXT NOT NULL
            )
          ''');
        }
      },
    );
  }

  // === FAVORITES ===
  Future<void> addFavorite(Restaurant restaurant) async {
    final db = await database;
    await db.insert(
      'favorites',
      {
        'place_id': restaurant.placeId,
        'name': restaurant.name,
        'lat': restaurant.lat,
        'lng': restaurant.lng,
        'rating': restaurant.rating,
        'user_ratings_total': restaurant.userRatingsTotal,
        'address': restaurant.address,
        'is_open': restaurant.isOpen == true ? 1 : 0,
        'price_level': restaurant.priceLevel,
        'photo_reference': restaurant.photoReferences.isNotEmpty
            ? restaurant.photoReferences.first
            : null,
        'types': restaurant.types.join(','),
        'added_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(String placeId) async {
    final db = await database;
    await db.delete('favorites', where: 'place_id = ?', whereArgs: [placeId]);
  }

  Future<List<Restaurant>> getFavorites() async {
    final db = await database;
    final maps = await db.query('favorites', orderBy: 'added_at DESC');
    return maps.map((m) => Restaurant(
      placeId: m['place_id'] as String,
      name: m['name'] as String,
      lat: m['lat'] as double,
      lng: m['lng'] as double,
      rating: m['rating'] as double?,
      userRatingsTotal: m['user_ratings_total'] as int?,
      address: m['address'] as String?,
      isOpen: (m['is_open'] as int?) == 1,
      priceLevel: m['price_level'] as int?,
      photoReferences: m['photo_reference'] != null
          ? [m['photo_reference'] as String]
          : [],
      types: (m['types'] as String?)?.split(',') ?? [],
    )).toList();
  }

  Future<bool> isFavorite(String placeId) async {
    final db = await database;
    final result = await db.query('favorites',
        where: 'place_id = ?', whereArgs: [placeId]);
    return result.isNotEmpty;
  }

  // === SEARCH HISTORY ===
  Future<void> addSearchHistory(String query) async {
    final db = await database;
    await db.delete('search_history', where: 'query = ?', whereArgs: [query]);
    await db.insert('search_history', {
      'query': query,
      'searched_at': DateTime.now().toIso8601String(),
    });
    // Keep only last 20
    final count = (await db.query('search_history')).length;
    if (count > 20) {
      await db.delete('search_history',
          where: 'id IN (SELECT id FROM search_history ORDER BY searched_at ASC LIMIT ?)',
          whereArgs: [count - 20]);
    }
  }

  Future<List<String>> getSearchHistory() async {
    final db = await database;
    final maps = await db.query('search_history',
        orderBy: 'searched_at DESC', limit: 10);
    return maps.map((m) => m['query'] as String).toList();
  }

  Future<void> clearSearchHistory() async {
    final db = await database;
    await db.delete('search_history');
  }

  // === VISIT HISTORY (for recommendation algorithm) ===
  Future<void> addVisit(Restaurant restaurant, String category) async {
    final db = await database;
    await db.insert('visit_history', {
      'place_id': restaurant.placeId,
      'name': restaurant.name,
      'category': category,
      'rating': restaurant.rating,
      'lat': restaurant.lat,
      'lng': restaurant.lng,
      'visited_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getVisitHistory() async {
    final db = await database;
    return await db.query('visit_history', orderBy: 'visited_at DESC');
  }

  Future<Map<String, int>> getCategoryVisitCounts() async {
    final db = await database;
    final results = await db.rawQuery(
      'SELECT category, COUNT(*) as count FROM visit_history GROUP BY category ORDER BY count DESC'
    );
    final Map<String, int> counts = {};
    for (final row in results) {
      final cat = row['category'] as String?;
      if (cat != null) {
        counts[cat] = row['count'] as int;
      }
    }
    return counts;
  }

  Future<double> getAveragePreferredRating() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT AVG(rating) as avg_rating FROM visit_history WHERE rating IS NOT NULL'
    );
    if (result.isNotEmpty && result.first['avg_rating'] != null) {
      return (result.first['avg_rating'] as double);
    }
    return 4.0;
  }

  // === USER PREFERENCES ===
  Future<void> setPreference(String key, String value) async {
    final db = await database;
    await db.insert(
      'user_preferences',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getPreference(String key) async {
    final db = await database;
    final result = await db.query('user_preferences',
        where: 'key = ?', whereArgs: [key]);
    if (result.isNotEmpty) return result.first['value'] as String;
    return null;
  }

  Future<bool> isDarkMode() async {
    final value = await getPreference('dark_mode');
    return value == 'true';
  }

  Future<void> setDarkMode(bool enabled) async {
    await setPreference('dark_mode', enabled.toString());
  }

  // === MEAL CARDS ===
  Future<void> addMealCard(String placeId, String cardType, {String? reportedBy}) async {
    final db = await database;
    await db.insert(
      'meal_cards',
      {
        'place_id': placeId,
        'card_type': cardType,
        'reported_by': reportedBy,
        'reported_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> removeMealCard(String placeId, String cardType) async {
    final db = await database;
    await db.delete(
      'meal_cards',
      where: 'place_id = ? AND card_type = ?',
      whereArgs: [placeId, cardType],
    );
  }

  Future<List<String>> getMealCards(String placeId) async {
    final db = await database;
    final maps = await db.query(
      'meal_cards',
      where: 'place_id = ?',
      whereArgs: [placeId],
    );
    return maps.map((m) => m['card_type'] as String).toList();
  }

  Future<Set<String>> getPlacesWithMealCard(String cardType) async {
    final db = await database;
    final maps = await db.query(
      'meal_cards',
      where: 'card_type = ?',
      whereArgs: [cardType],
    );
    return maps.map((m) => m['place_id'] as String).toSet();
  }

  Future<Map<String, List<String>>> getAllMealCards() async {
    final db = await database;
    final maps = await db.query('meal_cards');
    final Map<String, List<String>> result = {};
    for (final m in maps) {
      final placeId = m['place_id'] as String;
      final cardType = m['card_type'] as String;
      result.putIfAbsent(placeId, () => []).add(cardType);
    }
    return result;
  }

  // === RESTAURANT CACHE ===
  Future<void> cacheRestaurants(String searchKey, List<Restaurant> restaurants) async {
    final db = await database;
    final batch = db.batch();
    // Clear old cache for this search key
    batch.delete('restaurant_cache', where: 'search_key = ?', whereArgs: [searchKey]);
    for (final r in restaurants) {
      batch.insert('restaurant_cache', {
        'place_id': r.placeId,
        'name': r.name,
        'lat': r.lat,
        'lng': r.lng,
        'rating': r.rating,
        'user_ratings_total': r.userRatingsTotal,
        'address': r.address,
        'is_open': r.isOpen == true ? 1 : (r.isOpen == false ? 0 : null),
        'price_level': r.priceLevel,
        'photo_reference': r.photoReferences.isNotEmpty ? r.photoReferences.first : null,
        'types': r.types.join(','),
        'search_key': searchKey,
        'cached_at': DateTime.now().toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<Restaurant>> getCachedRestaurants(String searchKey) async {
    final db = await database;
    // Only use cache from last 30 minutes
    final cutoff = DateTime.now().subtract(const Duration(minutes: 30)).toIso8601String();
    final maps = await db.query(
      'restaurant_cache',
      where: 'search_key = ? AND cached_at > ?',
      whereArgs: [searchKey, cutoff],
    );
    if (maps.isEmpty) return [];
    return maps.map((m) => Restaurant(
      placeId: m['place_id'] as String,
      name: m['name'] as String,
      lat: m['lat'] as double,
      lng: m['lng'] as double,
      rating: m['rating'] as double?,
      userRatingsTotal: m['user_ratings_total'] as int?,
      address: m['address'] as String?,
      isOpen: m['is_open'] != null ? (m['is_open'] as int) == 1 : null,
      priceLevel: m['price_level'] as int?,
      photoReferences: m['photo_reference'] != null ? [m['photo_reference'] as String] : [],
      types: (m['types'] as String?)?.split(',') ?? [],
    )).toList();
  }

  Future<void> clearOldCache() async {
    final db = await database;
    final cutoff = DateTime.now().subtract(const Duration(hours: 24)).toIso8601String();
    await db.delete('restaurant_cache', where: 'cached_at < ?', whereArgs: [cutoff]);
  }
}
