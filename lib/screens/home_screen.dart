import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_constants.dart';
import '../models/restaurant.dart';
import '../providers/restaurant_provider.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/category_filter.dart';
import '../widgets/shimmer_loading.dart';
import '../services/places_service.dart';
import '../l10n/app_localizations.dart';
import 'restaurant_detail_screen.dart';
import 'compare_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _initialized = false;
  bool _showSearchHistory = false;
  bool _compareMode = false;
  final List<int> _selectedForCompare = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialized) {
        _initialized = true;
        context.read<RestaurantProvider>().loadWithCurrentLocation();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleCompareMode() {
    setState(() {
      _compareMode = !_compareMode;
      _selectedForCompare.clear();
    });
  }

  void _toggleCompareSelection(int index) {
    setState(() {
      if (_selectedForCompare.contains(index)) {
        _selectedForCompare.remove(index);
      } else if (_selectedForCompare.length < 3) {
        _selectedForCompare.add(index);
      }
    });
  }

  void _openCompare(List<Restaurant> restaurants) {
    if (_selectedForCompare.length < 2) return;
    final selected = _selectedForCompare.map((i) => restaurants[i]).toList();
    final provider = context.read<RestaurantProvider>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CompareScreen(
          restaurants: selected,
          userLat: provider.currentLat,
          userLng: provider.currentLng,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<RestaurantProvider>();
    final l = AppLocalizations(provider.currentLanguage);

    return SafeArea(
      child: Column(
        children: [
          _buildHeader(isDark, l),
          _buildSearchBar(isDark, l),
          if (_showSearchHistory) _buildSearchHistoryDropdown(isDark, l),
          const CategoryFilter(),
          _buildDietaryAndPriceFilter(isDark, l),
          _buildMealCardFilter(isDark, l),
          _buildSortBar(isDark, l),
          Expanded(child: _buildRestaurantList(isDark, l)),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark, AppLocalizations l) {
    return Consumer<RestaurantProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LezzetBul',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppConstants.textPrimary,
                      ),
                    ),
                    if (provider.currentCity.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 14, color: AppConstants.primaryColor),
                          const SizedBox(width: 4),
                          Text(
                            provider.currentCity,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.white60 : AppConstants.textSecondary,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              // Compare toggle
              IconButton(
                onPressed: _toggleCompareMode,
                icon: Icon(
                  _compareMode ? Icons.close : Icons.compare_arrows,
                  color: _compareMode
                      ? AppConstants.primaryColor
                      : isDark ? Colors.white70 : AppConstants.textSecondary,
                ),
                tooltip: 'Kar\u015f\u0131la\u015ft\u0131r',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(bool isDark, AppLocalizations l) {
    return Container(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: TextField(
        controller: _searchController,
        onTap: () => setState(() => _showSearchHistory = true),
        onSubmitted: (value) {
          setState(() => _showSearchHistory = false);
          if (value.trim().isNotEmpty) {
            context.read<RestaurantProvider>().searchByCity(value.trim());
          }
        },
        style: TextStyle(color: isDark ? Colors.white : AppConstants.textPrimary),
        decoration: InputDecoration(
          hintText: l.get('search_hint'),
          hintStyle: TextStyle(
              color: isDark ? Colors.white38 : AppConstants.textSecondary,
              fontSize: 14),
          prefixIcon: Icon(Icons.search,
              color: isDark ? Colors.white38 : AppConstants.textSecondary),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.clear, size: 20,
                      color: isDark ? Colors.white38 : AppConstants.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _showSearchHistory = false);
                  },
                ),
              IconButton(
                icon: const Icon(Icons.my_location, color: AppConstants.primaryColor),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _showSearchHistory = false);
                  context.read<RestaurantProvider>().loadWithCurrentLocation();
                },
                tooltip: l.get('use_my_location'),
              ),
            ],
          ),
          filled: true,
          fillColor: isDark ? Colors.white10 : AppConstants.backgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSearchHistoryDropdown(bool isDark, AppLocalizations l) {
    return Consumer<RestaurantProvider>(
      builder: (context, provider, _) {
        if (provider.searchHistory.isEmpty) return const SizedBox.shrink();
        return Container(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(l.get('recent_searches'),
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white60 : AppConstants.textSecondary)),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        provider.clearSearchHistory();
                        setState(() => _showSearchHistory = false);
                      },
                      child: Text(l.get('clear'),
                          style: const TextStyle(fontSize: 12, color: AppConstants.primaryColor)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.searchHistory.length,
                  itemBuilder: (context, index) {
                    final query = provider.searchHistory[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(query, style: const TextStyle(fontSize: 12)),
                        avatar: const Icon(Icons.history, size: 16),
                        onPressed: () {
                          _searchController.text = query;
                          setState(() => _showSearchHistory = false);
                          provider.searchByCity(query);
                        },
                        backgroundColor: isDark ? Colors.white10 : AppConstants.backgroundColor,
                        side: BorderSide.none,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDietaryAndPriceFilter(bool isDark, AppLocalizations l) {
    return Consumer<RestaurantProvider>(
      builder: (context, provider, _) {
        return SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              // Dietary filters
              ...dietaryFilters.map((diet) {
                final isSelected = provider.dietaryFilters.contains(diet.id);
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(diet.icon, size: 14,
                            color: isSelected ? diet.color : isDark ? Colors.white60 : AppConstants.textSecondary),
                        const SizedBox(width: 4),
                        Text(l.get(diet.nameKey), style: const TextStyle(fontSize: 11)),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (_) => provider.toggleDietaryFilter(diet.id),
                    selectedColor: diet.color.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? diet.color : isDark ? Colors.white60 : AppConstants.textSecondary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                    checkmarkColor: diet.color,
                    side: BorderSide(
                      color: isSelected ? diet.color : isDark ? Colors.white24 : Colors.grey.shade300,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                );
              }),
              // Price filter
              const SizedBox(width: 8),
              ...List.generate(3, (i) {
                final level = i + 1;
                final label = List.filled(level, '\u20BA').join();
                final isSelected = provider.priceFilter == level;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(label, style: const TextStyle(fontSize: 12)),
                    selected: isSelected,
                    onSelected: (_) => provider.setPriceFilter(isSelected ? null : level),
                    selectedColor: AppConstants.primaryColor.withOpacity(0.15),
                    labelStyle: TextStyle(
                      color: isSelected ? AppConstants.primaryColor : isDark ? Colors.white60 : AppConstants.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                    checkmarkColor: AppConstants.primaryColor,
                    side: BorderSide(
                      color: isSelected ? AppConstants.primaryColor : isDark ? Colors.white24 : Colors.grey.shade300,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMealCardFilter(bool isDark, AppLocalizations l) {
    return Consumer<RestaurantProvider>(
      builder: (context, provider, _) {
        return SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              // "All" chip to clear filter
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.credit_card, size: 14,
                          color: provider.mealCardFilter == null
                              ? Colors.white
                              : isDark ? Colors.white60 : AppConstants.textSecondary),
                      const SizedBox(width: 4),
                      Text(l.get('meal_cards_all'), style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                  selected: provider.mealCardFilter == null,
                  onSelected: (_) => provider.setMealCardFilter(null),
                  selectedColor: AppConstants.primaryColor,
                  labelStyle: TextStyle(
                    color: provider.mealCardFilter == null ? Colors.white : null,
                  ),
                  checkmarkColor: Colors.white,
                  side: BorderSide.none,
                  visualDensity: VisualDensity.compact,
                ),
              ),
              ...mealCardTypes.map((card) {
                final isSelected = provider.mealCardFilter == card.id;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(card.name, style: const TextStyle(fontSize: 11)),
                    selected: isSelected,
                    onSelected: (_) => provider.setMealCardFilter(isSelected ? null : card.id),
                    selectedColor: card.color.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? card.color : isDark ? Colors.white60 : AppConstants.textSecondary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                    checkmarkColor: card.color,
                    side: BorderSide(
                      color: isSelected ? card.color : isDark ? Colors.white24 : Colors.grey.shade300,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortBar(bool isDark, AppLocalizations l) {
    return Consumer<RestaurantProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              Text(
                '${provider.restaurants.length} ${l.get('restaurants_found')}',
                style: TextStyle(fontSize: 13,
                  color: isDark ? Colors.white60 : AppConstants.textSecondary,
                  fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              FilterChip(
                label: Text(l.get('open_filter'), style: const TextStyle(fontSize: 12)),
                selected: provider.showOnlyOpen,
                onSelected: (_) => provider.toggleShowOnlyOpen(),
                selectedColor: AppConstants.primaryColor.withOpacity(0.15),
                checkmarkColor: AppConstants.primaryColor,
                side: BorderSide(
                  color: provider.showOnlyOpen
                      ? AppConstants.primaryColor
                      : isDark ? Colors.white24 : Colors.grey.shade300),
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: 8),
              PopupMenuButton<int>(
                onSelected: (radius) => provider.setRadius(radius),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 1000, child: Text('1 km')),
                  PopupMenuItem(value: 3000, child: Text('3 km')),
                  PopupMenuItem(value: 5000, child: Text('5 km')),
                  PopupMenuItem(value: 10000, child: Text('10 km')),
                  PopupMenuItem(value: 20000, child: Text('20 km')),
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: isDark ? Colors.white24 : Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.radar, size: 14,
                          color: isDark ? Colors.white60 : AppConstants.textSecondary),
                      const SizedBox(width: 4),
                      Text(_radiusLabel(provider.selectedRadius),
                          style: TextStyle(fontSize: 12,
                              color: isDark ? Colors.white60 : AppConstants.textSecondary)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<SortType>(
                onSelected: provider.setSortType,
                itemBuilder: (_) => [
                  PopupMenuItem(value: SortType.recommended, child: Text(l.get('sort_recommended'))),
                  PopupMenuItem(value: SortType.rating, child: Text(l.get('sort_highest_rating'))),
                  PopupMenuItem(value: SortType.distance, child: Text(l.get('sort_nearest'))),
                  PopupMenuItem(value: SortType.ratingCount, child: Text(l.get('sort_most_reviewed'))),
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: isDark ? Colors.white24 : Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.sort, size: 14,
                          color: isDark ? Colors.white60 : AppConstants.textSecondary),
                      const SizedBox(width: 4),
                      Text(_sortLabel(provider.sortType, l),
                          style: TextStyle(fontSize: 12,
                              color: isDark ? Colors.white60 : AppConstants.textSecondary)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _sortLabel(SortType type, AppLocalizations l) {
    switch (type) {
      case SortType.rating: return l.get('sort_rating');
      case SortType.distance: return l.get('sort_distance');
      case SortType.ratingCount: return l.get('sort_popular');
      case SortType.recommended: return l.get('sort_recommended');
    }
  }

  String _radiusLabel(int radius) {
    if (radius >= 1000) return '${radius ~/ 1000} km';
    return '$radius m';
  }

  Widget _buildRestaurantList(bool isDark, AppLocalizations l) {
    return Consumer<RestaurantProvider>(
      builder: (context, provider, _) {
        // Shimmer loading
        if (provider.isLoading) {
          return const ShimmerRestaurantList();
        }

        if (provider.error != null) {
          return RefreshIndicator(
            color: AppConstants.primaryColor,
            onRefresh: () async {
              if (provider.currentCity.isNotEmpty) {
                await provider.searchByCity(provider.currentCity);
              } else {
                await provider.loadWithCurrentLocation();
              }
            },
            child: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 64, color: AppConstants.textSecondary),
                          const SizedBox(height: 16),
                          Text(l.get(provider.error!), textAlign: TextAlign.center,
                              style: const TextStyle(color: AppConstants.textSecondary)),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => provider.loadWithCurrentLocation(),
                            icon: const Icon(Icons.refresh),
                            label: Text(l.get('retry')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppConstants.primaryColor,
                              foregroundColor: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (provider.restaurants.isEmpty) {
          return RefreshIndicator(
            color: AppConstants.primaryColor,
            onRefresh: () async {
              if (provider.currentCity.isNotEmpty) {
                await provider.searchByCity(provider.currentCity);
              } else {
                await provider.loadWithCurrentLocation();
              }
            },
            child: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 64, color: AppConstants.textSecondary),
                        const SizedBox(height: 16),
                        Text(l.get('no_restaurants_found'),
                            style: const TextStyle(color: AppConstants.textSecondary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Compare mode floating button
        return Stack(
          children: [
            RefreshIndicator(
              color: AppConstants.primaryColor,
              onRefresh: () async {
                if (provider.currentCity.isNotEmpty) {
                  await provider.searchByCity(provider.currentCity);
                } else {
                  await provider.loadWithCurrentLocation();
                }
              },
              child: CustomScrollView(
                slivers: [
                  // Recently viewed section
                  if (provider.recentlyViewed.isNotEmpty && !_compareMode)
                    SliverToBoxAdapter(
                      child: _buildRecentlyViewed(provider, isDark, l),
                    ),
                  // Restaurant list
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final restaurant = provider.restaurants[index];
                          final isSelected = _selectedForCompare.contains(index);

                          if (_compareMode) {
                            return GestureDetector(
                              onTap: () => _toggleCompareSelection(index),
                              child: Stack(
                                children: [
                                  Opacity(
                                    opacity: isSelected ? 1 : 0.7,
                                    child: RestaurantCard(
                                      restaurant: restaurant,
                                      userLat: provider.currentLat,
                                      userLng: provider.currentLng,
                                      onTap: () => _toggleCompareSelection(index),
                                    ),
                                  ),
                                  if (isSelected)
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        width: 32, height: 32,
                                        decoration: const BoxDecoration(
                                          color: AppConstants.primaryColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${_selectedForCompare.indexOf(index) + 1}',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }

                          return RestaurantCard(
                            restaurant: restaurant,
                            userLat: provider.currentLat,
                            userLng: provider.currentLng,
                            onTap: () {
                              provider.addToRecentlyViewed(restaurant);
                              Navigator.push(context,
                                MaterialPageRoute(
                                  builder: (_) => RestaurantDetailScreen(
                                      placeId: restaurant.placeId)));
                            },
                          );
                        },
                        childCount: provider.restaurants.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Compare FAB
            if (_compareMode && _selectedForCompare.length >= 2)
              Positioned(
                bottom: 16,
                left: 20,
                right: 20,
                child: ElevatedButton.icon(
                  onPressed: () => _openCompare(provider.restaurants),
                  icon: const Icon(Icons.compare_arrows),
                  label: Text(
                      'Kar\u015f\u0131la\u015ft\u0131r (${_selectedForCompare.length})',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildRecentlyViewed(RestaurantProvider provider, bool isDark, AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Text(
            l.get('recently_viewed'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppConstants.textPrimary,
            ),
          ),
        ),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: provider.recentlyViewed.length,
            itemBuilder: (context, index) {
              final r = provider.recentlyViewed[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(context,
                    MaterialPageRoute(
                      builder: (_) => RestaurantDetailScreen(placeId: r.placeId)));
                },
                child: Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                        child: SizedBox(
                          height: 60,
                          width: 160,
                          child: r.photoReferences.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: PlacesService.getPhotoUrl(
                                      r.photoReferences.first, maxWidth: 200),
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => Container(
                                    color: AppConstants.primaryColor.withOpacity(0.1),
                                    child: const Icon(Icons.restaurant, size: 24,
                                        color: AppConstants.primaryColor),
                                  ),
                                )
                              : Container(
                                  color: AppConstants.primaryColor.withOpacity(0.1),
                                  child: const Icon(Icons.restaurant, size: 24,
                                      color: AppConstants.primaryColor),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.name,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white : AppConstants.textPrimary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            Row(
                              children: [
                                const Icon(Icons.star, size: 12, color: AppConstants.starColor),
                                const SizedBox(width: 2),
                                Text(r.rating?.toStringAsFixed(1) ?? '-',
                                    style: TextStyle(fontSize: 11,
                                        color: isDark ? Colors.white60 : AppConstants.textSecondary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
