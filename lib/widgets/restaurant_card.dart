import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../models/restaurant.dart';
import '../providers/restaurant_provider.dart';
import '../services/places_service.dart';
import '../l10n/app_localizations.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final double? userLat;
  final double? userLng;
  final VoidCallback onTap;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    this.userLat,
    this.userLng,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<RestaurantProvider>();
    final l = AppLocalizations(provider.currentLanguage);
    final distance = (userLat != null && userLng != null)
        ? restaurant.distanceTo(userLat!, userLng!)
        : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fotograf
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: SizedBox(
                height: 180,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    restaurant.photoReferences.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: PlacesService.getPhotoUrl(
                                restaurant.photoReferences.first),
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              color: isDark ? Colors.white10 : Colors.grey.shade200,
                              child: const Center(
                                child: CircularProgressIndicator(
                                    color: AppConstants.primaryColor,
                                    strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (_, __, ___) => Container(
                              color: AppConstants.primaryColor.withOpacity(0.1),
                              child: const Icon(Icons.restaurant,
                                  size: 48,
                                  color: AppConstants.primaryColor),
                            ),
                          )
                        : Container(
                            color: AppConstants.primaryColor.withOpacity(0.1),
                            child: const Icon(Icons.restaurant,
                                size: 48, color: AppConstants.primaryColor),
                          ),
                    // Puan badge
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star,
                                size: 16, color: AppConstants.starColor),
                            const SizedBox(width: 4),
                            Text(
                              restaurant.rating?.toStringAsFixed(1) ?? '-',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: isDark ? Colors.white : AppConstants.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Favori butonu
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Consumer<RestaurantProvider>(
                        builder: (context, provider, _) {
                          final isFav =
                              provider.isFavorite(restaurant.placeId);
                          return GestureDetector(
                            onTap: () =>
                                provider.toggleFavorite(restaurant),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Icon(
                                isFav
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 20,
                                color: isFav
                                    ? Colors.red
                                    : isDark ? Colors.white60 : AppConstants.textSecondary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Acik/Kapali + Mesafe
                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: Row(
                        children: [
                          if (restaurant.isOpen != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: restaurant.isOpen!
                                    ? Colors.green
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                restaurant.isOpen! ? l.get('open_now') : l.get('closed'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          const Spacer(),
                          if (distance != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.directions_walk,
                                      size: 12, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatDistance(distance),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bilgiler
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppConstants.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 14, color: isDark ? Colors.white38 : AppConstants.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          restaurant.address ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white38 : AppConstants.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.people_outline,
                          size: 14, color: isDark ? Colors.white30 : Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(
                        '${restaurant.userRatingsTotal ?? 0} ${l.get('review_count')}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white30 : Colors.grey.shade500,
                        ),
                      ),
                      const Spacer(),
                      if (restaurant.priceLevelText.isNotEmpty)
                        Text(
                          restaurant.priceLevelText,
                          style: const TextStyle(
                            color: AppConstants.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                  // Meal card badges
                  if (provider.getMealCardsForPlace(restaurant.placeId).isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: provider.getMealCardsForPlace(restaurant.placeId).map((cardId) {
                        final card = mealCardTypes.firstWhere(
                          (c) => c.id == cardId,
                          orElse: () => mealCardTypes.first,
                        );
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: card.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            card.name,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: card.color,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toInt()} m';
    }
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }
}
