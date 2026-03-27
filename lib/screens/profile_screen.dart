import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/restaurant_provider.dart';
import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import 'auth_screen.dart';
import 'help_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  AppUser? _user;
  List<Friend> _friends = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _authService.getCurrentUser();
    List<Friend> friends = [];
    if (user != null) {
      friends = await _authService.getFriends(user.id!);
    }
    setState(() {
      _user = user;
      _friends = friends;
      _loading = false;
    });
  }

  Future<void> _logout() async {
    await _authService.logout();
    setState(() {
      _user = null;
      _friends = [];
    });
  }

  void _showAddFriendDialog(bool isDark) {
    final provider = context.read<RestaurantProvider>();
    final l = AppLocalizations(provider.currentLanguage);
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            l.get('friends_add'),
            style: TextStyle(
              color: isDark ? Colors.white : AppConstants.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: TextStyle(color: isDark ? Colors.white : AppConstants.textPrimary),
                decoration: InputDecoration(
                  hintText: l.get('auth_name'),
                  hintStyle: TextStyle(color: isDark ? Colors.white38 : AppConstants.textSecondary),
                  prefixIcon: Icon(Icons.person_outline,
                      color: isDark ? Colors.white38 : AppConstants.textSecondary),
                  filled: true,
                  fillColor: isDark ? Colors.white10 : Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: isDark ? Colors.white : AppConstants.textPrimary),
                decoration: InputDecoration(
                  hintText: l.get('auth_email'),
                  hintStyle: TextStyle(color: isDark ? Colors.white38 : AppConstants.textSecondary),
                  prefixIcon: Icon(Icons.email_outlined,
                      color: isDark ? Colors.white38 : AppConstants.textSecondary),
                  filled: true,
                  fillColor: isDark ? Colors.white10 : Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l.get('cancel'),
                  style: TextStyle(color: isDark ? Colors.white60 : AppConstants.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final email = emailController.text.trim();
                if (name.isNotEmpty && email.isNotEmpty) {
                  await _authService.addFriend(_user!.id!, name, email);
                  Navigator.pop(context);
                  _loadUser();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(l.get('friends_add_btn')),
            ),
          ],
        );
      },
    );
  }

  void _confirmRemoveFriend(Friend friend, bool isDark) {
    final provider = context.read<RestaurantProvider>();
    final l = AppLocalizations(provider.currentLanguage);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            l.get('friends_remove'),
            style: TextStyle(color: isDark ? Colors.white : AppConstants.textPrimary),
          ),
          content: Text(
            '${friend.friendName} ${l.get('friends_remove_confirm')}',
            style: TextStyle(color: isDark ? Colors.white70 : AppConstants.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l.get('cancel'),
                  style: TextStyle(color: isDark ? Colors.white60 : AppConstants.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () async {
                await _authService.removeFriend(friend.id!);
                Navigator.pop(context);
                _loadUser();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(l.get('friends_remove_btn')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppConstants.primaryColor)),
      );
    }

    // Not logged in -> show auth screen
    if (_user == null) {
      return AuthScreen(onAuthSuccess: _loadUser);
    }

    return Consumer<RestaurantProvider>(
      builder: (context, provider, _) {
        final l = AppLocalizations(provider.currentLanguage);

        return Scaffold(
          appBar: AppBar(
            title: Text(l.get('profile_title')),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // User header
              _buildUserHeader(isDark),
              const SizedBox(height: 24),

              // Stats
              _buildSectionTitle(l.get('statistics'), isDark),
              const SizedBox(height: 12),
              _buildStatsCards(provider, isDark, l),
              const SizedBox(height: 24),

              // Friends
              _buildFriendsSection(isDark, l),
              const SizedBox(height: 24),

              // Preferences
              _buildSectionTitle(l.get('preferences'), isDark),
              const SizedBox(height: 12),

              _buildSettingTile(
                icon: Icons.dark_mode,
                title: l.get('dark_mode'),
                isDark: isDark,
                trailing: Switch(
                  value: provider.isDarkMode,
                  activeColor: AppConstants.primaryColor,
                  onChanged: (_) => provider.toggleDarkMode(),
                ),
              ),

              _buildSettingTile(
                icon: Icons.language,
                title: l.get('language'),
                isDark: isDark,
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: provider.currentLanguage,
                      isDense: true,
                      dropdownColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                      style: TextStyle(
                        color: isDark ? Colors.white : AppConstants.textPrimary,
                        fontSize: 14,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'tr',
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('\ud83c\uddf9\ud83c\uddf7 '),
                              Text(l.get('turkish')),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'en',
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('\ud83c\uddec\ud83c\udde7 '),
                              Text(l.get('english')),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'ar',
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('\ud83c\uddf8\ud83c\udde6 '),
                              Text(l.get('arabic')),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) provider.setLanguage(value);
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              _buildSettingTile(
                icon: Icons.history,
                title: l.get('clear_search_history'),
                isDark: isDark,
                onTap: () {
                  provider.clearSearchHistory();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l.get('search_history_cleared')),
                      backgroundColor: AppConstants.primaryColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // App info
              _buildSectionTitle(l.get('app_info'), isDark),
              const SizedBox(height: 12),
              _buildSettingTile(
                icon: Icons.info_outline,
                title: '${l.get('version')} 2.1.0',
                isDark: isDark,
              ),
              _buildSettingTile(
                icon: Icons.star_outline,
                title: l.get('rate_app'),
                isDark: isDark,
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.help_outline,
                title: l.get('help_title'),
                isDark: isDark,
                onTap: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const HelpScreen()));
                },
              ),

              const SizedBox(height: 16),

              // Logout
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.red.withOpacity(0.2)),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.logout, color: Colors.red, size: 20),
                  ),
                  title: Text(
                    l.get('auth_logout'),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                  onTap: _logout,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),

              const SizedBox(height: 16),
              Center(
                child: Text(
                  'LezzetBul \u00a9 2026',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white24 : AppConstants.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserHeader(bool isDark) {
    final color = Color(int.parse('FF${_user!.avatarColor ?? "FF6B35"}', radix: 16));
    final initials = _user!.name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _user!.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _user!.email,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsSection(bool isDark, AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l.get('friends_title'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppConstants.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${_friends.length}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppConstants.primaryColor,
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => _showAddFriendDialog(isDark),
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.person_add, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_friends.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey.shade200,
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.people_outline, size: 48,
                    color: isDark ? Colors.white24 : Colors.grey.shade300),
                const SizedBox(height: 12),
                Text(
                  l.get('friends_empty'),
                  style: TextStyle(
                    color: isDark ? Colors.white38 : AppConstants.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l.get('friends_empty_hint'),
                  style: TextStyle(
                    color: isDark ? Colors.white24 : AppConstants.textSecondary,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          ...List.generate(_friends.length, (index) {
            final friend = _friends[index];
            final friendInitials = friend.friendName
                .split(' ')
                .map((e) => e.isNotEmpty ? e[0] : '')
                .take(2)
                .join()
                .toUpperCase();
            final colors = [
              Colors.blue,
              Colors.green,
              Colors.purple,
              Colors.teal,
              Colors.orange,
              Colors.pink,
            ];
            final friendColor = colors[index % colors.length];

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.grey.shade200,
                ),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: friendColor.withOpacity(0.15),
                  child: Text(
                    friendInitials,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: friendColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                title: Text(
                  friend.friendName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: isDark ? Colors.white : AppConstants.textPrimary,
                  ),
                ),
                subtitle: Text(
                  friend.friendEmail,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white38 : AppConstants.textSecondary,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.more_vert,
                      color: isDark ? Colors.white38 : AppConstants.textSecondary),
                  onPressed: () => _confirmRemoveFriend(friend, isDark),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : AppConstants.textPrimary,
      ),
    );
  }

  Widget _buildStatsCards(RestaurantProvider provider, bool isDark, AppLocalizations l) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            icon: Icons.favorite,
            value: '${provider.favorites.length}',
            label: l.get('nav_favorites'),
            color: Colors.red,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            icon: Icons.people,
            value: '${_friends.length}',
            label: l.get('friends_label'),
            color: AppConstants.secondaryColor,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            icon: Icons.restaurant,
            value: '${provider.restaurants.length}',
            label: l.get('restaurants_found'),
            color: AppConstants.primaryColor,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppConstants.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.white38 : AppConstants.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required bool isDark,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppConstants.primaryColor, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : AppConstants.textPrimary,
          ),
        ),
        trailing: trailing ??
            (onTap != null
                ? Icon(Icons.chevron_right,
                    color: isDark ? Colors.white24 : Colors.grey.shade400)
                : null),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
