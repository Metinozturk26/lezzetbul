import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/restaurant_provider.dart';
import '../widgets/restaurant_card.dart';
import '../l10n/app_localizations.dart';
import 'restaurant_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<RestaurantProvider>(
      builder: (context, provider, _) {
        final l = AppLocalizations(provider.currentLanguage);

        return Scaffold(
          appBar: AppBar(
            title: Text(l.get('my_favorites')),
          ),
          body: provider.favorites.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border,
                          size: 80, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        l.get('no_favorites'),
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.white60 : AppConstants.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l.get('add_favorites_hint'),
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white38 : AppConstants.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l.get('favorites_persist'),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppConstants.primaryColor.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Text(
                        '${provider.favorites.length} ${l.get('favorite_places')}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white60 : AppConstants.textSecondary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        itemCount: provider.favorites.length,
                        itemBuilder: (context, index) {
                          final restaurant = provider.favorites[index];
                          return RestaurantCard(
                            restaurant: restaurant,
                            userLat: provider.currentLat,
                            userLng: provider.currentLng,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RestaurantDetailScreen(
                                      placeId: restaurant.placeId),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
