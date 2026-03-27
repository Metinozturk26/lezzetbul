import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/app_constants.dart';
import 'providers/restaurant_provider.dart';
import 'screens/home_screen.dart';
import 'screens/map_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/survey_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const LezzetBulApp());
}

class LezzetBulApp extends StatelessWidget {
  const LezzetBulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = RestaurantProvider();
        provider.init();
        return provider;
      },
      child: Consumer<RestaurantProvider>(
        builder: (context, provider, _) {
          return MaterialApp(
            title: 'LezzetBul',
            debugShowCheckedModeBanner: false,
            themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: _lightTheme(),
            darkTheme: _darkTheme(),
            home: const AppEntryPoint(),
          );
        },
      ),
    );
  }

  ThemeData _lightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.primaryColor,
        primary: AppConstants.primaryColor,
        secondary: AppConstants.secondaryColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppConstants.backgroundColor,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        iconTheme: IconThemeData(color: AppConstants.textPrimary),
        titleTextStyle: TextStyle(
          color: AppConstants.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.primaryColor,
        primary: AppConstants.primaryColor,
        secondary: AppConstants.secondaryColor,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        elevation: 0,
        scrolledUnderElevation: 1,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

/// Splash -> Onboarding (first time) -> Main
class AppEntryPoint extends StatefulWidget {
  const AppEntryPoint({super.key});

  @override
  State<AppEntryPoint> createState() => _AppEntryPointState();
}

class _AppEntryPointState extends State<AppEntryPoint> {
  _AppState _state = _AppState.splash;

  @override
  void initState() {
    super.initState();
  }

  void _onSplashComplete() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('onboarding_seen') ?? false;
    setState(() {
      _state = seen ? _AppState.main : _AppState.onboarding;
    });
  }

  void _onOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
    setState(() => _state = _AppState.main);
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case _AppState.splash:
        return SplashScreen(onComplete: _onSplashComplete);
      case _AppState.onboarding:
        return OnboardingScreen(onComplete: _onOnboardingComplete);
      case _AppState.main:
        return const MainScreen();
    }
  }
}

enum _AppState { splash, onboarding, main }

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    SurveyScreen(),
    MapScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<RestaurantProvider>();
    final l = AppLocalizations(provider.currentLanguage);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
          },
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          indicatorColor: AppConstants.primaryColor.withOpacity(0.15),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.explore_outlined),
              selectedIcon:
                  const Icon(Icons.explore, color: AppConstants.primaryColor),
              label: l.get('nav_explore'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.quiz_outlined),
              selectedIcon:
                  const Icon(Icons.quiz, color: AppConstants.primaryColor),
              label: l.get('nav_survey'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.map_outlined),
              selectedIcon:
                  const Icon(Icons.map, color: AppConstants.primaryColor),
              label: l.get('nav_map'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.favorite_border),
              selectedIcon:
                  const Icon(Icons.favorite, color: AppConstants.primaryColor),
              label: l.get('nav_favorites'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon:
                  const Icon(Icons.person, color: AppConstants.primaryColor),
              label: l.get('nav_profile'),
            ),
          ],
        ),
      ),
    );
  }
}
