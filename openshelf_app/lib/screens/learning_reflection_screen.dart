import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Learning Reflection Screen
/// Track technical learnings, challenges, and personal growth throughout development
class LearningReflectionScreen extends StatefulWidget {
  const LearningReflectionScreen({super.key});

  @override
  State<LearningReflectionScreen> createState() =>
      _LearningReflectionScreenState();
}

class _LearningReflectionScreenState extends State<LearningReflectionScreen> {
  late SharedPreferences _prefs;
  bool _isLoading = true;

  final TextEditingController _technicalController = TextEditingController();
  final TextEditingController _challengesController = TextEditingController();
  final TextEditingController _solutionsController = TextEditingController();
  final TextEditingController _growthController = TextEditingController();
  final TextEditingController _nextStepsController = TextEditingController();

  final List<ReflectionCategory> _categories = [
    ReflectionCategory(
      title: 'Technical Skills',
      icon: Icons.code,
      color: Colors.blue,
      prompts: [
        'What new Flutter concepts did you master?',
        'Which Firebase features did you integrate?',
        'What debugging techniques did you learn?',
        'How did you handle state management?',
        'What UI/UX patterns did you implement?',
      ],
    ),
    ReflectionCategory(
      title: 'Challenges Faced',
      icon: Icons.warning_amber,
      color: Colors.orange,
      prompts: [
        'What was the hardest technical problem?',
        'Which bugs took longest to fix?',
        'What Firebase integration issues arose?',
        'What deployment challenges occurred?',
        'What performance issues did you encounter?',
      ],
    ),
    ReflectionCategory(
      title: 'Solutions & Learning',
      icon: Icons.lightbulb,
      color: Colors.amber,
      prompts: [
        'How did you solve complex problems?',
        'What resources helped you most?',
        'What would you do differently?',
        'What best practices did you learn?',
        'What patterns will you reuse?',
      ],
    ),
    ReflectionCategory(
      title: 'Personal Growth',
      icon: Icons.trending_up,
      color: Colors.green,
      prompts: [
        'Which skills improved the most?',
        'What are you most proud of?',
        'How did your confidence grow?',
        'What surprised you about mobile development?',
        'How has your development workflow improved?',
      ],
    ),
    ReflectionCategory(
      title: 'Next Steps',
      icon: Icons.flag,
      color: Colors.purple,
      prompts: [
        'What features will you add next?',
        'What technologies do you want to learn?',
        'How will you improve app performance?',
        'What analytics will you track?',
        'What skills do you want to develop?',
      ],
    ),
  ];

  Map<String, Set<String>> _checkedSkills = {};
  
