class AppLocalizations {
  final String languageCode;

  AppLocalizations(this.languageCode);

  static final Map<String, Map<String, String>> _localizedValues = {
    'tr': {
      // General
      'app_name': 'LezzetBul',
      'loading': 'Y\u00fckleniyor...',
      'error': 'Hata',
      'retry': 'Tekrar Dene',
      'cancel': '\u0130ptal',
      'save': 'Kaydet',
      'delete': 'Sil',
      'close': 'Kapat',
      'search': 'Ara',
      'share': 'Payla\u015f',
      'settings': 'Ayarlar',

      // Navigation
      'nav_explore': 'Ke\u015ffet',
      'nav_survey': 'Anket',
      'nav_map': 'Harita',
      'nav_favorites': 'Favoriler',
      'nav_profile': 'Profil',

      // Home
      'search_hint': '\u015eehir veya il\u00e7e ara... (\u00f6rn: Kocaeli)',
      'use_my_location': 'Konumumu kullan',
      'restaurants_found': 'restoran',
      'searching_restaurants': 'Restoranlar aran\u0131yor...',
      'no_restaurants_found': 'Bu b\u00f6lge i\u00e7in restoran bulunamad\u0131.',
      'restaurants_load_error': 'Restoranlar y\u00fcklenemedi. L\u00fctfen bir \u015fehir ad\u0131 aray\u0131n\u0131z.',
      'open_now': 'A\u00e7\u0131k',
      'closed': 'Kapal\u0131',
      'open_filter': 'A\u00e7\u0131k',
      'recent_searches': 'Son Aramalar',
      'clear': 'Temizle',

      // Sort
      'sort_recommended': '\u00d6nerilen',
      'sort_rating': 'Puan',
      'sort_distance': 'Mesafe',
      'sort_popular': 'Pop\u00fcler',
      'sort_highest_rating': 'En y\u00fcksek puan',
      'sort_nearest': 'En yak\u0131n',
      'sort_most_reviewed': 'En \u00e7ok de\u011ferlendirilen',

      // Categories
      'cat_all': 'T\u00fcm\u00fc',
      'cat_hamburger': 'Hamburger',
      'cat_kebab': 'Kebap',
      'cat_pizza': 'Pizza',
      'cat_dessert': 'Tatl\u0131',
      'cat_cafe': 'Cafe',
      'cat_fish': 'Bal\u0131k',
      'cat_doner': 'D\u00f6ner',
      'cat_pide': 'Pide & Lahmacun',
      'cat_breakfast': 'Kahvalt\u0131',
      'cat_cigkofte': '\u00c7i\u011f K\u00f6fte',
      'cat_chicken': 'Tavuk',

      // Restaurant Detail
      'reviews': 'de\u011ferlendirme',
      'reviews_title': 'Yorumlar',
      'directions': 'Yol Tarifi',
      'call': 'Ara',
      'website': 'Web',
      'working_hours': '\u00c7al\u0131\u015fma Saatleri',
      'now_open': '\u015eimdi A\u00e7\u0131k',
      'now_closed': '\u015eimdi Kapal\u0131',
      'restaurant_not_found': 'Restoran bilgisi bulunamad\u0131',
      'shared_via': 'LezzetBul uygulamas\u0131yla bulundu!',

      // Favorites
      'my_favorites': 'Favorilerim',
      'no_favorites': 'Hen\u00fcz favori restoran\u0131n\u0131z yok',
      'add_favorites_hint': 'Be\u011fendi\u011finiz restoranlar\u0131 favorilere ekleyin',
      'favorites_persist': 'Favoriler uygulama kapansa bile kaybolmaz!',
      'favorite_places': 'favori mekan',

      // Map
      'map_title': 'Harita',
      'your_location': 'Konumunuz',

      // Survey
      'survey_title': 'Sana \u00d6zel \u00d6neri',
      'survey_results_title': 'Sana \u00d6zel \u00d6neriler',
      'survey_continue': 'Devam',
      'survey_back': 'Geri',
      'survey_see_results': 'Sonu\u00e7lar\u0131 G\u00f6r',
      'survey_restart': 'Yeniden Ba\u015fla',
      'survey_no_results': 'Kriterlerine uygun mekan bulunamad\u0131',
      'survey_expand_filters': 'Filtreleri geni\u015fletmeyi dene',
      'places_found': 'mekan bulundu',

      // Survey Questions
      'q_what_to_eat': 'Ne yemek istiyorsun?',
      'q_what_to_eat_sub': 'Bir kategori se\u00e7 veya atla',
      'q_mood': 'Modun nas\u0131l?',
      'q_mood_sub': 'Yemek amac\u0131n\u0131 se\u00e7',
      'q_min_rating': 'Minimum puan ka\u00e7 olsun?',
      'q_min_rating_sub': 'Bu puan\u0131n alt\u0131ndaki mekanlar g\u00f6sterilmez',
      'q_distance': 'Ne kadar uzaa gidebilirsin?',
      'q_distance_sub': 'Maksimum mesafe',
      'q_budget': 'B\u00fct\u00e7en nas\u0131l?',
      'q_budget_sub': 'Fiyat aral\u0131\u011f\u0131n\u0131 se\u00e7',
      'doesnt_matter': 'Farketmez',
      'only_open_places': 'Sadece a\u00e7\u0131k mekanlar',
      'hide_closed': 'Kapal\u0131 olanlar\u0131 g\u00f6sterme',

      // Moods
      'mood_quick': 'H\u0131zl\u0131 At\u0131\u015ft\u0131rma',
      'mood_quick_sub': 'Yak\u0131n ve h\u0131zl\u0131 bir \u015fey',
      'mood_special': '\u00d6zel G\u00fcn',
      'mood_special_sub': 'En iyi puanl\u0131 mekanlar',
      'mood_explore': 'Ke\u015ffet',
      'mood_explore_sub': 'Yeni yerler denemek istiyorum',
      'mood_popular': 'Pop\u00fcler',
      'mood_popular_sub': 'En \u00e7ok gidilen mekanlar',

      // Price
      'price_cheap': 'Ucuz / Ekonomik',
      'price_medium': 'Orta fiyat',
      'price_expensive': 'Pahal\u0131 / L\u00fcks',

      // Profile
      'profile_title': 'Profil',
      'dark_mode': 'Koyu Tema',
      'language': 'Dil',
      'turkish': 'T\u00fcrk\u00e7e',
      'english': 'English',
      'arabic': '\u0627\u0644\u0639\u0631\u0628\u064a\u0629',
      'visit_history': 'Ziyaret Ge\u00e7mi\u015fi',
      'app_info': 'Uygulama Hakk\u0131nda',
      'version': 'S\u00fcr\u00fcm',
      'rate_app': 'Uygulamay\u0131 De\u011ferlendir',
      'clear_search_history': 'Arama Ge\u00e7mi\u015fini Temizle',
      'search_history_cleared': 'Arama ge\u00e7mi\u015fi temizlendi',
      'total_visits': 'Toplam Ziyaret',
      'favorite_category': 'En Sevdi\u011fin Kategori',
      'member_since': '\u00dcye Olma Tarihi',
      'statistics': '\u0130statistikler',
      'preferences': 'Tercihler',
      'location_default': 'Varsay\u0131lan \u015eehir: \u0130stanbul',

      // Onboarding
      'onboarding_skip': 'Atla',
      'onboarding_next': 'Devam',
      'onboarding_start': 'Ba\u015fla!',
      'onboarding_title_1': 'Konumunu Belirle',
      'onboarding_desc_1': 'GPS ile otomatik konum al veya istedi\u011fin \u015fehri ara. T\u00fcrkiye\'nin her yerinde \u00e7al\u0131\u015f\u0131r!',
      'onboarding_title_2': 'En \u0130yi Mekanlar\u0131 Bul',
      'onboarding_desc_2': 'Hamburger, kebap, pizza, tatl\u0131... Kategoriye g\u00f6re filtrele, puan ve mesafeye g\u00f6re s\u0131rala.',
      'onboarding_title_3': 'Sana \u00d6zel \u00d6neriler',
      'onboarding_desc_3': 'Anket modunu kullan, modunu ve b\u00fct\u00e7eni se\u00e7, sana \u00f6zel restoran \u00f6nerilerini g\u00f6r!',

      // Compare
      'compare': 'Kar\u015f\u0131la\u015ft\u0131r',
      'compare_rating': 'Puan',
      'compare_reviews': 'Yorum',
      'compare_price': 'Fiyat',
      'compare_distance': 'Mesafe',
      'compare_status': 'Durum',

      // Recently viewed
      'recently_viewed': 'Son G\u00f6r\u00fcnt\u00fclenen',

      // Card
      'review_count': 'yorum',

      // Meal Cards
      'meal_cards_title': 'Yemek Kartlar\u0131',
      'meal_cards_hint': 'Bu restoranda ge\u00e7en kartlar\u0131 i\u015faretleyin',
      'meal_cards_all': 'T\u00fcm Kartlar',

      // Dietary
      'diet_halal': 'Helal',
      'diet_vegetarian': 'Vejetaryen',
      'diet_vegan': 'Vegan',
      'diet_gluten_free': 'Gl\u00fctensiz',

      // Auth & Friends (localized)
      'auth_login': 'Giri\u015f Yap',
      'auth_register': 'Kay\u0131t Ol',
      'auth_email': 'E-posta',
      'auth_password': '\u015eifre',
      'auth_password_confirm': '\u015eifre Tekrar',
      'auth_name': 'Ad Soyad',
      'auth_email_required': 'E-posta giriniz',
      'auth_email_invalid': 'Ge\u00e7erli bir e-posta giriniz',
      'auth_password_required': '\u015eifre giriniz',
      'auth_password_short': '\u015eifre en az 4 karakter olmal\u0131',
      'auth_password_confirm_required': '\u015eifreyi tekrar giriniz',
      'auth_password_mismatch': '\u015eifreler e\u015fle\u015fmiyor',
      'auth_name_required': 'Ad\u0131n\u0131z\u0131 giriniz',
      'auth_login_error': 'E-posta veya \u015fifre hatal\u0131',
      'auth_register_error': 'Bu e-posta adresi zaten kay\u0131tl\u0131',
      'auth_logout': '\u00c7\u0131k\u0131\u015f Yap',
      'friends_title': 'Arkada\u015flar\u0131m',
      'friends_add': 'Arkada\u015f Ekle',
      'friends_remove': 'Arkada\u015f\u0131 Kald\u0131r',
      'friends_remove_confirm': 'arkada\u015f listenizden kald\u0131r\u0131lacak.',
      'friends_empty': 'Hen\u00fcz arkada\u015f eklemediniz',
      'friends_empty_hint': 'Arkada\u015flar\u0131n\u0131z\u0131 ekleyip birlikte lezzetleri ke\u015ffedin!',
      'friends_label': 'Arkada\u015f',
      'friends_add_btn': 'Ekle',
      'friends_remove_btn': 'Kald\u0131r',
      'share_restaurant': 'Restoran Payla\u015f',

      // Help
      'help_title': 'Yard\u0131m & SSS',
      'help_q1': 'LezzetBul nas\u0131l \u00e7al\u0131\u015f\u0131r?',
      'help_a1': 'Konumunuzu belirleyin veya bir \u015fehir aray\u0131n. Yak\u0131n\u0131n\u0131zdaki restoranlar otomatik olarak listelenir. Kategoriye g\u00f6re filtrele, puanla s\u0131rala!',
      'help_q2': 'Yemek kart\u0131 bilgisi nas\u0131l eklenir?',
      'help_a2': 'Restoran detay sayfas\u0131nda "Yemek Kartlar\u0131" b\u00f6l\u00fcm\u00fcne gidin ve ge\u00e7en kartlar\u0131 i\u015faretleyin. Di\u011fer kullan\u0131c\u0131lar da bu bilgiyi g\u00f6rebilir.',
      'help_q3': 'Favoriler kaybolur mu?',
      'help_a3': 'Hay\u0131r! Favorileriniz cihaz\u0131n\u0131zda g\u00fcvenle saklan\u0131r ve uygulama kapansa bile kaybolmaz.',
      'help_q4': 'Anket modu ne i\u015fe yarar?',
      'help_a4': 'Modunuzu, b\u00fct\u00e7enizi ve tercihlerinizi se\u00e7erek size \u00f6zel restoran \u00f6nerileri al\u0131rs\u0131n\u0131z.',
      'help_q5': 'Uygulama \u00fccretli mi?',
      'help_a5': 'Hay\u0131r, LezzetBul tamamen \u00fccretsizdir.',
    },
    'en': {
      // General
      'app_name': 'LezzetBul',
      'loading': 'Loading...',
      'error': 'Error',
      'retry': 'Retry',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'close': 'Close',
      'search': 'Search',
      'share': 'Share',
      'settings': 'Settings',

      // Navigation
      'nav_explore': 'Explore',
      'nav_survey': 'Survey',
      'nav_map': 'Map',
      'nav_favorites': 'Favorites',
      'nav_profile': 'Profile',

      // Home
      'search_hint': 'Search city or district... (e.g. Istanbul)',
      'use_my_location': 'Use my location',
      'restaurants_found': 'restaurants',
      'searching_restaurants': 'Searching restaurants...',
      'no_restaurants_found': 'No restaurants found in this area.',
      'restaurants_load_error': 'Could not load restaurants. Please search for a city.',
      'open_now': 'Open',
      'closed': 'Closed',
      'open_filter': 'Open',
      'recent_searches': 'Recent Searches',
      'clear': 'Clear',

      // Sort
      'sort_recommended': 'Recommended',
      'sort_rating': 'Rating',
      'sort_distance': 'Distance',
      'sort_popular': 'Popular',
      'sort_highest_rating': 'Highest rating',
      'sort_nearest': 'Nearest',
      'sort_most_reviewed': 'Most reviewed',

      // Categories
      'cat_all': 'All',
      'cat_hamburger': 'Burger',
      'cat_kebab': 'Kebab',
      'cat_pizza': 'Pizza',
      'cat_dessert': 'Dessert',
      'cat_cafe': 'Cafe',
      'cat_fish': 'Fish',
      'cat_doner': 'Doner',
      'cat_pide': 'Pide & Lahmacun',
      'cat_breakfast': 'Breakfast',
      'cat_cigkofte': 'Cig Kofte',
      'cat_chicken': 'Chicken',

      // Restaurant Detail
      'reviews': 'reviews',
      'reviews_title': 'Reviews',
      'directions': 'Directions',
      'call': 'Call',
      'website': 'Web',
      'working_hours': 'Working Hours',
      'now_open': 'Open Now',
      'now_closed': 'Closed Now',
      'restaurant_not_found': 'Restaurant info not found',
      'shared_via': 'Found with LezzetBul app!',

      // Favorites
      'my_favorites': 'My Favorites',
      'no_favorites': 'No favorite restaurants yet',
      'add_favorites_hint': 'Add restaurants you like to favorites',
      'favorites_persist': 'Favorites are saved even when app is closed!',
      'favorite_places': 'favorite places',

      // Map
      'map_title': 'Map',
      'your_location': 'Your Location',

      // Survey
      'survey_title': 'Personalized Recommendation',
      'survey_results_title': 'Your Recommendations',
      'survey_continue': 'Continue',
      'survey_back': 'Back',
      'survey_see_results': 'See Results',
      'survey_restart': 'Start Over',
      'survey_no_results': 'No places match your criteria',
      'survey_expand_filters': 'Try expanding your filters',
      'places_found': 'places found',

      // Survey Questions
      'q_what_to_eat': 'What do you want to eat?',
      'q_what_to_eat_sub': 'Pick a category or skip',
      'q_mood': 'What\'s your mood?',
      'q_mood_sub': 'Choose your dining purpose',
      'q_min_rating': 'Minimum rating?',
      'q_min_rating_sub': 'Places below this rating won\'t be shown',
      'q_distance': 'How far can you go?',
      'q_distance_sub': 'Maximum distance',
      'q_budget': 'What\'s your budget?',
      'q_budget_sub': 'Choose a price range',
      'doesnt_matter': 'Any',
      'only_open_places': 'Only open places',
      'hide_closed': 'Don\'t show closed ones',

      // Moods
      'mood_quick': 'Quick Bite',
      'mood_quick_sub': 'Something nearby and fast',
      'mood_special': 'Special Occasion',
      'mood_special_sub': 'Best rated places',
      'mood_explore': 'Explore',
      'mood_explore_sub': 'I want to try new places',
      'mood_popular': 'Popular',
      'mood_popular_sub': 'Most visited places',

      // Price
      'price_cheap': 'Cheap / Budget',
      'price_medium': 'Mid-range',
      'price_expensive': 'Expensive / Luxury',

      // Profile
      'profile_title': 'Profile',
      'dark_mode': 'Dark Mode',
      'language': 'Language',
      'turkish': 'T\u00fcrk\u00e7e',
      'english': 'English',
      'arabic': '\u0627\u0644\u0639\u0631\u0628\u064a\u0629',
      'visit_history': 'Visit History',
      'app_info': 'About App',
      'version': 'Version',
      'rate_app': 'Rate App',
      'clear_search_history': 'Clear Search History',
      'search_history_cleared': 'Search history cleared',
      'total_visits': 'Total Visits',
      'favorite_category': 'Favorite Category',
      'member_since': 'Member Since',
      'statistics': 'Statistics',
      'preferences': 'Preferences',
      'location_default': 'Default City: Istanbul',

      // Onboarding
      'onboarding_skip': 'Skip',
      'onboarding_next': 'Next',
      'onboarding_start': 'Get Started!',
      'onboarding_title_1': 'Set Your Location',
      'onboarding_desc_1': 'Get automatic GPS location or search for any city. Works all across Turkey!',
      'onboarding_title_2': 'Find the Best Places',
      'onboarding_desc_2': 'Burger, kebab, pizza, desserts... Filter by category, sort by rating and distance.',
      'onboarding_title_3': 'Personalized Suggestions',
      'onboarding_desc_3': 'Use the survey mode, pick your mood and budget, see restaurant suggestions just for you!',

      // Compare
      'compare': 'Compare',
      'compare_rating': 'Rating',
      'compare_reviews': 'Reviews',
      'compare_price': 'Price',
      'compare_distance': 'Distance',
      'compare_status': 'Status',

      // Recently viewed
      'recently_viewed': 'Recently Viewed',

      // Card
      'review_count': 'reviews',

      // Meal Cards
      'meal_cards_title': 'Meal Cards',
      'meal_cards_hint': 'Mark cards accepted at this restaurant',
      'meal_cards_all': 'All Cards',

      // Dietary
      'diet_halal': 'Halal',
      'diet_vegetarian': 'Vegetarian',
      'diet_vegan': 'Vegan',
      'diet_gluten_free': 'Gluten Free',

      // Auth & Friends
      'auth_login': 'Login',
      'auth_register': 'Register',
      'auth_email': 'Email',
      'auth_password': 'Password',
      'auth_password_confirm': 'Confirm Password',
      'auth_name': 'Full Name',
      'auth_email_required': 'Enter your email',
      'auth_email_invalid': 'Enter a valid email',
      'auth_password_required': 'Enter your password',
      'auth_password_short': 'Password must be at least 4 characters',
      'auth_password_confirm_required': 'Confirm your password',
      'auth_password_mismatch': 'Passwords do not match',
      'auth_name_required': 'Enter your name',
      'auth_login_error': 'Invalid email or password',
      'auth_register_error': 'This email is already registered',
      'auth_logout': 'Logout',
      'friends_title': 'My Friends',
      'friends_add': 'Add Friend',
      'friends_remove': 'Remove Friend',
      'friends_remove_confirm': 'will be removed from your friends list.',
      'friends_empty': 'No friends added yet',
      'friends_empty_hint': 'Add friends and discover flavors together!',
      'friends_label': 'Friend',
      'friends_add_btn': 'Add',
      'friends_remove_btn': 'Remove',
      'share_restaurant': 'Share Restaurant',

      // Help
      'help_title': 'Help & FAQ',
      'help_q1': 'How does LezzetBul work?',
      'help_a1': 'Set your location or search a city. Nearby restaurants are listed automatically. Filter by category, sort by rating!',
      'help_q2': 'How to add meal card info?',
      'help_a2': 'Go to restaurant details, find the "Meal Cards" section and mark accepted cards. Other users can see this info too.',
      'help_q3': 'Will favorites be lost?',
      'help_a3': 'No! Favorites are safely stored on your device and persist even when the app is closed.',
      'help_q4': 'What is survey mode?',
      'help_a4': 'Choose your mood, budget and preferences to get personalized restaurant recommendations.',
      'help_q5': 'Is the app free?',
      'help_a5': 'Yes, LezzetBul is completely free.',
    },
    'ar': {
      // General
      'app_name': 'LezzetBul',
      'loading': '\u062c\u0627\u0631\u064a \u0627\u0644\u062a\u062d\u0645\u064a\u0644...',
      'error': '\u062e\u0637\u0623',
      'retry': '\u0623\u0639\u062f \u0627\u0644\u0645\u062d\u0627\u0648\u0644\u0629',
      'cancel': '\u0625\u0644\u063a\u0627\u0621',
      'save': '\u062d\u0641\u0638',
      'delete': '\u062d\u0630\u0641',
      'close': '\u0625\u063a\u0644\u0627\u0642',
      'search': '\u0628\u062d\u062b',
      'share': '\u0645\u0634\u0627\u0631\u0643\u0629',
      'settings': '\u0627\u0644\u0625\u0639\u062f\u0627\u062f\u0627\u062a',

      // Navigation
      'nav_explore': '\u0627\u0633\u062a\u0643\u0634\u0641',
      'nav_survey': '\u0627\u0633\u062a\u0628\u064a\u0627\u0646',
      'nav_map': '\u062e\u0631\u064a\u0637\u0629',
      'nav_favorites': '\u0627\u0644\u0645\u0641\u0636\u0644\u0629',
      'nav_profile': '\u0627\u0644\u0645\u0644\u0641 \u0627\u0644\u0634\u062e\u0635\u064a',

      // Home
      'search_hint': '\u0627\u0628\u062d\u062b \u0639\u0646 \u0645\u062f\u064a\u0646\u0629 \u0623\u0648 \u0645\u0646\u0637\u0642\u0629...',
      'use_my_location': '\u0627\u0633\u062a\u062e\u062f\u0645 \u0645\u0648\u0642\u0639\u064a',
      'restaurants_found': '\u0645\u0637\u0639\u0645',
      'searching_restaurants': '\u062c\u0627\u0631\u064a \u0627\u0644\u0628\u062d\u062b \u0639\u0646 \u0627\u0644\u0645\u0637\u0627\u0639\u0645...',
      'no_restaurants_found': '\u0644\u0645 \u064a\u062a\u0645 \u0627\u0644\u0639\u062b\u0648\u0631 \u0639\u0644\u0649 \u0645\u0637\u0627\u0639\u0645 \u0641\u064a \u0647\u0630\u0647 \u0627\u0644\u0645\u0646\u0637\u0642\u0629.',
      'restaurants_load_error': '\u062a\u0639\u0630\u0631 \u062a\u062d\u0645\u064a\u0644 \u0627\u0644\u0645\u0637\u0627\u0639\u0645. \u064a\u0631\u062c\u0649 \u0627\u0644\u0628\u062d\u062b \u0639\u0646 \u0645\u062f\u064a\u0646\u0629.',
      'open_now': '\u0645\u0641\u062a\u0648\u062d',
      'closed': '\u0645\u063a\u0644\u0642',
      'open_filter': '\u0645\u0641\u062a\u0648\u062d',
      'recent_searches': '\u0627\u0644\u0628\u062d\u062b \u0627\u0644\u0623\u062e\u064a\u0631',
      'clear': '\u0645\u0633\u062d',

      // Sort
      'sort_recommended': '\u0645\u0648\u0635\u0649 \u0628\u0647',
      'sort_rating': '\u0627\u0644\u062a\u0642\u064a\u064a\u0645',
      'sort_distance': '\u0627\u0644\u0645\u0633\u0627\u0641\u0629',
      'sort_popular': '\u0634\u0627\u0626\u0639',
      'sort_highest_rating': '\u0623\u0639\u0644\u0649 \u062a\u0642\u064a\u064a\u0645',
      'sort_nearest': '\u0627\u0644\u0623\u0642\u0631\u0628',
      'sort_most_reviewed': '\u0627\u0644\u0623\u0643\u062b\u0631 \u062a\u0642\u064a\u064a\u0645\u0627\u064b',

      // Categories
      'cat_all': '\u0627\u0644\u0643\u0644',
      'cat_hamburger': '\u0628\u0631\u063a\u0631',
      'cat_kebab': '\u0643\u0628\u0627\u0628',
      'cat_pizza': '\u0628\u064a\u062a\u0632\u0627',
      'cat_dessert': '\u062d\u0644\u0648\u064a\u0627\u062a',
      'cat_cafe': '\u0645\u0642\u0647\u0649',
      'cat_fish': '\u0633\u0645\u0643',
      'cat_doner': '\u062f\u0648\u0646\u0631',
      'cat_pide': '\u0628\u064a\u062f\u0629 \u0648\u0644\u062d\u0645 \u0628\u0639\u062c\u064a\u0646',
      'cat_breakfast': '\u0641\u0637\u0648\u0631',
      'cat_cigkofte': '\u0643\u0641\u062a\u0629 \u0646\u064a\u0626\u0629',
      'cat_chicken': '\u062f\u062c\u0627\u062c',

      // Restaurant Detail
      'reviews': '\u062a\u0642\u064a\u064a\u0645',
      'reviews_title': '\u0627\u0644\u062a\u0639\u0644\u064a\u0642\u0627\u062a',
      'directions': '\u0627\u0644\u0627\u062a\u062c\u0627\u0647\u0627\u062a',
      'call': '\u0627\u062a\u0635\u0644',
      'website': '\u0645\u0648\u0642\u0639',
      'working_hours': '\u0633\u0627\u0639\u0627\u062a \u0627\u0644\u0639\u0645\u0644',
      'now_open': '\u0645\u0641\u062a\u0648\u062d \u0627\u0644\u0622\u0646',
      'now_closed': '\u0645\u063a\u0644\u0642 \u0627\u0644\u0622\u0646',
      'restaurant_not_found': '\u0644\u0645 \u064a\u062a\u0645 \u0627\u0644\u0639\u062b\u0648\u0631 \u0639\u0644\u0649 \u0645\u0639\u0644\u0648\u0645\u0627\u062a \u0627\u0644\u0645\u0637\u0639\u0645',
      'shared_via': '\u062a\u0645 \u0627\u0644\u0639\u062b\u0648\u0631 \u0639\u0644\u064a\u0647 \u0628\u0648\u0627\u0633\u0637\u0629 LezzetBul!',

      // Favorites
      'my_favorites': '\u0645\u0641\u0636\u0644\u0627\u062a\u064a',
      'no_favorites': '\u0644\u0627 \u062a\u0648\u062c\u062f \u0645\u0641\u0636\u0644\u0627\u062a \u0628\u0639\u062f',
      'add_favorites_hint': '\u0623\u0636\u0641 \u0627\u0644\u0645\u0637\u0627\u0639\u0645 \u0627\u0644\u062a\u064a \u062a\u0639\u062c\u0628\u0643 \u0625\u0644\u0649 \u0627\u0644\u0645\u0641\u0636\u0644\u0629',
      'favorites_persist': '\u0627\u0644\u0645\u0641\u0636\u0644\u0627\u062a \u0645\u062d\u0641\u0648\u0638\u0629 \u062d\u062a\u0649 \u0639\u0646\u062f \u0625\u063a\u0644\u0627\u0642 \u0627\u0644\u062a\u0637\u0628\u064a\u0642!',
      'favorite_places': '\u0645\u0643\u0627\u0646 \u0645\u0641\u0636\u0644',

      // Map
      'map_title': '\u062e\u0631\u064a\u0637\u0629',
      'your_location': '\u0645\u0648\u0642\u0639\u0643',

      // Survey
      'survey_title': '\u062a\u0648\u0635\u064a\u0629 \u0645\u062e\u0635\u0635\u0629',
      'survey_results_title': '\u062a\u0648\u0635\u064a\u0627\u062a\u0643',
      'survey_continue': '\u0645\u062a\u0627\u0628\u0639\u0629',
      'survey_back': '\u0631\u062c\u0648\u0639',
      'survey_see_results': '\u0639\u0631\u0636 \u0627\u0644\u0646\u062a\u0627\u0626\u062c',
      'survey_restart': '\u0625\u0639\u0627\u062f\u0629',
      'survey_no_results': '\u0644\u0627 \u062a\u0648\u062c\u062f \u0623\u0645\u0627\u0643\u0646 \u062a\u0637\u0627\u0628\u0642 \u0645\u0639\u0627\u064a\u064a\u0631\u0643',
      'survey_expand_filters': '\u062d\u0627\u0648\u0644 \u062a\u0648\u0633\u064a\u0639 \u0627\u0644\u0641\u0644\u0627\u062a\u0631',
      'places_found': '\u0645\u0643\u0627\u0646 \u062a\u0645 \u0627\u0644\u0639\u062b\u0648\u0631 \u0639\u0644\u064a\u0647',

      // Survey Questions
      'q_what_to_eat': '\u0645\u0627\u0630\u0627 \u062a\u0631\u064a\u062f \u0623\u0646 \u062a\u0623\u0643\u0644\u061f',
      'q_what_to_eat_sub': '\u0627\u062e\u062a\u0631 \u0641\u0626\u0629 \u0623\u0648 \u062a\u062e\u0637',
      'q_mood': '\u0645\u0627 \u0645\u0632\u0627\u062c\u0643\u061f',
      'q_mood_sub': '\u0627\u062e\u062a\u0631 \u063a\u0631\u0636 \u0627\u0644\u0637\u0639\u0627\u0645',
      'q_min_rating': '\u0627\u0644\u062d\u062f \u0627\u0644\u0623\u062f\u0646\u0649 \u0644\u0644\u062a\u0642\u064a\u064a\u0645\u061f',
      'q_min_rating_sub': '\u0644\u0646 \u064a\u062a\u0645 \u0639\u0631\u0636 \u0627\u0644\u0623\u0645\u0627\u0643\u0646 \u0623\u0642\u0644 \u0645\u0646 \u0647\u0630\u0627 \u0627\u0644\u062a\u0642\u064a\u064a\u0645',
      'q_distance': '\u0643\u0645 \u064a\u0645\u0643\u0646\u0643 \u0627\u0644\u0630\u0647\u0627\u0628\u061f',
      'q_distance_sub': '\u0627\u0644\u0645\u0633\u0627\u0641\u0629 \u0627\u0644\u0642\u0635\u0648\u0649',
      'q_budget': '\u0645\u0627 \u0645\u064a\u0632\u0627\u0646\u064a\u062a\u0643\u061f',
      'q_budget_sub': '\u0627\u062e\u062a\u0631 \u0646\u0637\u0627\u0642 \u0627\u0644\u0633\u0639\u0631',
      'doesnt_matter': '\u0644\u0627 \u064a\u0647\u0645',
      'only_open_places': '\u0627\u0644\u0623\u0645\u0627\u0643\u0646 \u0627\u0644\u0645\u0641\u062a\u0648\u062d\u0629 \u0641\u0642\u0637',
      'hide_closed': '\u0625\u062e\u0641\u0627\u0621 \u0627\u0644\u0645\u063a\u0644\u0642\u0629',

      // Moods
      'mood_quick': '\u0648\u062c\u0628\u0629 \u0633\u0631\u064a\u0639\u0629',
      'mood_quick_sub': '\u0634\u064a\u0621 \u0642\u0631\u064a\u0628 \u0648\u0633\u0631\u064a\u0639',
      'mood_special': '\u0645\u0646\u0627\u0633\u0628\u0629 \u062e\u0627\u0635\u0629',
      'mood_special_sub': '\u0623\u0641\u0636\u0644 \u0627\u0644\u0623\u0645\u0627\u0643\u0646 \u062a\u0642\u064a\u064a\u0645\u0627\u064b',
      'mood_explore': '\u0627\u0633\u062a\u0643\u0634\u0641',
      'mood_explore_sub': '\u0623\u0631\u064a\u062f \u062a\u062c\u0631\u0628\u0629 \u0623\u0645\u0627\u0643\u0646 \u062c\u062f\u064a\u062f\u0629',
      'mood_popular': '\u0634\u0627\u0626\u0639',
      'mood_popular_sub': '\u0627\u0644\u0623\u0645\u0627\u0643\u0646 \u0627\u0644\u0623\u0643\u062b\u0631 \u0632\u064a\u0627\u0631\u0629',

      // Price
      'price_cheap': '\u0631\u062e\u064a\u0635',
      'price_medium': '\u0645\u062a\u0648\u0633\u0637',
      'price_expensive': '\u063a\u0627\u0644\u064a / \u0641\u0627\u062e\u0631',

      // Profile
      'profile_title': '\u0627\u0644\u0645\u0644\u0641 \u0627\u0644\u0634\u062e\u0635\u064a',
      'dark_mode': '\u0627\u0644\u0648\u0636\u0639 \u0627\u0644\u062f\u0627\u0643\u0646',
      'language': '\u0627\u0644\u0644\u063a\u0629',
      'turkish': 'T\u00fcrk\u00e7e',
      'english': 'English',
      'arabic': '\u0627\u0644\u0639\u0631\u0628\u064a\u0629',
      'visit_history': '\u0633\u062c\u0644 \u0627\u0644\u0632\u064a\u0627\u0631\u0627\u062a',
      'app_info': '\u062d\u0648\u0644 \u0627\u0644\u062a\u0637\u0628\u064a\u0642',
      'version': '\u0627\u0644\u0625\u0635\u062f\u0627\u0631',
      'rate_app': '\u0642\u064a\u0651\u0645 \u0627\u0644\u062a\u0637\u0628\u064a\u0642',
      'clear_search_history': '\u0645\u0633\u062d \u0633\u062c\u0644 \u0627\u0644\u0628\u062d\u062b',
      'search_history_cleared': '\u062a\u0645 \u0645\u0633\u062d \u0633\u062c\u0644 \u0627\u0644\u0628\u062d\u062b',
      'total_visits': '\u0625\u062c\u0645\u0627\u0644\u064a \u0627\u0644\u0632\u064a\u0627\u0631\u0627\u062a',
      'favorite_category': '\u0627\u0644\u0641\u0626\u0629 \u0627\u0644\u0645\u0641\u0636\u0644\u0629',
      'member_since': '\u0639\u0636\u0648 \u0645\u0646\u0630',
      'statistics': '\u0627\u0644\u0625\u062d\u0635\u0627\u0626\u064a\u0627\u062a',
      'preferences': '\u0627\u0644\u062a\u0641\u0636\u064a\u0644\u0627\u062a',
      'location_default': '\u0627\u0644\u0645\u062f\u064a\u0646\u0629 \u0627\u0644\u0627\u0641\u062a\u0631\u0627\u0636\u064a\u0629: \u0625\u0633\u0637\u0646\u0628\u0648\u0644',

      // Onboarding
      'onboarding_skip': '\u062a\u062e\u0637\u064a',
      'onboarding_next': '\u0627\u0644\u062a\u0627\u0644\u064a',
      'onboarding_start': '\u0627\u0628\u062f\u0623!',
      'onboarding_title_1': '\u062d\u062f\u062f \u0645\u0648\u0642\u0639\u0643',
      'onboarding_desc_1': '\u0627\u062d\u0635\u0644 \u0639\u0644\u0649 \u0627\u0644\u0645\u0648\u0642\u0639 \u062a\u0644\u0642\u0627\u0626\u064a\u0627\u064b \u0623\u0648 \u0627\u0628\u062d\u062b \u0639\u0646 \u0623\u064a \u0645\u062f\u064a\u0646\u0629. \u064a\u0639\u0645\u0644 \u0641\u064a \u062c\u0645\u064a\u0639 \u0623\u0646\u062d\u0627\u0621 \u062a\u0631\u0643\u064a\u0627!',
      'onboarding_title_2': '\u0627\u0639\u062b\u0631 \u0639\u0644\u0649 \u0623\u0641\u0636\u0644 \u0627\u0644\u0623\u0645\u0627\u0643\u0646',
      'onboarding_desc_2': '\u0628\u0631\u063a\u0631\u060c \u0643\u0628\u0627\u0628\u060c \u0628\u064a\u062a\u0632\u0627\u060c \u062d\u0644\u0648\u064a\u0627\u062a... \u0641\u0644\u062a\u0631 \u062d\u0633\u0628 \u0627\u0644\u0641\u0626\u0629\u060c \u0631\u062a\u0628 \u062d\u0633\u0628 \u0627\u0644\u062a\u0642\u064a\u064a\u0645 \u0648\u0627\u0644\u0645\u0633\u0627\u0641\u0629.',
      'onboarding_title_3': '\u0627\u0642\u062a\u0631\u0627\u062d\u0627\u062a \u0645\u062e\u0635\u0635\u0629',
      'onboarding_desc_3': '\u0627\u0633\u062a\u062e\u062f\u0645 \u0648\u0636\u0639 \u0627\u0644\u0627\u0633\u062a\u0628\u064a\u0627\u0646\u060c \u0627\u062e\u062a\u0631 \u0645\u0632\u0627\u062c\u0643 \u0648\u0645\u064a\u0632\u0627\u0646\u064a\u062a\u0643!',

      // Compare
      'compare': '\u0645\u0642\u0627\u0631\u0646\u0629',
      'compare_rating': '\u0627\u0644\u062a\u0642\u064a\u064a\u0645',
      'compare_reviews': '\u0627\u0644\u062a\u0639\u0644\u064a\u0642\u0627\u062a',
      'compare_price': '\u0627\u0644\u0633\u0639\u0631',
      'compare_distance': '\u0627\u0644\u0645\u0633\u0627\u0641\u0629',
      'compare_status': '\u0627\u0644\u062d\u0627\u0644\u0629',

      // Recently viewed
      'recently_viewed': '\u0634\u0648\u0647\u062f \u0645\u0624\u062e\u0631\u0627\u064b',

      // Card
      'review_count': '\u062a\u0639\u0644\u064a\u0642',

      // Meal Cards
      'meal_cards_title': '\u0628\u0637\u0627\u0642\u0627\u062a \u0627\u0644\u0637\u0639\u0627\u0645',
      'meal_cards_hint': '\u062d\u062f\u062f \u0627\u0644\u0628\u0637\u0627\u0642\u0627\u062a \u0627\u0644\u0645\u0642\u0628\u0648\u0644\u0629 \u0641\u064a \u0647\u0630\u0627 \u0627\u0644\u0645\u0637\u0639\u0645',
      'meal_cards_all': '\u0643\u0644 \u0627\u0644\u0628\u0637\u0627\u0642\u0627\u062a',

      // Dietary
      'diet_halal': '\u062d\u0644\u0627\u0644',
      'diet_vegetarian': '\u0646\u0628\u0627\u062a\u064a',
      'diet_vegan': '\u0646\u0628\u0627\u062a\u064a \u0635\u0631\u0641',
      'diet_gluten_free': '\u062e\u0627\u0644\u064a \u0645\u0646 \u0627\u0644\u063a\u0644\u0648\u062a\u064a\u0646',

      // Auth & Friends
      'auth_login': '\u062a\u0633\u062c\u064a\u0644 \u0627\u0644\u062f\u062e\u0648\u0644',
      'auth_register': '\u0625\u0646\u0634\u0627\u0621 \u062d\u0633\u0627\u0628',
      'auth_email': '\u0627\u0644\u0628\u0631\u064a\u062f \u0627\u0644\u0625\u0644\u0643\u062a\u0631\u0648\u0646\u064a',
      'auth_password': '\u0643\u0644\u0645\u0629 \u0627\u0644\u0645\u0631\u0648\u0631',
      'auth_password_confirm': '\u062a\u0623\u0643\u064a\u062f \u0643\u0644\u0645\u0629 \u0627\u0644\u0645\u0631\u0648\u0631',
      'auth_name': '\u0627\u0644\u0627\u0633\u0645 \u0627\u0644\u0643\u0627\u0645\u0644',
      'auth_email_required': '\u0623\u062f\u062e\u0644 \u0628\u0631\u064a\u062f\u0643 \u0627\u0644\u0625\u0644\u0643\u062a\u0631\u0648\u0646\u064a',
      'auth_email_invalid': '\u0623\u062f\u062e\u0644 \u0628\u0631\u064a\u062f\u0627\u064b \u0625\u0644\u0643\u062a\u0631\u0648\u0646\u064a\u0627\u064b \u0635\u0627\u0644\u062d\u0627\u064b',
      'auth_password_required': '\u0623\u062f\u062e\u0644 \u0643\u0644\u0645\u0629 \u0627\u0644\u0645\u0631\u0648\u0631',
      'auth_password_short': '\u0643\u0644\u0645\u0629 \u0627\u0644\u0645\u0631\u0648\u0631 4 \u0623\u062d\u0631\u0641 \u0639\u0644\u0649 \u0627\u0644\u0623\u0642\u0644',
      'auth_password_confirm_required': '\u0623\u0643\u062f \u0643\u0644\u0645\u0629 \u0627\u0644\u0645\u0631\u0648\u0631',
      'auth_password_mismatch': '\u0643\u0644\u0645\u0627\u062a \u0627\u0644\u0645\u0631\u0648\u0631 \u063a\u064a\u0631 \u0645\u062a\u0637\u0627\u0628\u0642\u0629',
      'auth_name_required': '\u0623\u062f\u062e\u0644 \u0627\u0633\u0645\u0643',
      'auth_login_error': '\u0628\u0631\u064a\u062f \u0625\u0644\u0643\u062a\u0631\u0648\u0646\u064a \u0623\u0648 \u0643\u0644\u0645\u0629 \u0645\u0631\u0648\u0631 \u063a\u064a\u0631 \u0635\u062d\u064a\u062d\u0629',
      'auth_register_error': '\u0647\u0630\u0627 \u0627\u0644\u0628\u0631\u064a\u062f \u0645\u0633\u062c\u0644 \u0628\u0627\u0644\u0641\u0639\u0644',
      'auth_logout': '\u062a\u0633\u062c\u064a\u0644 \u0627\u0644\u062e\u0631\u0648\u062c',
      'friends_title': '\u0623\u0635\u062f\u0642\u0627\u0626\u064a',
      'friends_add': '\u0625\u0636\u0627\u0641\u0629 \u0635\u062f\u064a\u0642',
      'friends_remove': '\u0625\u0632\u0627\u0644\u0629 \u0635\u062f\u064a\u0642',
      'friends_remove_confirm': '\u0633\u064a\u062a\u0645 \u0625\u0632\u0627\u0644\u062a\u0647 \u0645\u0646 \u0642\u0627\u0626\u0645\u0629 \u0623\u0635\u062f\u0642\u0627\u0626\u0643.',
      'friends_empty': '\u0644\u0645 \u064a\u062a\u0645 \u0625\u0636\u0627\u0641\u0629 \u0623\u0635\u062f\u0642\u0627\u0621 \u0628\u0639\u062f',
      'friends_empty_hint': '\u0623\u0636\u0641 \u0623\u0635\u062f\u0642\u0627\u0621\u0643 \u0648\u0627\u0643\u062a\u0634\u0641\u0648\u0627 \u0627\u0644\u0646\u0643\u0647\u0627\u062a \u0645\u0639\u0627\u064b!',
      'friends_label': '\u0635\u062f\u064a\u0642',
      'friends_add_btn': '\u0625\u0636\u0627\u0641\u0629',
      'friends_remove_btn': '\u0625\u0632\u0627\u0644\u0629',
      'share_restaurant': '\u0645\u0634\u0627\u0631\u0643\u0629 \u0627\u0644\u0645\u0637\u0639\u0645',

      // Help
      'help_title': '\u0627\u0644\u0645\u0633\u0627\u0639\u062f\u0629',
      'help_q1': '\u0643\u064a\u0641 \u064a\u0639\u0645\u0644 LezzetBul\u061f',
      'help_a1': '\u062d\u062f\u062f \u0645\u0648\u0642\u0639\u0643 \u0623\u0648 \u0627\u0628\u062d\u062b \u0639\u0646 \u0645\u062f\u064a\u0646\u0629. \u064a\u062a\u0645 \u0639\u0631\u0636 \u0627\u0644\u0645\u0637\u0627\u0639\u0645 \u0627\u0644\u0642\u0631\u064a\u0628\u0629 \u062a\u0644\u0642\u0627\u0626\u064a\u0627\u064b.',
      'help_q2': '\u0643\u064a\u0641 \u0623\u0636\u064a\u0641 \u0628\u0637\u0627\u0642\u0629 \u0637\u0639\u0627\u0645\u061f',
      'help_a2': '\u0627\u0630\u0647\u0628 \u0625\u0644\u0649 \u062a\u0641\u0627\u0635\u064a\u0644 \u0627\u0644\u0645\u0637\u0639\u0645 \u0648\u062d\u062f\u062f \u0627\u0644\u0628\u0637\u0627\u0642\u0627\u062a \u0627\u0644\u0645\u0642\u0628\u0648\u0644\u0629.',
      'help_q3': '\u0647\u0644 \u0633\u062a\u0636\u064a\u0639 \u0627\u0644\u0645\u0641\u0636\u0644\u0627\u062a\u061f',
      'help_a3': '\u0644\u0627! \u0627\u0644\u0645\u0641\u0636\u0644\u0627\u062a \u0645\u062d\u0641\u0648\u0638\u0629 \u0628\u0623\u0645\u0627\u0646 \u0639\u0644\u0649 \u062c\u0647\u0627\u0632\u0643.',
      'help_q4': '\u0645\u0627 \u0647\u0648 \u0648\u0636\u0639 \u0627\u0644\u0627\u0633\u062a\u0628\u064a\u0627\u0646\u061f',
      'help_a4': '\u0627\u062e\u062a\u0631 \u0645\u0632\u0627\u062c\u0643 \u0648\u0645\u064a\u0632\u0627\u0646\u064a\u062a\u0643 \u0644\u0644\u062d\u0635\u0648\u0644 \u0639\u0644\u0649 \u062a\u0648\u0635\u064a\u0627\u062a \u0645\u062e\u0635\u0635\u0629.',
      'help_q5': '\u0647\u0644 \u0627\u0644\u062a\u0637\u0628\u064a\u0642 \u0645\u062c\u0627\u0646\u064a\u061f',
      'help_a5': '\u0646\u0639\u0645\u060c LezzetBul \u0645\u062c\u0627\u0646\u064a \u062a\u0645\u0627\u0645\u0627\u064b.',
    },
  };

  String get(String key) {
    return _localizedValues[languageCode]?[key] ??
        _localizedValues['tr']?[key] ??
        key;
  }
}
