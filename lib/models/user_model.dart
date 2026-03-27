class AppUser {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String? avatarColor;
  final String createdAt;

  AppUser({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.avatarColor,
    String? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'password': password,
      'avatar_color': avatarColor ?? 'FF6B35',
      'created_at': createdAt,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as int?,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      avatarColor: map['avatar_color'] as String?,
      createdAt: map['created_at'] as String,
    );
  }

  AppUser copyWith({String? name, String? email, String? avatarColor}) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password,
      avatarColor: avatarColor ?? this.avatarColor,
      createdAt: createdAt,
    );
  }
}

class Friend {
  final int? id;
  final int userId;
  final String friendName;
  final String friendEmail;
  final String addedAt;

  Friend({
    this.id,
    required this.userId,
    required this.friendName,
    required this.friendEmail,
    String? addedAt,
  }) : addedAt = addedAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'friend_name': friendName,
      'friend_email': friendEmail,
      'added_at': addedAt,
    };
  }

  factory Friend.fromMap(Map<String, dynamic> map) {
    return Friend(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      friendName: map['friend_name'] as String,
      friendEmail: map['friend_email'] as String,
      addedAt: map['added_at'] as String,
    );
  }
}
