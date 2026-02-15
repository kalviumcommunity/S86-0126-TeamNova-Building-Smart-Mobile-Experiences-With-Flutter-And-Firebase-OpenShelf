import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Testing Checklist Screen
/// Provides comprehensive checklist for testing on emulators and physical devices
class TestingChecklistScreen extends StatefulWidget {
  const TestingChecklistScreen({super.key});

  @override
  State<TestingChecklistScreen> createState() => _TestingChecklistScreenState();
}

class _TestingChecklistScreenState extends State<TestingChecklistScreen> {
  late SharedPreferences _prefs;
  Map<String, bool> _checkedItems = {};
  bool _isLoading = true;

  final List<ChecklistCategory> _categories = [
    ChecklistCategory(
      title: 'Pre-Testing Setup',
      icon: Icons.settings,
      items: [
        ChecklistItem('Enable USB Debugging on physical device', 'setup_usb'),
        ChecklistItem('Install necessary drivers (Windows)', 'setup_drivers'),
        ChecklistItem('Configure Android Studio emulator', 'setup_emulator'),
        ChecklistItem('Set up iOS Simulator (Mac only)', 'setup_ios_sim'),
        ChecklistItem('Run "flutter doctor" and fix issues', 'setup_doctor'),
        ChecklistItem(
          'Verify device detection with "flutter devices"',
          'setup_devices',
        ),
      ],
    ),
    ChecklistCategory(
      title: 'Emulator Testing',
      icon: Icons.computer,
      items: [
        ChecklistItem(
          'Test app launch on Android emulator',
          'emu_launch_android',
        ),
        ChecklistItem('Test app launch on iOS Simulator', 'emu_launch_ios'),
        ChecklistItem('Verify all screens render correctly', 'emu_screens'),
        ChecklistItem('Test navigation between screens', 'emu_navigation'),
        ChecklistItem('Check hot reload functionality', 'emu_hot_reload'),
        ChecklistItem('Test different screen sizes', 'emu_screen_sizes'),
        ChecklistItem('Rotate device (portrait/landscape)', 'emu_rotation'),
        ChecklistItem(
          'Test with different Android API levels',
          'emu_api_levels',
        ),
      ],
    ),
    ChecklistCategory(
      title: 'Physical Device Testing',
      icon: Icons.smartphone,
      items: [
        ChecklistItem(
          'Connect device via USB and verify detection',
          'dev_connect',
        ),
        ChecklistItem(
          'Install and launch app on physical device',
          'dev_install',
        ),
        ChecklistItem('Test actual touch interactions', 'dev_touch'),
        ChecklistItem(
          'Verify performance (no lag/stuttering)',
          'dev_performance',
        ),
        ChecklistItem('Test app in real lighting conditions', 'dev_lighting'),
        ChecklistItem('Verify battery usage is reasonable', 'dev_battery'),
        ChecklistItem('Test on different device models', 'dev_models'),
      ],
    ),
    ChecklistCategory(
      title: 'Permission Testing',
      icon: Icons.security,
      items: [
        ChecklistItem('Test camera permission request', 'perm_camera'),
        ChecklistItem('Test storage permission request', 'perm_storage'),
        ChecklistItem('Handle permission denial gracefully', 'perm_denial'),
        ChecklistItem(
          'Test permission revocation while app running',
          'perm_revoke',
        ),
        ChecklistItem('Verify Firebase permissions', 'perm_firebase'),
      ],
    ),
    ChecklistCategory(
      title: 'Network & Firebase Testing',
      icon: Icons.cloud,
      items: [
        ChecklistItem('Test with active internet connection', 'net_online'),
        ChecklistItem('Test with airplane mode enabled', 'net_offline'),
        ChecklistItem('Test Firebase Authentication', 'fb_auth'),
        ChecklistItem('Test Firestore read/write operations', 'fb_firestore'),
        ChecklistItem('Test Firebase Storage uploads', 'fb_storage'),
        ChecklistItem('Test Cloud Functions execution', 'fb_functions'),
        ChecklistItem('Handle network errors gracefully', 'net_errors'),
      ],
    ),
    ChecklistCategory(
      title: 'UI/UX Testing',
      icon: Icons.palette,
      items: [
        ChecklistItem('Test dark mode toggle', 'ui_dark_mode'),
        ChecklistItem('Verify theme consistency across screens', 'ui_theme'),
        ChecklistItem('Test loading states', 'ui_loading'),
        ChecklistItem('Test error messages display correctly', 'ui_errors'),
        ChecklistItem('Test empty states', 'ui_empty'),
        ChecklistItem(
          'Verify responsive design on different sizes',
          'ui_responsive',
        ),
        ChecklistItem('Test animations and transitions', 'ui_animations'),
        ChecklistItem('Check text readability and contrast', 'ui_contrast'),
      ],
    ),
    ChecklistCategory(
      title: 'Edge Case Testing',
      icon: Icons.warning,
      items: [
        ChecklistItem('Test with very long text inputs', 'edge_long_text'),
        ChecklistItem('Test with special characters', 'edge_special_chars'),
        ChecklistItem('Test app backgrounding and resuming', 'edge_background'),
        ChecklistItem('Test low memory scenarios', 'edge_low_memory'),
        ChecklistItem('Test rapid button tapping', 'edge_rapid_tap'),
        ChecklistItem('Test concurrent operations', 'edge_concurrent'),
      ],
    ),
    ChecklistCategory(
      title: 'Final Verification',
      icon: Icons.check_circle,
      items: [
        ChecklistItem('No console errors or warnings', 'final_console'),
        ChecklistItem('App version matches expected', 'final_version'),
        ChecklistItem('All assets load correctly', 'final_assets'),
        ChecklistItem('App installs and uninstalls cleanly', 'final_install'),
        ChecklistItem('User data persists correctly', 'final_persistence'),
        ChecklistItem('Ready for production deployment', 'final_production'),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadChecklistState();
  }

  Future<void> _loadChecklistState() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var category in _categories) {
        for (var item in category.items) {
          _checkedItems[item.key] =
              _prefs.getBool('checklist_${item.key}') ?? false;
        }
      }
      _isLoading = false;
    });
  }

  Future<void> _toggleItem(String key, bool value) async {
    await _prefs.setBool('checklist_$key', value);
    setState(() {
      _checkedItems[key] = value;
    });
  }

  Future<void> _resetChecklist() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Checklist'),
        content: const Text(
          'Are you sure you want to reset all checklist items?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      for (var category in _categories) {
        for (var item in category.items) {
          await _prefs.setBool('checklist_${item.key}', false);
        }
      }
      setState(() {
        _checkedItems = {for (var key in _checkedItems.keys) key: false};
      });
    }
  }

  int _getCompletedCount() {
    return _checkedItems.values.where((checked) => checked).length;
  }

  int _getTotalCount() {
    return _checkedItems.length;
  }

  double _getProgress() {
    final total = _getTotalCount();
    if (total == 0) return 0;
    return _getCompletedCount() / total;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing Checklist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetChecklist,
            tooltip: 'Reset Checklist',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildProgressHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _categories.length,
              itemBuilder: (context, index) =>
                  _buildCategory(_categories[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressHeader() {
    final completed = _getCompletedCount();
    final total = _getTotalCount();
    final progress = _getProgress();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overall Progress',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '$completed / $total',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toStringAsFixed(1)}% Complete',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(ChecklistCategory category) {
    final categoryCompleted = category.items
        .where((item) => _checkedItems[item.key] == true)
        .length;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Icon(
          category.icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          category.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '$categoryCompleted / ${category.items.length} completed',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        children: category.items.map((item) {
          return CheckboxListTile(
            title: Text(item.title),
            value: _checkedItems[item.key] ?? false,
            onChanged: (value) => _toggleItem(item.key, value ?? false),
            controlAffinity: ListTileControlAffinity.leading,
          );
        }).toList(),
      ),
    );
  }
}

class ChecklistCategory {
  final String title;
  final IconData icon;
  final List<ChecklistItem> items;

  ChecklistCategory({
    required this.title,
    required this.icon,
    required this.items,
  });
}

class ChecklistItem {
  final String title;
  final String key;

  ChecklistItem(this.title, this.key);
}
