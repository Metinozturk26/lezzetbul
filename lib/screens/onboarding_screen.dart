import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/restaurant_provider.dart';
import '../l10n/app_localizations.dart';


class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  List<_OnboardingPage> _buildPages(AppLocalizations l) {
    return [
      _OnboardingPage(
        icon: Icons.location_on,
        title: l.get('onboarding_title_1'),
        description: l.get('onboarding_desc_1'),
        color: AppConstants.primaryColor,
      ),
      _OnboardingPage(
        icon: Icons.restaurant_menu,
        title: l.get('onboarding_title_2'),
        description: l.get('onboarding_desc_2'),
        color: AppConstants.secondaryColor,
      ),
      _OnboardingPage(
        icon: Icons.quiz,
        title: l.get('onboarding_title_3'),
        description: l.get('onboarding_desc_3'),
        color: const Color(0xFF2ECC71),
      ),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RestaurantProvider>();
    final l = AppLocalizations(provider.currentLanguage);
    final pages = _buildPages(l);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: widget.onComplete,
                child: Text(l.get('onboarding_skip'),
                    style: TextStyle(
                        color: isDark ? Colors.white60 : AppConstants.textSecondary,
                        fontSize: 16)),
              ),
            ),
            // Pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: page.color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: index == 1
                              ? Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : Icon(page.icon, size: 72, color: page.color),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          page.title,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppConstants.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white60 : AppConstants.textSecondary,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Dots & button
            Padding(
              padding: const EdgeInsets.all(32),
              child: Row(
                children: [
                  // Dots
                  Row(
                    children: List.generate(pages.length, (i) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8),
                        width: _currentPage == i ? 28 : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _currentPage == i
                              ? AppConstants.primaryColor
                              : isDark ? Colors.white24 : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      );
                    }),
                  ),
                  const Spacer(),
                  // Next / Get Started button
                  GestureDetector(
                    onTap: () {
                      if (_currentPage < pages.length - 1) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        widget.onComplete();
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _currentPage == pages.length - 1 ? 160 : 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: _currentPage == pages.length - 1
                            ? Text(
                                l.get('onboarding_start'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            : const Icon(Icons.arrow_forward,
                                color: Colors.white, size: 28),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
