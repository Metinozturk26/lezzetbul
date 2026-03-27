import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'lezzetbul_users.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            avatar_color TEXT DEFAULT 'FF6B35',
            created_at TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE friends (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            friend_name TEXT NOT NULL,
            friend_email TEXT NOT NULL,
            added_at TEXT NOT NULL,
            FOREIGN KEY (user_id) REFERENCES users (id)
          )
        ''');
      },
    );
  }

  // === AUTH ===

  Future<AppUser?> register(String name, String email, String password) async {
    final db = await database;
    final existing = await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (existing.isNotEmpty) return null; // email already exists

    final id = await db.insert('users', {
      'name': name,
      'email': email,
      'password': _hashPassword(password),
      'avatar_color': _randomColor(),
      'created_at': DateTime.now().toIso8601String(),
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('logged_in_user_id', id);

    return AppUser(
      id: id,
      name: name,
      email: email,
      password: password,
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  Future<AppUser?> login(String email, String password) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, _hashPassword(password)],
    );

    if (results.isEmpty) return null;

    final user = AppUser.fromMap(results.first);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('logged_in_user_id', user.id!);
    return user;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_in_user_id');
  }

  Future<AppUser?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('logged_in_user_id');
    if (userId == null) return null;

    final db = await database;
    final results = await db.query('users', where: 'id = ?', whereArgs: [userId]);
    if (results.isEmpty) return null;
    return AppUser.fromMap(results.first);
  }

  Future<void> updateUser(AppUser user) async {
    final db = await database;
    await db.update(
      'users',
      {'name': user.name, 'email': user.email, 'avatar_color': user.avatarColor},
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // === FRIENDS ===

  Future<void> addFriend(int userId, String name, String email) async {
    final db = await database;
    await db.insert('friends', {
      'user_id': userId,
      'friend_name': name,
      'friend_email': email,
      'added_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> removeFriend(int friendId) async {
    final db = await database;
    await db.delete('friends', where: 'id = ?', whereArgs: [friendId]);
  }

  Future<List<Friend>> getFriends(int userId) async {
    final db = await database;
    final maps = await db.query(
      'friends',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'added_at DESC',
    );
    return maps.map((m) => Friend.fromMap(m)).toList();
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final encoded = base64Encode(bytes);
    // Simple hash: reverse + encode again for basic obfuscation
    final reversed = encoded.split('').reversed.join();
    return base64Encode(utf8.encode(reversed));
  }

  String _randomColor() {
    final colors = ['FF6B35', '004E89', '2ECC71', 'E74C3C', '9B59B6', '3498DB', 'F39C12', '1ABC9C'];
    return (colors..shuffle()).first;
  }
}