  final List<SkillCategory> _skillsChecklist = [
    SkillCategory(
      title: 'Flutter Fundamentals',
      skills: [
        'Widget tree and composition',
        'Stateless vs Stateful widgets',
        'State management (Provider)',
        'Navigation and routing',
        'Theme and styling',
        'Responsive design',
        'Animations and transitions',
        'Asset management',
      ],
    ),
    SkillCategory(
      title: 'Firebase Integration',
      skills: [
        'Firebase Authentication',
        'Cloud Firestore (CRUD)',
        'Realtime data synchronization',
        'Complex queries and filters',
        'Firebase Storage',
        'Cloud Functions',
        'SHA fingerprint configuration',
      ],
    ),
    SkillCategory(
      title: 'Production Skills',
      skills: [
        'Error handling and validation',
        'Loading states and indicators',
        'Empty states',
        'Release build configuration',
        'App signing with keystore',
        'Building AAB for Play Store',
        'Play Store deployment',
        'Version management',
      ],
    ),
    SkillCategory(
      title: 'Testing & Quality',
      skills: [
        'Device testing (emulator)',
        'Physical device testing',
        'Permission handling',
        'Network error handling',
        'Performance optimization',
        'Dark mode implementation',
        'Accessibility considerations',
      ],
    ),
    SkillCategory(
      title: 'Professional Practices',
      skills: [
        'Git version control',
        'Branch management',
        'Code documentation',
        'Security best practices',
        'API key protection',
        'Troubleshooting and debugging',
        'Reading Flutter documentation',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadReflections();
  }

  @override
  void dispose() {
    _technicalController.dispose();
    _challengesController.dispose();
    _solutionsController.dispose();
    _growthController.dispose();
    _nextStepsController.dispose();
    super.dispose();
  }

  Future<void> _loadReflections() async {
    setState(() => _isLoading = true);

    _prefs = await SharedPreferences.getInstance();

    // Load saved reflections
    _technicalController.text = _prefs.getString('reflection_technical') ?? '';
    _challengesController.text = _prefs.getString('reflection_challenges') ?? '';
    _solutionsController.text = _prefs.getString('reflection_solutions') ?? '';
    _growthController.text = _prefs.getString('reflection_growth') ?? '';
    _nextStepsController.text = _prefs.getString('reflection_next_steps') ?? '';

    // Load checked skills
    for (var category in _skillsChecklist) {
      final categoryKey = category.title.toLowerCase().replaceAll(' ', '_');
      final checkedSkills = _prefs.getStringList('skills_$categoryKey') ?? [];
      _checkedSkills[category.title] = Set.from(checkedSkills);
    }

    setState(() => _isLoading = false);
  }

  Future<void> _saveReflection(String key, String value) async {
    await _prefs.setString('reflection_$key', value);
  }

  Future<void> _toggleSkill(String category, String skill, bool value) async {
    setState(() {
      if (value) {
        _checkedSkills[category]?.add(skill);
      } else {
        _checkedSkills[category]?.remove(skill);
      }
    });

    final categoryKey = category.toLowerCase().replaceAll(' ', '_');
    await _prefs.setStringList(
      'skills_$categoryKey',
      _checkedSkills[category]?.toList() ?? [],
    );
  }

  int _getTotalSkillsCompleted() {
    return _checkedSkills.values.fold(0, (sum, set) => sum + set.length);
  }

  int _getTotalSkills() {
    return _skillsChecklist.fold(0, (sum, cat) => sum + cat.skills.length);
  }

  double _getSkillsProgress() {
    final total = _getTotalSkills();
    if (total == 0) return 0;
    return _getTotalSkillsCompleted() / total;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Learning Reflection'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.psychology), text: 'Reflections'),
              Tab(icon: Icon(Icons.check_circle), text: 'Skills'),
              Tab(icon: Icon(Icons.insights), text: 'Insights'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildReflectionsTab(),
            _buildSkillsTab(),
            _buildInsightsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildReflectionsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildProgressCard(),
        const SizedBox(height: 16),
        ..._categories.map((category) => _buildReflectionCard(category)),
      ],
    );
  }

  Widget _buildProgressCard() {
    final completed = _getTotalSkillsCompleted();
    final total = _getTotalSkills();
    final progress = _getSkillsProgress();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Learning Progress',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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
              '${(progress * 100).toStringAsFixed(1)}% Skills Mastered',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReflectionCard(ReflectionCategory category) {
    late TextEditingController controller;
    late String key;

    switch (_categories.indexOf(category)) {
      case 0:
        controller = _technicalController;
        key = 'technical';
        break;
      case 1:
        controller = _challengesController;
        key = 'challenges';
        break;
      case 2:
        controller = _solutionsController;
        key = 'solutions';
        break;
      case 3:
        controller = _growthController;
        key = 'growth';
        break;
      case 4:
        controller = _nextStepsController;
        key = 'next_steps';
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: category.color,
          child: Icon(category.icon, color: Colors.white),
        ),
        title: Text(
          category.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reflection Prompts:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                ...category.prompts.map((prompt) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• ', style: TextStyle(color: category.color)),
                          Expanded(
                            child: Text(
                              prompt,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: 'Share your thoughts and learnings...',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  onChanged: (value) => _saveReflection(key, value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildProgressCard(),
        const SizedBox(height: 16),
        ..._skillsChecklist.map((category) => _buildSkillCategoryCard(category)),
      ],
    );
  }

  Widget _buildSkillCategoryCard(SkillCategory category) {
    _checkedSkills.putIfAbsent(category.title, () => {});
    final completed = _checkedSkills[category.title]!.length;
    final total = category.skills.length;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Icon(Icons.folder, color: Theme.of(context).colorScheme.primary),
        title: Text(
          category.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('$completed / $total completed'),
        children: category.skills.map((skill) {
          final isChecked = _checkedSkills[category.title]!.contains(skill);
          return CheckboxListTile(
            title: Text(skill),
            value: isChecked,
            onChanged: (value) => _toggleSkill(category.title, skill, value ?? false),
            controlAffinity: ListTileControlAffinity.leading,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInsightsTab() {
    final completed = _getTotalSkillsCompleted();
    final total = _getTotalSkills();
    final progress = _getSkillsProgress();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.emoji_events, color: Colors.amber, size: 32),
                    const SizedBox(width: 12),
                    Text(
                      'Your Achievements',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildInsightRow(
                  'Skills Mastered',
                  '$completed / $total',
                  Icons.school,
                  Colors.blue,
                ),
                _buildInsightRow(
                  'Progress',
                  '${(progress * 100).toStringAsFixed(1)}%',
                  Icons.trending_up,
                  Colors.green,
                ),
                _buildInsightRow(
                  'Categories Completed',
                  '${_checkedSkills.values.where((s) => s.isNotEmpty).length} / ${_skillsChecklist.length}',
                  Icons.category,
                  Colors.purple,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildMilestonesCard(),
        const SizedBox(height: 16),
        _buildReflectionSummaryCard(),
      ],
    );
  }

  Widget _buildInsightRow(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestonesCard() {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flag, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  'Sprint Milestones',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildMilestone('✅ Built complete Flutter app'),
            _buildMilestone('✅ Integrated Firebase services'),
            _buildMilestone('✅ Implemented theming system'),
            _buildMilestone('✅ Added error handling'),
            _buildMilestone('✅ Created release build'),
            _buildMilestone('✅ Deployed to Play Store'),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestone(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildReflectionSummaryCard() {
    final hasReflections = _technicalController.text.isNotEmpty ||
        _challengesController.text.isNotEmpty ||
        _solutionsController.text.isNotEmpty ||
        _growthController.text.isNotEmpty ||
        _nextStepsController.text.isNotEmpty;

    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description, color: Theme.of(context).colorScheme.secondary),
                const SizedBox(width: 12),
                Text(
                  'Reflection Status',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (hasReflections) ...[
              const Icon(Icons.check_circle, color: Colors.green, size: 48),
              const SizedBox(height: 8),
              const Text(
                'Great job! You\'ve documented your learnings.',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your reflections will help you in future projects and interviews.',
              ),
            ] else ...[
              const Icon(Icons.edit_note, color: Colors.orange, size: 48),
              const SizedBox(height: 8),
              const Text(
                'Start documenting your learnings!',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Go to the Reflections tab to share your insights and growth.',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ReflectionCategory {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> prompts;

  ReflectionCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.prompts,
  });
}

class SkillCategory {
  final String title;
  final List<String> skills;

  SkillCategory({
    required this.title,
    required this.skills,
  });
}
