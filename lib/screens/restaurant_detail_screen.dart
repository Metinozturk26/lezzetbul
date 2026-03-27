import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import '../constants/app_constants.dart';
import '../models/restaurant.dart';
import '../providers/restaurant_provider.dart';
import '../services/places_service.dart';
import '../l10n/app_localizations.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final String placeId;

  const RestaurantDetailScreen({super.key, required this.placeId});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  final PageController _photoController = PageController();
  int _currentPhotoIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RestaurantProvider>().loadRestaurantDetails(widget.placeId);
    });
  }

  @override
  void dispose() {
    _photoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<RestaurantProvider>();
    final l = AppLocalizations(provider.currentLanguage);

    return Scaffold(
      body: Consumer<RestaurantProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child:
                  CircularProgressIndicator(color: AppConstants.primaryColor),
            );
          }

          final restaurant = provider.selectedRestaurant;
          if (restaurant == null) {
            return Center(child: Text(l.get('restaurant_not_found')));
          }

          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(restaurant, provider),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoSection(restaurant, isDark, l),
                      const SizedBox(height: 20),
                      _buildActionButtons(restaurant, isDark, l),
                      const SizedBox(height: 24),
                      _buildMealCardsSection(restaurant, isDark, l, provider),
                      const SizedBox(height: 24),
                      if (restaurant.openingHoursText != null)
                        _buildOpeningHours(restaurant, isDark, l),
                      if (restaurant.reviews != null &&
                          restaurant.reviews!.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _buildReviews(restaurant.reviews!, isDark, l),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(
      Restaurant restaurant, RestaurantProvider provider) {
    final hasPhotos = restaurant.photoReferences.isNotEmpty;
    final photoCount = restaurant.photoReferences.length;

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppConstants.primaryColor,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
      ),
      actions: [
        // Paylas butonu
        IconButton(
          onPressed: () => _shareRestaurant(restaurant),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.share, color: Colors.white, size: 20),
          ),
        ),
        // Favori butonu
        IconButton(
          onPressed: () => provider.toggleFavorite(restaurant),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              provider.isFavorite(restaurant.placeId)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: provider.isFavorite(restaurant.placeId)
                  ? Colors.red
                  : Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: hasPhotos
            ? Stack(
                children: [
                  // Photo gallery with page view
                  PageView.builder(
                    controller: _photoController,
                    itemCount: photoCount,
                    onPageChanged: (i) =>
                        setState(() => _currentPhotoIndex = i),
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: PlacesService.getPhotoUrl(
                            restaurant.photoReferences[index],
                            maxWidth: 800),
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                              child: CircularProgressIndicator(
                                  color: AppConstants.primaryColor)),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: AppConstants.primaryColor.withOpacity(0.1),
                          child: const Icon(Icons.restaurant,
                              size: 80, color: AppConstants.primaryColor),
                        ),
                      );
                    },
                  ),
                  // Photo counter
                  if (photoCount > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(photoCount, (i) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: i == _currentPhotoIndex ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: i == _currentPhotoIndex
                                  ? AppConstants.primaryColor
                                  : Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              )
            : Container(
                color: AppConstants.primaryColor.withOpacity(0.1),
                child: const Icon(Icons.restaurant,
                    size: 80, color: AppConstants.primaryColor),
              ),
      ),
    );
  }

  Widget _buildInfoSection(Restaurant restaurant, bool isDark, AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          restaurant.name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppConstants.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppConstants.starColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    restaurant.rating?.toStringAsFixed(1) ?? '-',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${restaurant.userRatingsTotal ?? 0} ${l.get('reviews')}',
              style: TextStyle(
                color: isDark ? Colors.white60 : AppConstants.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 10),
            if (restaurant.priceLevelText.isNotEmpty)
              Text(
                restaurant.priceLevelText,
                style: const TextStyle(
                  color: AppConstants.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (restaurant.isOpen != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: restaurant.isOpen!
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              restaurant.isOpen! ? l.get('now_open') : l.get('now_closed'),
              style: TextStyle(
                color: restaurant.isOpen! ? Colors.green.shade700 : Colors.red,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        const SizedBox(height: 12),
        if (restaurant.address != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on,
                  size: 18, color: isDark ? Colors.white38 : AppConstants.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  restaurant.address!,
                  style: TextStyle(
                    color: isDark ? Colors.white60 : AppConstants.textSecondary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildActionButtons(Restaurant restaurant, bool isDark, AppLocalizations l) {
    return Row(
      children: [
        Expanded(
          child: _actionButton(
            icon: Icons.directions,
            label: l.get('directions'),
            color: AppConstants.primaryColor,
            isDark: isDark,
            onTap: () => _openMaps(restaurant.lat, restaurant.lng),
          ),
        ),
        const SizedBox(width: 12),
        if (restaurant.phoneNumber != null)
          Expanded(
            child: _actionButton(
              icon: Icons.phone,
              label: l.get('call'),
              color: Colors.green,
              isDark: isDark,
              onTap: () => _makeCall(restaurant.phoneNumber!),
            ),
          ),
        if (restaurant.phoneNumber != null) const SizedBox(width: 12),
        if (restaurant.website != null)
          Expanded(
            child: _actionButton(
              icon: Icons.language,
              label: l.get('website'),
              color: AppConstants.secondaryColor,
              isDark: isDark,
              onTap: () => _openUrl(restaurant.website!),
            ),
          ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(isDark ? 0.2 : 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpeningHours(Restaurant restaurant, bool isDark, AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.get('working_hours'),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppConstants.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Colors.white10 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
          ),
          child: Text(
            restaurant.openingHoursText!,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white60 : AppConstants.textSecondary,
              height: 1.8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviews(List<Review> reviews, bool isDark, AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${l.get('reviews_title')} (${reviews.length})',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppConstants.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        _buildRatingDistribution(reviews, isDark),
        const SizedBox(height: 16),
        ...reviews.map((review) => _buildReviewCard(review, isDark)),
      ],
    );
  }

  Widget _buildRatingDistribution(List<Review> reviews, bool isDark) {
    final counts = <int, int>{5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final r in reviews) {
      final star = r.rating.clamp(1, 5).toInt();
      counts[star] = (counts[star] ?? 0) + 1;
    }
    final maxCount = counts.values.fold(0, (a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
      ),
      child: Column(
        children: List.generate(5, (i) {
          final star = 5 - i;
          final count = counts[star] ?? 0;
          final ratio = maxCount > 0 ? count / maxCount : 0.0;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  child: Text(
                    '$star',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white60 : AppConstants.textSecondary,
                    ),
                  ),
                ),
                const Icon(Icons.star, size: 14, color: AppConstants.starColor),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: ratio,
                      backgroundColor: isDark ? Colors.white10 : Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        star >= 4 ? AppConstants.starColor :
                        star == 3 ? Colors.orange :
                        Colors.red.shade400,
                      ),
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 24,
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white38 : AppConstants.textSecondary,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildReviewCard(Review review, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
                backgroundImage: review.profilePhotoUrl != null
                    ? NetworkImage(review.profilePhotoUrl!)
                    : null,
                child: review.profilePhotoUrl == null
                    ? Text(
                        review.authorName.isNotEmpty
                            ? review.authorName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: AppConstants.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.authorName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isDark ? Colors.white : AppConstants.textPrimary,
                      ),
                    ),
                    Text(
                      review.relativeTimeDescription,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white38 : AppConstants.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < review.rating ? Icons.star : Icons.star_border,
                    size: 16,
                    color: AppConstants.starColor,
                  ),
                ),
              ),
            ],
          ),
          if (review.text.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              review.text,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white70 : AppConstants.textPrimary,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _shareRestaurant(Restaurant restaurant) {
    final provider = context.read<RestaurantProvider>();
    final l = AppLocalizations(provider.currentLanguage);
    final text = '${restaurant.name}\n'
        '${l.get('compare_rating')}: ${restaurant.rating?.toStringAsFixed(1) ?? "-"}/5\n'
        '${restaurant.address ?? ""}\n\n'
        'https://www.google.com/maps/place/?q=place_id:${restaurant.placeId}\n\n'
        '${l.get('shared_via')}';
    Share.share(text);
  }

  Future<void> _openMaps(double lat, double lng) async {
    final uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _makeCall(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildMealCardsSection(
      Restaurant restaurant, bool isDark, AppLocalizations l, RestaurantProvider provider) {
    final accepted = provider.getMealCardsForPlace(restaurant.placeId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.credit_card, size: 20,
                color: isDark ? Colors.white : AppConstants.textPrimary),
            const SizedBox(width: 8),
            Text(
              l.get('meal_cards_title'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppConstants.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          l.get('meal_cards_hint'),
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white38 : AppConstants.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: mealCardTypes.map((card) {
            final isSelected = accepted.contains(card.id);
            return GestureDetector(
              onTap: () => provider.toggleMealCard(restaurant.placeId, card.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? card.color.withOpacity(0.15)
                      : isDark ? Colors.white10 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? card.color : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Icon(Icons.check_circle, size: 16, color: card.color),
                      ),
                    Text(
                      card.name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? card.color
                            : isDark ? Colors.white70 : AppConstants.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
