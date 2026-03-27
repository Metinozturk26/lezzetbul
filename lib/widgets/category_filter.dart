import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/restaurant_provider.dart';

class CategoryFilter extends StatelessWidget {
  const CategoryFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<RestaurantProvider>(
      builder: (context, provider, _) {
        final lang = provider.currentLanguage;
        return Container(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          height: 52,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: foodCategories.length,
            itemBuilder: (context, index) {
              final category = foodCategories[index];
              final isSelected = provider.selectedCategoryIndex == index;

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => provider.selectCategory(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppConstants.primaryColor
                          : isDark ? Colors.white10 : AppConstants.backgroundColor,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected
                            ? AppConstants.primaryColor
                            : isDark ? Colors.white24 : Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          category.icon,
                          size: 18,
                          color: isSelected
                              ? Colors.white
                              : isDark ? Colors.white60 : AppConstants.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          category.getName(lang),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : isDark ? Colors.white60 : AppConstants.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
