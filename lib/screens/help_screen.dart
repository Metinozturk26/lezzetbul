import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/restaurant_provider.dart';
import '../l10n/app_localizations.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<RestaurantProvider>();
    final l = AppLocalizations(provider.currentLanguage);

    final faqs = [
      {'q': l.get('help_q1'), 'a': l.get('help_a1')},
      {'q': l.get('help_q2'), 'a': l.get('help_a2')},
      {'q': l.get('help_q3'), 'a': l.get('help_a3')},
      {'q': l.get('help_q4'), 'a': l.get('help_a4')},
      {'q': l.get('help_q5'), 'a': l.get('help_a5')},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l.get('help_title')),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey.shade200,
              ),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: AppConstants.primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  faqs[index]['q']!,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppConstants.textPrimary,
                  ),
                ),
                iconColor: AppConstants.primaryColor,
                collapsedIconColor: isDark ? Colors.white38 : AppConstants.textSecondary,
                children: [
                  Text(
                    faqs[index]['a']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white60 : AppConstants.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
