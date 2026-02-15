import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

/// Interactive demo screen for testing and toggling theme modes
/// Demonstrates dynamic theme switching with visual feedback
class ThemingDemoScreen extends StatelessWidget {
  const ThemingDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Settings'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme(!isDark);
            },
            tooltip: 'Toggle theme',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Section
          _buildHeader(context),
          const SizedBox(height: 24),

          // Theme Mode Selector
          _buildThemeModeSelector(context, themeProvider),
          const SizedBox(height: 32),

          // Quick Toggle Switch
          _buildQuickToggle(context, themeProvider, isDark),
          const SizedBox(height: 32),

          // Visual Preview Cards
          _buildPreviewCards(context),
          const SizedBox(height: 32),

          // Theme Benefits
          _buildBenefitsSection(context, isDark),
          const SizedBox(height: 32),

          // Sample Widgets
          _buildSampleWidgets(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dark Mode & Theming',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Customize your visual experience with light, dark, or system theme',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
        ),
      ],
    );
  }

  Widget _buildThemeModeSelector(BuildContext context, ThemeProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Theme Mode',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildThemeOption(
              context,
              title: 'Light Mode',
              subtitle: 'Best for daytime use',
              icon: Icons.light_mode,
              isSelected: provider.themeMode == ThemeMode.light,
              onTap: () => provider.useLightTheme(),
            ),
            const Divider(),
            _buildThemeOption(
              context,
              title: 'Dark Mode',
              subtitle: 'Reduces eye strain, saves battery',
              icon: Icons.dark_mode,
              isSelected: provider.themeMode == ThemeMode.dark,
              onTap: () => provider.useDarkTheme(),
            ),
            const Divider(),
            _buildThemeOption(
              context,
              title: 'System Default',
              subtitle: 'Follow device settings',
              icon: Icons.settings_suggest,
              isSelected: provider.themeMode == ThemeMode.system,
              onTap: () => provider.useSystemTheme(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      onTap: onTap,
      selected: isSelected,
    );
  }

  Widget _buildQuickToggle(
    BuildContext context,
    ThemeProvider provider,
    bool isDark,
  ) {
    return Card(
      child: SwitchListTile(
        secondary: Icon(
          isDark ? Icons.nightlight_round : Icons.wb_sunny,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: const Text('Quick Dark Mode Toggle'),
        subtitle: Text(isDark ? 'Dark mode enabled' : 'Light mode enabled'),
        value: isDark,
        onChanged: (value) {
          provider.toggleTheme(value);
        },
      ),
    );
  }

  Widget _buildPreviewCards(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Theme Preview',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.bookmark,
                        size: 32,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Primary',
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Card(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.favorite,
                        size: 32,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Secondary',
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBenefitsSection(BuildContext context, bool isDark) {
    final benefits = isDark
        ? [
            _Benefit(Icons.battery_charging_full, 'Battery Saving',
                'OLED screens use less power'),
            _Benefit(Icons.remove_red_eye, 'Reduced Eye Strain',
                'Better for low-light environments'),
            _Benefit(Icons.nights_stay, 'Better Sleep',
                'Less blue light before bedtime'),
          ]
        : [
            _Benefit(Icons.wb_sunny, 'Clear Visibility',
                'Perfect for bright environments'),
            _Benefit(Icons.article, 'Better Readability',
                'Easier to read in daylight'),
            _Benefit(Icons.energy_savings_leaf, 'Universal Compatibility',
                'Works well on all screen types'),
          ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Theme Benefits',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...benefits.map((benefit) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        benefit.icon,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              benefit.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              benefit.description,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildSampleWidgets(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sample UI Elements',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Elevated Button'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  label: const Text('Outlined Button'),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.info),
                  label: const Text('Text Button'),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Sample Input',
                    hintText: 'Enter some text',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: [
                    Chip(
                      avatar: const Icon(Icons.star, size: 16),
                      label: const Text('Chip 1'),
                    ),
                    Chip(
                      avatar: const Icon(Icons.favorite, size: 16),
                      label: const Text('Chip 2'),
                    ),
                    Chip(
                      avatar: const Icon(Icons.bookmark, size: 16),
                      label: const Text('Chip 3'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Benefit {
  final IconData icon;
  final String title;
  final String description;

  _Benefit(this.icon, this.title, this.description);
}
