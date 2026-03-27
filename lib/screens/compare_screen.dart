import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../models/restaurant.dart';
import '../providers/restaurant_provider.dart';
import '../services/places_service.dart';
import '../l10n/app_localizations.dart';

class CompareScreen extends StatelessWidget {
  final List<Restaurant> restaurants;
  final double? userLat;
  final double? userLng;

  const CompareScreen({
    super.key,
    required this.restaurants,
    this.userLat,
    this.userLng,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<RestaurantProvider>();
    final l = AppLocalizations(provider.currentLanguage);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.get('compare')),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: restaurants.map((r) {
                return _buildColumn(r, isDark, l);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColumn(Restaurant restaurant, bool isDark, AppLocalizations l) {
    final distance = (userLat != null && userLng != null)
        ? restaurant.distanceTo(userLat!, userLng!)
        : null;

    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Photo
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: SizedBox(
              height: 140,
              width: 200,
              child: restaurant.photoReferences.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: PlacesService.getPhotoUrl(
                          restaurant.photoReferences.first),
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        color: AppConstants.primaryColor.withOpacity(0.1),
                        child: const Icon(Icons.restaurant,
                            size: 40, color: AppConstants.primaryColor),
                      ),
                    )
                  : Container(
                      color: AppConstants.primaryColor.withOpacity(0.1),
                      child: const Icon(Icons.restaurant,
                          size: 40, color: AppConstants.primaryColor),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Name
                Text(
                  restaurant.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppConstants.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                _buildCompareRow(
                  l.get('compare_rating'),
                  restaurant.rating?.toStringAsFixed(1) ?? '-',
                  Icons.star,
                  AppConstants.starColor,
                  isDark,
                ),
                _buildCompareRow(
                  l.get('compare_reviews'),
                  '${restaurant.userRatingsTotal ?? 0}',
                  Icons.people,
                  AppConstants.secondaryColor,
                  isDark,
                ),
                _buildCompareRow(
                  l.get('compare_price'),
                  restaurant.priceLevelText.isNotEmpty
                      ? restaurant.priceLevelText
                      : '-',
                  Icons.payments,
                  AppConstants.primaryColor,
                  isDark,
                ),
                if (distance != null)
                  _buildCompareRow(
                    l.get('compare_distance'),
                    _formatDistance(distance),
                    Icons.directions_walk,
                    Colors.green,
                    isDark,
                  ),
                _buildCompareRow(
                  l.get('compare_status'),
                  restaurant.isOpen == true
                      ? l.get('open_now')
                      : restaurant.isOpen == false
                          ? l.get('closed')
                          : '-',
                  Icons.schedule,
                  restaurant.isOpen == true ? Colors.green : Colors.red,
                  isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompareRow(
      String label, String value, IconData icon, Color color, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white38 : AppConstants.textSecondary,
                )),
          ),
          Text(value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppConstants.textPrimary,
              )),
        ],
      ),
    );
  }

  String _formatDistance(double meters) {
    if (meters < 1000) return '${meters.toInt()} m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }
}
