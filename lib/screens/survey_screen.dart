import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/restaurant_provider.dart';
import '../services/recommendation_service.dart';
import '../widgets/restaurant_card.dart';
import '../l10n/app_localizations.dart';
import 'restaurant_detail_screen.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 5;

  int _selectedCategoryIndex = -1;
  DiningMood _selectedMood = DiningMood.none;
  double _minRating = 0;
  double _maxDistance = 5000;
  int _maxPriceLevel = 0;
  bool _onlyOpen = true;
  bool _showResults = false;

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      setState(() => _showResults = true);
      _runSurvey();
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _runSurvey() {
    final category = _selectedCategoryIndex >= 0
        ? foodCategories[_selectedCategoryIndex].keyword
        : '';
    final survey = SurveyResult(
      category: category,
      mood: _selectedMood,
      minRating: _minRating,
      maxDistance: _maxDistance,
      maxPriceLevel: _maxPriceLevel,
      onlyOpen: _onlyOpen,
    );
    final provider = context.read<RestaurantProvider>();
    if (_selectedCategoryIndex >= 0) {
      provider.selectCategory(_selectedCategoryIndex);
    }
    provider.applySurvey(survey);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<RestaurantProvider>();
    final l = AppLocalizations(provider.currentLanguage);

    if (_showResults) return _buildResults(isDark, l);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
      appBar: AppBar(
        title: Text(l.get('survey_title')),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: List.generate(_totalPages, (i) {
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: i <= _currentPage
                          ? AppConstants.primaryColor
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (page) => setState(() => _currentPage = page),
              children: [
                _buildCategoryPage(isDark, l, provider.currentLanguage),
                _buildMoodPage(isDark, l),
                _buildRatingPage(isDark, l),
                _buildDistancePage(isDark, l),
                _buildPricePage(isDark, l),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                if (_currentPage > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _prevPage,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppConstants.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(l.get('survey_back')),
                    ),
                  ),
                if (_currentPage > 0) const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _currentPage < _totalPages - 1
                          ? l.get('survey_continue')
                          : l.get('survey_see_results'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionTitle(String title, String subtitle, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppConstants.textPrimary,
              )),
          const SizedBox(height: 8),
          Text(subtitle,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : AppConstants.textSecondary,
              )),
        ],
      ),
    );
  }

  Widget _buildCategoryPage(bool isDark, AppLocalizations l, String lang) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionTitle(l.get('q_what_to_eat'), l.get('q_what_to_eat_sub'), isDark),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(foodCategories.length, (i) {
                final cat = foodCategories[i];
                final isSelected = _selectedCategoryIndex == i;
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedCategoryIndex = isSelected ? -1 : i;
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppConstants.primaryColor
                          : isDark ? Colors.white10 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppConstants.primaryColor : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(cat.icon, size: 22,
                            color: isSelected ? Colors.white : isDark ? Colors.white70 : AppConstants.textSecondary),
                        const SizedBox(width: 8),
                        Text(cat.getName(lang),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : isDark ? Colors.white : AppConstants.textPrimary,
                            )),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodPage(bool isDark, AppLocalizations l) {
    final moods = [
      _MoodOption(DiningMood.quickBite, Icons.bolt, l.get('mood_quick'), l.get('mood_quick_sub')),
      _MoodOption(DiningMood.specialOccasion, Icons.celebration, l.get('mood_special'), l.get('mood_special_sub')),
      _MoodOption(DiningMood.explore, Icons.explore, l.get('mood_explore'), l.get('mood_explore_sub')),
      _MoodOption(DiningMood.popular, Icons.trending_up, l.get('mood_popular'), l.get('mood_popular_sub')),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionTitle(l.get('q_mood'), l.get('q_mood_sub'), isDark),
        ...moods.map((mood) {
          final isSelected = _selectedMood == mood.mood;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
            child: GestureDetector(
              onTap: () => setState(() => _selectedMood = mood.mood),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppConstants.primaryColor.withOpacity(0.1)
                      : isDark ? Colors.white10 : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppConstants.primaryColor : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppConstants.primaryColor
                            : isDark ? Colors.white10 : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(mood.icon,
                          color: isSelected ? Colors.white : isDark ? Colors.white70 : AppConstants.textSecondary,
                          size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(mood.title,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : AppConstants.textPrimary)),
                          Text(mood.subtitle,
                              style: TextStyle(fontSize: 13,
                                color: isDark ? Colors.white60 : AppConstants.textSecondary)),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle, color: AppConstants.primaryColor, size: 24),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRatingPage(bool isDark, AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionTitle(l.get('q_min_rating'), l.get('q_min_rating_sub'), isDark),
        const SizedBox(height: 32),
        Center(
          child: Text(
            _minRating == 0 ? l.get('doesnt_matter') : _minRating.toStringAsFixed(1),
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w700, color: AppConstants.primaryColor),
          ),
        ),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (i) => Icon(
              i < _minRating.ceil() ? Icons.star : Icons.star_border,
              color: AppConstants.starColor, size: 32,
            )),
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Slider(
            value: _minRating, min: 0, max: 5, divisions: 10,
            activeColor: AppConstants.primaryColor,
            onChanged: (v) => setState(() => _minRating = v),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l.get('doesnt_matter'),
                  style: TextStyle(color: isDark ? Colors.white60 : AppConstants.textSecondary, fontSize: 12)),
              const Text('5.0', style: TextStyle(color: AppConstants.textSecondary, fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SwitchListTile(
            title: Text(l.get('only_open_places'),
                style: TextStyle(color: isDark ? Colors.white : AppConstants.textPrimary)),
            subtitle: Text(l.get('hide_closed'),
                style: TextStyle(color: isDark ? Colors.white60 : AppConstants.textSecondary, fontSize: 12)),
            value: _onlyOpen,
            activeColor: AppConstants.primaryColor,
            onChanged: (v) => setState(() => _onlyOpen = v),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildDistancePage(bool isDark, AppLocalizations l) {
    final distText = _maxDistance >= 10000
        ? '${(_maxDistance / 1000).toInt()} km'
        : _maxDistance >= 1000
            ? '${(_maxDistance / 1000).toStringAsFixed(1)} km'
            : '${_maxDistance.toInt()} m';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionTitle(l.get('q_distance'), l.get('q_distance_sub'), isDark),
        const SizedBox(height: 32),
        Center(
          child: Text(distText,
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w700, color: AppConstants.primaryColor)),
        ),
        Center(child: Icon(Icons.directions_walk, size: 48, color: isDark ? Colors.white30 : Colors.grey.shade300)),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Slider(
            value: _maxDistance, min: 500, max: 20000, divisions: 39,
            activeColor: AppConstants.primaryColor,
            onChanged: (v) => setState(() => _maxDistance = v),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('500 m', style: TextStyle(color: isDark ? Colors.white60 : AppConstants.textSecondary, fontSize: 12)),
              Text('20 km', style: TextStyle(color: isDark ? Colors.white60 : AppConstants.textSecondary, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPricePage(bool isDark, AppLocalizations l) {
    final prices = [
      _PriceOption(0, l.get('doesnt_matter'), l.get('doesnt_matter')),
      _PriceOption(1, '\u20BA', l.get('price_cheap')),
      _PriceOption(2, '\u20BA\u20BA', l.get('price_medium')),
      _PriceOption(3, '\u20BA\u20BA\u20BA', l.get('price_expensive')),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionTitle(l.get('q_budget'), l.get('q_budget_sub'), isDark),
        ...prices.map((p) {
          final isSelected = _maxPriceLevel == p.level;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
            child: GestureDetector(
              onTap: () => setState(() => _maxPriceLevel = p.level),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppConstants.primaryColor.withOpacity(0.1)
                      : isDark ? Colors.white10 : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppConstants.primaryColor : Colors.transparent, width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Text(p.label, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,
                        color: isSelected ? AppConstants.primaryColor : isDark ? Colors.white70 : AppConstants.textSecondary)),
                    const SizedBox(width: 16),
                    Expanded(child: Text(p.subtitle, style: TextStyle(fontSize: 14,
                        color: isDark ? Colors.white : AppConstants.textPrimary))),
                    if (isSelected) const Icon(Icons.check_circle, color: AppConstants.primaryColor),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildResults(bool isDark, AppLocalizations l) {
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A2E) : AppConstants.backgroundColor,
      appBar: AppBar(
        title: Text(l.get('survey_results_title')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() {
            _showResults = false;
            _currentPage = 0;
            _pageController.jumpToPage(0);
          }),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _showResults = false;
                _currentPage = 0;
                _selectedCategoryIndex = -1;
                _selectedMood = DiningMood.none;
                _minRating = 0;
                _maxDistance = 5000;
                _maxPriceLevel = 0;
                _onlyOpen = true;
                _pageController.jumpToPage(0);
              });
            },
            child: Text(l.get('survey_restart'),
                style: const TextStyle(color: AppConstants.primaryColor)),
          ),
        ],
      ),
      body: Consumer<RestaurantProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: AppConstants.primaryColor));
          }

          final restaurants = provider.surveyResults;
          if (restaurants.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sentiment_dissatisfied, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(l.get('survey_no_results'),
                      style: const TextStyle(fontSize: 16, color: AppConstants.textSecondary)),
                  const SizedBox(height: 8),
                  Text(l.get('survey_expand_filters'),
                      style: const TextStyle(fontSize: 13, color: AppConstants.textSecondary)),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text('${restaurants.length} ${l.get('places_found')}',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : AppConstants.textSecondary)),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = restaurants[index];
                    return RestaurantCard(
                      restaurant: restaurant,
                      userLat: provider.currentLat,
                      userLng: provider.currentLng,
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (_) => RestaurantDetailScreen(placeId: restaurant.placeId)));
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MoodOption {
  final DiningMood mood;
  final IconData icon;
  final String title;
  final String subtitle;
  _MoodOption(this.mood, this.icon, this.title, this.subtitle);
}

class _PriceOption {
  final int level;
  final String label;
  final String subtitle;
  _PriceOption(this.level, this.label, this.subtitle);
}
